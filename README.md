# HƯỚNG DẪN BIÊN DỊCH GIÁO ÁN TOÁN 12 (LATEX SANG PDF)

Tài liệu hướng dẫn cài đặt môi trường LaTeX (TeX Live hoặc MiKTeX) và cách sử dụng script `compile_tex.sh` để tự động biên dịch hàng loạt file `.tex` sang PDF.

---

## 1. Cài đặt môi trường LaTeX

Bạn có thể lựa chọn 1 trong 2 bộ phân phối LaTeX phổ biến bên dưới:

### Cách 1: Sử dụng TeX Live (Khuyên dùng cho Linux / Ubuntu)

Chạy lệnh sau trong Terminal để cài đặt đầy đủ trình biên dịch, font chữ, gói vẽ hình TikZ và hỗ trợ tiếng Việt T5:

```bash
sudo apt update
sudo apt install -y texlive-latex-base texlive-latex-recommended texlive-latex-extra \
                    texlive-fonts-recommended texlive-lang-other texlive-pictures \
                    texlive-science latexmk
```

> ⚠️ **Lưu ý quan trọng**: Gói `texlive-lang-other` là **bắt buộc** để biên dịch tiếng Việt (`\usepackage[T5]{fontenc}`). Nếu thiếu gói này, toàn bộ file sẽ báo lỗi `t5enc.def not found`.

---

### Cách 2: Sử dụng MiKTeX (Nếu muốn trình quản lý tự tải package khi cần)

Nếu chọn dùng MiKTeX trên Ubuntu, cần cài đặt kèm khoá GPG chuẩn xác để tránh lỗi `NO_PUBKEY`:

```bash
# 1. Tải và thêm GPG key của MiKTeX
curl -fsSL https://miktex.org/download/key | sudo gpg --dearmor -o /usr/share/keyrings/miktex.gpg

# 2. Thêm kho lưu trữ (thay <version> bằng codename Ubuntu như noble, jammy)
echo "deb [signed-by=/usr/share/keyrings/miktex.gpg] https://miktex.org/download/ubuntu noble universe" | sudo tee /etc/apt/sources.list.d/miktex.list

# 3. Cập nhật và cài đặt MiKTeX
sudo apt update && sudo apt install -y miktex
miktexsetup finish
```

---

## 2. Cách chạy Script ngắn gọn

### Chuẩn bị (chỉ làm 1 lần đầu):

Cấp quyền thực thi cho file script:

```bash
chmod +x compile_tex.sh
```

### Câu lệnh chạy:

| Nhu cầu                                              | Lệnh chạy                                                       |
| :---------------------------------------------------- | :---------------------------------------------------------------- |
| **Biên dịch TOÀN BỘ dự án**               | `./compile_tex.sh .`                                            |
| **Biên dịch một chương** (vd: Chương 1)  | `./compile_tex.sh ./chuong1`                                    |
| **Biên dịch một bài học** (vd: Bài 1.1)   | `./compile_tex.sh ./chuong1/bai1-1`                             |
| **Biên dịch bài kiểm tra** (vd: TX1)        | `./compile_tex.sh ./tx1-202601`                                 |
| **Chế độ hỏi đường dẫn** (tương tác) | `./compile_tex.sh` *(sau đó nhập đường dẫn và Enter)* |

---

## 3. Các lỗi thường gặp & Cách khắc phục nhanh

### 1. Lỗi thiếu gói tiếng Việt: `Encoding file 't5enc.def' not found`

- **Nguyên nhân**: Hệ thống chưa có gói ngôn ngữ khác của TeX Live.
- **Khắc phục**:
  ```bash
  sudo apt install -y texlive-lang-other
  ```

---

### 2. Lỗi `sudo apt update` bị chặn do kho MiKTeX (`NO_PUBKEY 277A7293F59E4889`)

- **Nguyên nhân**: File cấu hình `/etc/apt/sources.list.d/miktex.list` bị thiếu khoá hoặc sai phiên bản Ubuntu.
- **Khắc phục**:
  Nếu bạn đã dùng TeX Live thì không cần MiKTeX, chỉ cần xóa file cấu hình này:
  ```bash
  sudo rm -f /etc/apt/sources.list.d/miktex.list
  sudo apt update
  ```

---

### 3. Lỗi thiếu file ảnh: `Package pdftex.def Error: File 'xxx.png' not found`

- **Nguyên nhân**: File `.tex` có lệnh `\includegraphics{ten_anh.png}` nhưng file ảnh không tồn tại trong cùng thư mục (hoặc viết sai chữ hoa/thường).
  - *Ví dụ thực tế*: File `chuong3/bai1.2.tex` yêu cầu ảnh `anh1.2.1.png`.
- **Khắc phục**:
  - Đảm bảo file ảnh đã được copy vào cùng thư mục với file `.tex`.
  - Kiểm tra đúng chính xác định dạng đuôi (`.png`, `.jpg`, `.pdf`).

---

### 4. Lỗi `Permission denied` khi chạy script

- **Khắc phục**:
  ```bash
  chmod +x compile_tex.sh
  ```

---

### 5. Cách kiểm tra nguyên nhân khi một file bị báo lỗi

Khi script báo `❌ Biên dịch thất bại!`, xem trực tiếp các dòng cuối của file `.log` tương ứng:

```bash
tail -n 35 <đường-dẫn-file>.log
```

*Ví dụ*:

```bash
tail -n 35 chuong3/bai1.2.log
```

Dòng bắt đầu bằng dấu `!` sẽ chỉ ra dòng mã LaTeX nào bị lỗi.
