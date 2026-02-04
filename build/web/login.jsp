<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - TravelLuot</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="auth-page">
    <div class="auth-card card shadow">
        <div class="card-body p-4">
            <h1 class="h3 mb-4 text-center">✈ TravelLuot</h1>
            <p class="text-muted text-center mb-4">Chia sẻ chuyến đi của bạn</p>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${param.registered == '1'}">
                <div class="alert alert-success">Đăng ký thành công. Vui lòng đăng nhập.</div>
            </c:if>
            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-3">
                    <label class="form-label">Tên đăng nhập hoặc Email</label>
                    <input type="text" name="username" class="form-control" required autofocus
                           value="${param.username}" placeholder="username hoặc email">
                </div>
                <div class="mb-3">
                    <label class="form-label">Mật khẩu</label>
                    <input type="password" name="password" class="form-control" required placeholder="Mật khẩu">
                </div>
                <button type="submit" class="btn btn-primary w-100 mb-2">Đăng nhập</button>
            </form>
            <p class="text-center mt-3 mb-0">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký</a>
            </p>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
