# WORKSPACE RULES: HỆ THỐNG BIÊN SOẠN GIÁO ÁN & TÀI LIỆU TOÁN 12

> **Phạm vi áp dụng:** Toàn bộ thư mục dự án `GiaoAnToan12`. Tất cả các tác vụ tạo mới, chỉnh sửa giáo án, bài giảng lý thuyết, đề cương ôn tập, biên soạn đề kiểm tra và xuất bản PDF phải tuân thủ nghiêm ngặt các quy tắc dưới đây.

---

## 1. NGUYÊN TẮC CỐT LÕI & QUY TRÌNH LÀM VIỆC

1. **Nghiên cứu tài liệu mẫu trước khi biên soạn:**
   - Trước khi tạo bài học, đề cương hoặc đề thi mới, **bắt buộc** phải đọc tham chiếu các file mẫu có sẵn trong project (`chuong1/` đến `chuong4/`, `tx1-202601/` đến `tx3-202601/`) để lấy đúng cấu hình Preamble, quy cách đặt tên lệnh, phong cách vẽ hình TikZ và văn phong trình bày.
2. **Quy tắc biên dịch tự động:**
   - Mọi file `.tex` tạo ra phải biên dịch thành công qua script `./compile_tex.sh <thư_mục>`.
   - Tuyệt đối không để phát sinh lỗi font tiếng Việt, thiếu thư viện TikZ hoặc thiếu hình ảnh phụ thuộc.
   - Luôn kiểm tra kết quả biên dịch và trực quan hóa file PDF trước khi bàn giao.

---

## 2. QUY CÁCH KỸ THUẬT CHUNG (PREAMBLE & GIAO DIỆN)

### 2.1. Cấu hình trang & Bảng mã tiếng Việt
- **Khổ giấy & Căn lề:** `\documentclass[12pt]{article}`, `\usepackage[margin=2cm]{geometry}`.
- **Bảng mã Tiếng Việt:** 
  ```latex
  \usepackage[utf8]{inputenc}
  \usepackage[T5]{fontenc}
  \usepackage[vietnamese]{babel}
  ```
- **Toán học & Định dạng:** `amsmath, amssymb, amsthm`, `enumitem` (khoảng cách dòng thoáng `itemsep=4pt` đến `6pt`), `multicol` cho các phương án trắc nghiệm, `booktabs`, `array`.
- **Header & Footer:** Dùng `fancyhdr`, đánh số trang ở giữa chân trang (`\fancyfoot[C]{\thepage}` hoặc `Trang \thepage`), đầu trang ghi loại tài liệu và tiêu đề bài.
- **Mục lục:** Dùng `tocloft`, tinh chỉnh khoảng cách `\cftsecnumwidth`, `\cftsubsecindent` để tránh đè chữ.

### 2.2. Đồ thị & Hình học nội sinh (TikZ / PGFPlots)
- **Ưu tiên nội sinh tuyệt đối:** Tất cả hình vẽ hình học phẳng, hình không gian và đồ thị hàm số phải được vẽ bằng **TikZ / PGFPlots** (`pgfplotsset{compat=1.18}`). Hạn chế tối đa dùng hình ảnh bitmap bên ngoài.
- **Thư viện TikZ bắt buộc nạp:**
  ```latex
  \usetikzlibrary{calc, angles, quotes, intersections, arrows.meta, 3d, patterns, positioning}
  ```

---

## 3. QUY CHUẨN BIÊN SOẠN BÀI HỌC / CHUYÊN ĐỀ LÝ THUYẾT

Mỗi tài liệu bài học bao gồm cấu trúc chuẩn gồm 4 Phần chính:

### 3.1. Phần Mở đầu (Trước Phần I)
1. **Tiêu đề bài học:** In hoa đậm cỡ `\LARGE`, ghi rõ Môn, Lớp, Thời lượng.
2. **Mục tiêu bài học:** Chuẩn chương trình GDPT 2018 (1. Kiến thức, 2. Kĩ năng, 3. Phẩm chất & Năng lực).
3. **Mục lục tự động:** `\setcounter{tocdepth}{2}`, `\tableofcontents`, sang trang mới `\newpage`.

### 3.2. Phần I. Lý thuyết trọng tâm
- **Nội dung:** Định nghĩa, định lý, công thức, bảng tổng kết và sơ đồ tư duy.
- **Ví dụ & Lời giải mẫu:** Dùng hộp `tcolorbox`:
  - Hộp ví dụ: môi trường `vidu`.
  - Hộp lời giải: môi trường `loigiai`.
