<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - TravelLuot</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="fb-auth-page">
    <div class="fb-auth-card card">
        <div class="auth-header">
            <h1><i class="bi bi-airplane me-1"></i> TravelLuot</h1>
            <p>Chia sẻ chuyến đi của bạn</p>
        </div>
        <div class="card-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger py-2">${error}</div>
            </c:if>
            <c:if test="${param.registered == '1'}">
                <div class="alert alert-success py-2">Đăng ký thành công. Vui lòng đăng nhập.</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-3">
                    <label class="form-label">Email hoặc tên đăng nhập</label>
                    <input type="text" name="username" class="form-control" required autofocus
                           value="${param.username}" placeholder="Nhập email hoặc tên đăng nhập">
                </div>
                <div class="mb-3">
                    <label class="form-label">Mật khẩu</label>
                    <input type="password" name="password" class="form-control" required placeholder="Mật khẩu">
                </div>
                <button type="submit" class="btn btn-primary w-100 mb-2">Đăng nhập</button>
            </form>
            <div class="auth-footer">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Tạo tài khoản mới</a>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
