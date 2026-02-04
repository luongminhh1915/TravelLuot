<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - TravelLuot</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="fb-auth-page">
    <div class="fb-auth-card card">
        <div class="auth-header">
            <h1><i class="bi bi-airplane me-1"></i> TravelLuot</h1>
            <p>Tạo tài khoản mới — nhanh chóng và dễ dàng</p>
        </div>
        <div class="card-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger py-2">${error}</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="mb-3">
                    <label class="form-label">Họ và tên</label>
                    <input type="text" name="fullName" class="form-control" value="${param.fullName}" placeholder="Họ và tên (tùy chọn)">
                </div>
                <div class="mb-3">
                    <label class="form-label">Tên đăng nhập</label>
                    <input type="text" name="username" class="form-control" required value="${param.username}" placeholder="Tên đăng nhập" pattern="[a-zA-Z0-9_]+" title="Chỉ chữ, số, gạch dưới">
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" required value="${param.email}" placeholder="Email">
                </div>
                <div class="mb-3">
                    <label class="form-label">Mật khẩu</label>
                    <input type="password" name="password" class="form-control" required minlength="6" placeholder="Tối thiểu 6 ký tự">
                </div>
                <div class="mb-3">
                    <label class="form-label">Xác nhận mật khẩu</label>
                    <input type="password" name="confirmPassword" class="form-control" required placeholder="Nhập lại mật khẩu">
                </div>
                <button type="submit" class="btn btn-primary w-100 mb-2">Đăng ký</button>
            </form>
            <div class="auth-footer">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