- ⚠️ **QUY ƯỚC VỀ VĂN PHONG VÀ MINH HỌA TRỰC QUAN:** 
  - Diễn đạt sư phạm, khúc chiết, mạch lạc, dễ hiểu nhưng phải tuyệt đối đúng chuẩn văn phong toán học - khoa học, gắn liền bản chất khái niệm để học sinh nắm vững.
  - Ở các khái niệm trừu tượng, mô hình hình học hay ý nghĩa vật lý (như đồ thị $v(t)$, diện tích dưới đường cong, giá trị trung bình...), **bắt buộc phải có hình vẽ minh họa nội sinh (TikZ / PGFPlots)** để nâng cao tính trực quan và thẩm mỹ cho giáo trình.

### 3.3. Phần II. Bài tập tự luyện (Hệ thống 3 Khung)
- **Phân chia theo dạng toán:** Mỗi chủ đề chia thành các Dạng toán rõ ràng (`\subsection{Dạng 1: ...}`).
- **Hệ thống 3 khung rèn luyện:**
  - Khung xanh: môi trường `btxanh`.
  - Khung vàng: môi trường `btvang`.
  - Khung đỏ: môi trường `btdo`.
- ⚠️ **LƯU Ý CỐT LÕI VỀ ĐỘ KHÓ 3 KHUNG:** 
  - Độ khó của 3 khung câu hỏi xanh, vàng, đỏ là **HOÀN TOÀN NHƯ NHAU**, không phân vùng độ khó. Đây là 3 bài tập rèn luyện tương đương nhau nhằm giúp học sinh củng cố kiến thức theo nhiều biến thể tương tự.
- ⚠️ **QUY ƯỚC BẮT BUỘC VỀ GIAO DIỆN KHUNG (Áp dụng cho toàn bộ giáo trình):** 
  - Tuyệt đối **KHÔNG** dùng bất kỳ textbox hay ô tiêu đề nổi nào ở đầu khung (không dùng `attach boxed title`, không có nhãn chữ "Khung Xanh:...", "Khung Vàng:...").
  - Mỗi khung chỉ là **MỘT KHUNG HÌNH CHỮ NHẬT BO GÓC DUY NHẤT** mang màu sắc đặc trưng (viền và nền) tương ứng, bên trong trực tiếp chứa nội dung đề bài.
  - Cấu hình tcolorbox chuẩn:
    ```latex
    \newtcolorbox{btxanh}{colback=blue!5!white, colframe=blue!65!black, arc=2.5mm, boxrule=1pt, left=4mm, right=4mm, top=3mm, bottom=3mm, breakable, enhanced}
    \newtcolorbox{btvang}{colback=yellow!10!white, colframe=orange!80!black, arc=2.5mm, boxrule=1pt, left=4mm, right=4mm, top=3mm, bottom=3mm, breakable, enhanced}
    \newtcolorbox{btdo}{colback=red!5!white, colframe=red!65!black, arc=2.5mm, boxrule=1pt, left=4mm, right=4mm, top=3mm, bottom=3mm, breakable, enhanced}
    ```

### 3.4. Phần III. Hệ thống câu hỏi trắc nghiệm tổng hợp
- *3.1. Trắc nghiệm nhiều phương án lựa chọn (MCQ):* 4 phương án A, B, C, D chia 2 hoặc 4 cột.
- *3.2. Trắc nghiệm Đúng / Sai (T/FQ):* Mỗi câu gồm 4 ý a), b), c), d).
- *3.3. Trắc nghiệm Trả lời ngắn (Short Answer):*
  - ⚠️ **LƯU Ý:** Chỉ dùng khoảng trống / space (`\vspace{...}`) hợp lý giữa các câu để tạo sự phân tách, tránh dính mắt. **TUYỆT ĐỐI KHÔNG DÙNG underline (`\underline{...}`) hoặc gạch chân để trả lời.**

### 3.5. Phần IV. Kết luận & Tóm tắt trọng tâm
- Sơ đồ tư duy, bảng đối chiếu tổng kết.
- Các sai lầm thường gặp và lưu ý thực hành khi làm bài.

---

## 4. QUY CHUẨN BIÊN SOẠN ĐỀ CƯƠNG ÔN TẬP & ĐỀ THI

### 4.1. Tài liệu Đề cương ôn tập
- **Trang bìa riêng (`titlepage`):** Tiêu đề *ĐỀ CƯƠNG ÔN TẬP*, tên đợt kiểm tra, *Lớp: 2026 - L01*, ghi chú *(Lưu hành nội bộ)*.
- **Nội dung:** Gồm chuỗi các đề thi luyện tập liên tiếp (Đề 1, Đề 2, Đề 3...). Mỗi đề bắt đầu trên một trang mới (`\newpage`) và cấu trúc đề tương thích với quy chuẩn Đề kiểm tra chính thức.

