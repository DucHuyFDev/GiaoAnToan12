#!/usr/bin/env bash

# ==============================================================================
# Script tự động biên dịch tất cả file .tex sang .pdf trong thư mục chỉ định
# ==============================================================================

# Màu sắc thông báo trên terminal
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
BOLD="\033[1m"
NC="\033[0m" # No Color

# 1. Nhận hoặc yêu cầu nhập đường dẫn thư mục
TARGET_DIR="${1:-}"

if [ -z "$TARGET_DIR" ]; then
    echo -e "${CYAN}=== CÔNG CỤ TỰ ĐỘNG BIÊN DỊCH LATEX SANG PDF ===${NC}"
    read -rp "Nhập đường dẫn thư mục chứa file .tex (nhấn Enter để chọn thư mục hiện tại '.'): " TARGET_DIR
    TARGET_DIR="${TARGET_DIR:-.}"
fi

# Kiểm tra đường dẫn tồn tại
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}❌ Lỗi: Thư mục '$TARGET_DIR' không tồn tại!${NC}"
    exit 1
fi

TARGET_DIR_ABS=$(cd "$TARGET_DIR" && pwd)
echo -e "${BLUE}📂 Thư mục làm việc:${NC} $TARGET_DIR_ABS"
echo "------------------------------------------------------------"

# 2. Kiểm tra trình biên dịch (ưu tiên latexmk, dự phòng pdflatex)
USE_LATEXMK=false
if command -v latexmk >/dev/null 2>&1; then
    USE_LATEXMK=true
    echo -e "⚙️  Trình biên dịch: ${GREEN}latexmk${NC} (tự động biên dịch đủ số lần cho nhãn/mục lục)"
elif command -v pdflatex >/dev/null 2>&1; then
    echo -e "⚙️  Trình biên dịch: ${YELLOW}pdflatex${NC}"
else
    echo -e "${RED}❌ Lỗi: Không tìm thấy 'latexmk' hoặc 'pdflatex' trên máy!${NC}"
    echo "Hãy cài đặt bằng lệnh: sudo apt update && sudo apt install -y texlive-latex-extra texlive-lang-other latexmk"
    exit 1
fi

# 2.1 Tiền kiểm tra gói tiếng Việt T5 (bắt buộc cho giáo án tiếng Việt)
if ! kpsewhich t5enc.def >/dev/null 2>&1; then
    echo -e "${RED}⚠️  CẢNH BÁO HỆ THỐNG THIẾU GÓI TIẾNG VIỆT (T5):${NC}"
    echo -e "   File cấu hình font chữ '${YELLOW}t5enc.def${NC}' chưa được cài đặt trên hệ thống."
    echo -e "   Điều này sẽ khiến toàn bộ các file .tex bị lỗi '${RED}Encoding file t5enc.def not found${NC}'."
    echo ""
    echo -e "👉 ${BOLD}Vui lòng mở một Terminal mới và chạy lệnh sau để cài đặt:${NC}"
    echo -e "   ${GREEN}sudo apt update && sudo apt install -y texlive-lang-other${NC}"
    echo ""
    read -rp "Bạn có muốn tiếp tục chạy thử dù có thể bị lỗi không? (y/N): " CONTINUE_CHOICE
    if [[ ! "$CONTINUE_CHOICE" =~ ^[Yy]$ ]]; then
        echo "Đã huỷ tiến trình. Vui lòng cài gói trên rồi chạy lại script!"
        exit 1
    fi
    echo "------------------------------------------------------------"
fi

