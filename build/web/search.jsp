<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm bạn bè - TravelLuot</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <%-- Navbar giống Facebook --%>
    <nav class="navbar navbar-expand-lg fb-navbar">
        <div class="container-fluid px-3">
            <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/home">
                <i class="bi bi-airplane me-1"></i> TravelLuot
            </a>
            <form class="d-none d-md-flex flex-grow-1 justify-content-center mx-3" action="${pageContext.request.contextPath}/search" method="get">
                <input class="form-control" type="search" name="q" value="${q}" placeholder="Tìm kiếm bạn bè" aria-label="Search" style="max-width: 320px;">
            </form>
            <div class="d-flex align-items-center gap-1">
                <a class="nav-link" href="${pageContext.request.contextPath}/home" title="Trang chủ">
                    <i class="bi bi-house-door-fill fs-5"></i>
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/profile" title="Cá nhân">
                    <i class="bi bi-person-circle fs-5"></i>
                </a>
                <div class="dropdown">
                    <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <img src="${not empty me.avatarUrl ? me.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty me.avatarUrl ? me.username : ''}" alt="" class="user-avatar-nav">
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="bi bi-person me-2"></i>Trang cá nhân</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <div class="fb-layout">
        <aside class="fb-sidebar-left d-none d-lg-block">
            <div class="fb-shortcuts">
                <a href="${pageContext.request.contextPath}/profile" class="shortcut-item">
                    <img src="${not empty me.avatarUrl ? me.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty me.avatarUrl ? me.username : ''}" alt="">
                    <span>${not empty me.fullName ? me.fullName : me.username}</span>
                </a>
                <a href="${pageContext.request.contextPath}/search" class="shortcut-item">
                    <i class="bi bi-search text-primary" style="font-size: 1.5rem; width: 36px; text-align: center;"></i>
                    <span>Tìm kiếm bạn bè</span>
                </a>
            </div>
        </aside>

        <main class="fb-feed">
            <div class="fb-post-card">
                <div class="p-3 border-bottom d-flex align-items-center justify-content-between">
                    <h6 class="mb-0 fw-bold"><i class="bi bi-search me-2"></i>Tìm kiếm bạn bè</h6>
                    <form class="d-flex gap-2" action="${pageContext.request.contextPath}/search" method="get" style="max-width: 360px; width: 100%;">
                        <input type="text" class="form-control" name="q" value="${q}" placeholder="Nhập tên hoặc username...">
                        <button class="btn btn-primary" type="submit">Tìm</button>
                    </form>
                </div>

                <div class="p-3">
                    <c:if test="${empty q}">
                        <p class="text-muted mb-0">Nhập từ khóa để tìm bạn bè.</p>
                    </c:if>

                    <c:if test="${not empty q}">
                        <c:if test="${empty results}">
                            <div class="text-center text-muted py-4">
                                <i class="bi bi-emoji-frown fs-1"></i>
                                <p class="mt-2 mb-0">Không tìm thấy kết quả cho <strong>${q}</strong>.</p>
                            </div>
                        </c:if>

                        <c:forEach items="${results}" var="u">
                            <c:set var="isFollowing" value="${false}" />
                            <c:forEach items="${followingIds}" var="fid">
                                <c:if test="${fid == u.id}">
                                    <c:set var="isFollowing" value="${true}" />
                                </c:if>
                            </c:forEach>

                            <div class="d-flex align-items-center justify-content-between p-2 rounded-3 mb-2" style="background: var(--fb-bg);">
                                <div class="d-flex align-items-center gap-3">
                                    <a href="${pageContext.request.contextPath}/profile?id=${u.id}">
                                        <img src="${not empty u.avatarUrl ? u.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty u.avatarUrl ? u.username : ''}" alt="" style="width:48px;height:48px;border-radius:50%;object-fit:cover;">
                                    </a>
                                    <div>
                                        <a class="fw-semibold text-decoration-none text-dark" href="${pageContext.request.contextPath}/profile?id=${u.id}">
                                            ${not empty u.fullName ? u.fullName : u.username}
                                        </a>
                                        <div class="text-muted small">@${u.username}</div>
                                        <c:if test="${not empty u.bio}">
                                            <div class="small text-muted">${u.bio}</div>
                                        </c:if>
                                    </div>
                                </div>
                                <form action="${pageContext.request.contextPath}/follow" method="post" class="ms-3">
                                    <input type="hidden" name="userId" value="${u.id}">
                                    <button type="submit" class="btn ${isFollowing ? 'btn-secondary' : 'btn-primary'} btn-sm fb-btn-follow">
                                        <i class="bi ${isFollowing ? 'bi-person-check' : 'bi-person-plus'} me-1"></i>
                                        ${isFollowing ? 'Bỏ theo dõi' : 'Follow'}
                                    </button>
                                </form>
                            </div>
                        </c:forEach>
                    </c:if>
                </div>
            </div>
        </main>

        <aside class="fb-sidebar-right d-none d-xl-block"></aside>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