### 4.2. Tài liệu Bài kiểm tra (Đề chính thức 90 phút)
- **Header:**
  - Trái: `\small\textit{Bài kiểm tra thường xuyên / Cuối kỳ X — Lớp: 2026 - L01}`
  - Phải: `\small\textbf{ĐỀ CHÍNH THỨC}`
- **Cấu trúc 4 phần theo chuẩn định dạng thi tốt nghiệp THPT từ năm 2025:**
  - **PHẦN I. Câu trắc nghiệm nhiều phương án lựa chọn (12 câu):** Chọn 1 trong 4 đáp án A, B, C, D (0,25 điểm/câu).
  - **PHẦN II. Câu trắc nghiệm đúng sai (2 - 4 câu):** Mỗi câu 4 ý a, b, c, d (chấm điểm lũy tiến 0,1đ - 0,25đ - 0,5đ - 1,0đ).
  - **PHẦN III. Câu trắc nghiệm trả lời ngắn (4 câu):** Học sinh điền đáp số; có khoảng cách giữa các câu cho thoáng, không có gạch chân.
  - **PHẦN IV. Tự luận (2 - 3 bài):** Yêu cầu học sinh trình bày lời giải chi tiết (bài toán tối ưu thực tế, tiếp tuyến, hình không gian $Oxyz$).

---

## 5. QUY ĐỊNH VỀ CHẾ TÁC & BIÊN SOẠN CÂU HỎI

1. **Nguyên tắc bảo toàn độ khó & mức độ vận dụng kiến thức:**
   - Khi nhận câu hỏi mẫu và được yêu cầu chế thêm câu hỏi, nếu không có yêu cầu thay đổi độ khó từ người dùng, tất cả câu chế ra **bắt buộc phải có độ khó và mức độ vận dụng kiến thức tương đương** câu gốc (tương đồng về số bước tính toán, bản chất toán học, mức độ tư duy, chỉ thay đổi số liệu/ngữ cảnh/hàm số phù hợp).
2. **Bám sát chương trình GDPT 2018 & tài liệu mẫu:**
   - Nội dung chuyên môn, phạm vi định lý, cách đặt câu hỏi phải bám sát chương trình và các tài liệu mẫu trong project.
3. **Quy tắc xáo trộn đáp án:**
   - **MCQ (Trắc nghiệm đơn):** Phải **xáo trộn ngẫu nhiên** vị trí đáp án đúng giữa A, B, C, D, phân bổ tương đối đồng đều, không tạo bất kỳ chu kỳ hay quy luật nào có thể đoán trước.
   - **Đúng / Sai (T/FQ):** Trạng thái Đúng/Sai của 4 ý a), b), c), d) phải được phân bố tự nhiên, không cố định mẫu (như không để toàn Đ, toàn S, hay các mẫu đoán định).
4. **Quy chuẩn đáp số câu Trả lời ngắn:**
   - Đáp án của câu trả lời ngắn **CHỈ ĐƯỢC PHÉP LÀ SỐ NGUYÊN HOẶC SỐ THẬP PHÂN**.
   - Tuyệt đối không để kết quả dưới dạng phân số, căn thức chưa tính toán, biểu thức chứa $\pi$ hay biến số.
   - Nếu kết quả là số thập phân cần làm tròn, trong đề bài **BẮT BUỘC PHẢI NÊU RÕ** yêu cầu làm tròn (ví dụ: *"làm tròn kết quả đến hàng phần mười"* hoặc *"làm tròn đến chữ số thập phân thứ hai"*).

---

## 6. QUY ĐỊNH VỀ FILE ĐÁP ÁN (ANSWER KEY)

1. **Tính đồng thời:** Khi ra bất kỳ bộ câu hỏi nào (đề thi, đề cương hay bài học), phải cung cấp đồng thời đáp án vào file đáp án tương ứng (hoặc bảng đáp án cuối file/file `dapan.tex` riêng).
2. **Cấu trúc file đáp án đầy đủ cả 4 phần:**
   - **Phần I (MCQ):** Bảng đáp án A, B, C, D tương ứng từng câu.
   - **Phần II (Đúng/Sai):** Bảng kết quả Đ/S chi tiết cho từng ý a), b), c), d).
   - **Phần III (Trả lời ngắn):** Giá trị số nguyên hoặc số thập phân chính xác của từng câu.
   - **Phần IV (Tự luận / Phần 3 khung bài tập):**
     - Nếu bài toán cho ra một **kết quả cụ thể** (tìm toạ độ, tính diện tích/thể tích, tìm giá trị lớn nhất/nhỏ nhất, hệ số góc...): ghi đáp án số / toạ độ cuối cùng.
     - Nếu là bài toán **chứng minh**, vẽ bảng biến thiên, khảo sát đồ thị, hoặc các bài toán **không ra một kết quả cụ thể đơn lẻ**: ghi dấu `x`.