# 3. Tìm kiếm toàn bộ file .tex (bao gồm cả thư mục con)
mapfile -t TEX_FILES < <(find "$TARGET_DIR_ABS" -type f -name "*.tex" | sort)
TOTAL_FILES=${#TEX_FILES[@]}

if [ "$TOTAL_FILES" -eq 0 ]; then
    echo -e "${YELLOW}ℹ️  Không tìm thấy file .tex nào trong '$TARGET_DIR_ABS'.${NC}"
    exit 0
fi

echo -e "🔍 Tìm thấy ${BOLD}$TOTAL_FILES${NC} file .tex cần biên dịch."
echo "------------------------------------------------------------"

SUCCESS_COUNT=0
FAILED_COUNT=0
FAILED_FILES=()
START_TIME=$(date +%s)

# 4. Duyệt qua từng file và biên dịch
INDEX=1
for file in "${TEX_FILES[@]}"; do
    FILE_NAME=$(basename "$file")
    FILE_DIR=$(dirname "$file")
    BASE_NAME="${FILE_NAME%.tex}"

    echo -e "${CYAN}[$INDEX/$TOTAL_FILES]${NC} Đang xử lý: ${BOLD}$FILE_NAME${NC}"
    echo "         Đường dẫn: $FILE_DIR"

    # Chuyển vào thư mục chứa file để hình ảnh và các file nhúng phụ thuộc được nhận diện đúng
    pushd "$FILE_DIR" >/dev/null || continue

    COMPILE_SUCCESS=false

    if [ "$USE_LATEXMK" = true ]; then
        # Biên dịch với latexmk
        if latexmk -pdf -interaction=nonstopmode -halt-on-error "$FILE_NAME" >/dev/null 2>&1; then
            COMPILE_SUCCESS=true
            # Dọn bớt các file phụ trợ sinh ra (.aux, .fls, v.v.), vẫn giữ lại file .pdf
            latexmk -c "$FILE_NAME" >/dev/null 2>&1
        fi
    else
        # Biên dịch 2 lần với pdflatex để chuẩn mục lục và ref
        if pdflatex -interaction=nonstopmode -halt-on-error "$FILE_NAME" >/dev/null 2>&1 && \
           pdflatex -interaction=nonstopmode -halt-on-error "$FILE_NAME" >/dev/null 2>&1; then
            COMPILE_SUCCESS=true
            # Dọn dẹp file tạm
            rm -f "${BASE_NAME}.aux" "${BASE_NAME}.log" "${BASE_NAME}.out" "${BASE_NAME}.toc" "${BASE_NAME}.synctex.gz"
        fi
    fi

    popd >/dev/null || true

    if [ "$COMPILE_SUCCESS" = true ]; then
        echo -e "  ${GREEN}✅ Xuất PDF thành công:${NC} ${FILE_DIR}/${BASE_NAME}.pdf"
        ((SUCCESS_COUNT++))
    else
        echo -e "  ${RED}❌ Biên dịch thất bại!${NC} (Xem log lỗi chi tiết tại: ${FILE_DIR}/${BASE_NAME}.log)"
        ((FAILED_COUNT++))
        FAILED_FILES+=("$file")
    fi

    ((INDEX++))
    echo ""
done

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

# 5. Tổng kết
echo "============================================================"
echo -e "${BOLD}📊 KẾT QUẢ BIÊN DỊCH (Thời gian: ${ELAPSED}s):${NC}"
echo -e "   - Tổng số file: ${TOTAL_FILES}"
echo -e "   - Thành công:   ${GREEN}${SUCCESS_COUNT}${NC}"
echo -e "   - Thất bại:     ${RED}${FAILED_COUNT}${NC}"

if [ "$FAILED_COUNT" -gt 0 ]; then
    echo ""
    echo -e "${RED}Danh sách các file lỗi:${NC}"
    for failed in "${FAILED_FILES[@]}"; do
        echo -e "   • $failed"
    done
    echo ""
    echo -e "${YELLOW}Gợi ý khắc phục lỗi phổ biến:${NC}"
    echo "1. Nếu báo thiếu gói font T5 (t5enc.def): Chạy 'sudo apt install texlive-lang-other'"
    echo "2. Xem 30 dòng cuối của file .log tương ứng để biết chi tiết lỗi cú pháp LaTeX."
fi
echo "============================================================"
