# TravelLuot – Mạng xã hội du lịch

Web hoàn chỉnh với các chức năng:

- **Đăng ký / Đăng nhập** – Session, hash mật khẩu SHA-256
- **Đăng bài** – Nội dung, check-in địa điểm, tải ảnh (nhiều ảnh)
- **Check-in** – Chọn địa điểm có sẵn hoặc nhập địa điểm mới (tên + thành phố)
- **Like** – Like/bỏ like bài viết
- **Comment** – Bình luận bài viết
- **Follow** – Theo dõi / bỏ theo dõi người dùng (trang chủ và trang cá nhân)
- **Ảnh du lịch** – Upload ảnh khi đăng bài (multipart), hiển thị trong feed

## Cấu trúc

- `src/java/model/` – Entity (User, Post, Location, Comment, …)
- `src/java/dal/` – DAO + DBConnect (SQL Server)
- `src/java/controller/` – Servlet (Login, Register, Home, Post, Like, Comment, Follow, Profile)
- `src/java/util/` – PasswordUtil (hash/check)
- `web/*.jsp` – login, register, home (feed), profile
- `web/css/style.css` – Giao diện

## Chạy

1. **Database**: Chạy script SQL tạo database `travel_luot` và các bảng (script bạn đã có). Tùy chọn: chạy thêm `sql/seed_locations.sql` để thêm vài địa điểm mẫu.

2. **Kết nối DB**: Trong `dal/DBConnect.java` chỉnh `url`, `user`, `pass` cho đúng SQL Server của bạn.

3. **Build & chạy**: Mở project trong NetBeans, Clean and Build, Run. Ứng dụng chạy trên Tomcat (context path `/luot`).

4. **Truy cập**: Mở `http://localhost:8080/luot` → chuyển tới login; đăng ký tài khoản mới rồi đăng nhập.

## Luồng chính

- **/** hoặc **/luot** → index.jsp → redirect tới /home (nếu đã đăng nhập) hoặc /login
- **/login** – Form đăng nhập (username hoặc email + password)
- **/register** – Đăng ký (username, email, password, họ tên)
- **/home** – Feed: form đăng bài (nội dung + check-in + ảnh), danh sách bài của mình và người đang follow
- **/post** (POST) – Tạo bài (content, locationId hoặc locationName+city, file ảnh)
- **/like** (POST) – Bật/tắt like bài (postId)
- **/comment** (POST) – Thêm comment (postId, content)
- **/follow** (POST) – Bật/tắt follow (userId)
- **/profile** – Trang cá nhân (id=… hoặc mặc định là user hiện tại), nút Follow, danh sách bài
- **/logout** – Xóa session, redirect về /login

 Ảnh upload lưu trong thư mục `web/uploads/` (tự tạo), URL lưu DB dạng `/luot/uploads/xxx.jpg`.
