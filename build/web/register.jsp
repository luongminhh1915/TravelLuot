<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - TravelLuot</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">
    <div class="auth-card card shadow">
        <div class="card-body p-4">
            <h1 class="h3 mb-4 text-center">✈ TravelLuot</h1>
            <p class="text-muted text-center mb-4">Tạo tài khoản mới</p>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="mb-3">
                    <label class="form-label">Tên đăng nhập</label>
                    <input type="text" name="username" class="form-control" required
                           value="${param.username}" placeholder="username" pattern="[a-zA-Z0-9_]+" title="Chỉ chữ, số, gạch dưới">
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" required value="${param.email}" placeholder="email@example.com">
                </div>
                <div class="mb-3">
                    <label class="form-label">Họ tên</label>
                    <input type="text" name="fullName" class="form-control" value="${param.fullName}" placeholder="Họ tên (tùy chọn)">
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
            <p class="text-center mt-3 mb-0">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
            </p>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
