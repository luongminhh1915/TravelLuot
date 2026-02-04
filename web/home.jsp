<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - TravelLuot</title>
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
                <input class="form-control" type="search" name="q" placeholder="Tìm kiếm bạn bè" aria-label="Search" style="max-width: 320px;">
            </form>
            <div class="d-flex align-items-center gap-1">
                <a class="nav-link active" href="${pageContext.request.contextPath}/home" title="Trang chủ">
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
        <%-- Sidebar trái - Shortcuts --%>
        <aside class="fb-sidebar-left d-none d-lg-block">
            <div class="fb-shortcuts">
                <a href="${pageContext.request.contextPath}/home" class="shortcut-item">
                    <img src="${not empty me.avatarUrl ? me.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty me.avatarUrl ? me.username : ''}" alt="">
                    <span>${not empty me.fullName ? me.fullName : me.username}</span>
                </a>
                <a href="${pageContext.request.contextPath}/home" class="shortcut-item">
                    <i class="bi bi-house-door-fill text-primary" style="font-size: 1.5rem; width: 36px; text-align: center;"></i>
                    <span>Trang chủ</span>
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="shortcut-item">
                    <i class="bi bi-person-circle text-primary" style="font-size: 1.5rem; width: 36px; text-align: center;"></i>
                    <span>Trang cá nhân</span>
                </a>
                <a href="${pageContext.request.contextPath}/search" class="shortcut-item">
                    <i class="bi bi-search text-primary" style="font-size: 1.5rem; width: 36px; text-align: center;"></i>
                    <span>Tìm kiếm bạn bè</span>
                </a>
            </div>
        </aside>

        <%-- Feed giữa --%>
        <main class="fb-feed">
            <%-- Ô tạo bài viết --%>
            <div class="fb-create-post">
                <form action="${pageContext.request.contextPath}/post" method="post" enctype="multipart/form-data">
                    <div class="create-post-row">
                        <img src="${not empty me.avatarUrl ? me.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty me.avatarUrl ? me.username : ''}" alt="" class="create-post-avatar">
                        <textarea name="content" class="form-control" placeholder="Bạn đang nghĩ gì thế? Chia sẻ chuyến đi..." rows="2"></textarea>
                    </div>
                    <div class="location-row row g-2">
                        <div class="col-md-4">
                            <select name="locationId" class="form-select form-select-sm">
                                <option value="">Check-in địa điểm...</option>
                                <c:forEach items="${locations}" var="loc">
                                    <option value="${loc.id}">${loc.name}${not empty loc.city ? ' - ' : ''}${loc.city}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <input type="text" name="locationName" class="form-control form-control-sm" placeholder="Hoặc nhập địa điểm mới">
                        </div>
                        <div class="col-md-4">
                            <input type="text" name="locationCity" class="form-control form-control-sm" placeholder="Thành phố">
                        </div>
                    </div>
                    <div class="create-post-options d-flex flex-wrap align-items-center gap-2">
                        <label class="btn btn-light btn-sm mb-0 flex-grow-1 flex-md-grow-0 text-start">
                            <i class="bi bi-image text-success me-1"></i> Ảnh / Video
                            <input type="file" name="photo1" accept="image/*" class="d-none" multiple onchange="previewPhotos(this)">
                        </label>
                        <span class="small text-muted" id="photoNames"></span>
                        <button type="submit" class="btn btn-primary btn-sm ms-auto">Đăng</button>
                    </div>
                </form>
            </div>

            <%-- Danh sách bài viết --%>
            <c:forEach items="${posts}" var="post">
                <c:set var="author" value="${userDAO.getById(post.userId)}"/>
                <c:set var="checkIn" value="${checkInDAO.getByPostId(post.id)}"/>
                <c:set var="photos" value="${photoDAO.getByPostId(post.id)}"/>
                <c:set var="likeCount" value="${likeDAO.countByPostId(post.id)}"/>
                <c:set var="commentsList" value="${commentDAO.getByPostId(post.id)}"/>
                <c:set var="liked" value="${false}"/>
                <c:forEach items="${likedPostIds}" var="lid"><c:if test="${lid == post.id}"><c:set var="liked" value="${true}"/></c:if></c:forEach>

                <article class="fb-post-card">
                    <div class="post-header">
                        <a href="${pageContext.request.contextPath}/profile?id=${author.id}">
                            <img src="${not empty author.avatarUrl ? author.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty author.avatarUrl ? author.username : ''}" alt="" class="post-avatar">
                        </a>
                        <div class="post-meta">
                            <a href="${pageContext.request.contextPath}/profile?id=${author.id}" class="post-author-name">${not empty author.fullName ? author.fullName : author.username}</a>
                            <c:if test="${checkIn != null}">
                                <c:set var="loc" value="${locationDAO.getById(checkIn.locationId)}"/>
                                <div class="post-checkin"><i class="bi bi-geo-alt-fill me-1"></i><span class="location-name">${loc.name}</span> ${loc.city != null ? loc.city : ''}</div>
                            </c:if>
                            <div class="post-time">${post.createdAtFormatted}</div>
                        </div>
                        <c:if test="${author.id != me.id}">
                            <form action="${pageContext.request.contextPath}/follow" method="post" class="ms-auto">
                                <input type="hidden" name="userId" value="${author.id}">
                                <button type="submit" class="btn btn-primary btn-sm fb-btn-follow">Thêm bạn bè</button>
                            </form>
                        </c:if>
                    </div>
                    <c:if test="${post.content != null && !post.content.isEmpty()}">
                        <div class="post-content">${post.content}</div>
                    </c:if>
                    <c:if test="${!empty photos}">
                        <div class="post-photos">
                            <c:forEach items="${photos}" var="ph">
                                <img src="${ph.imageUrl}" alt="${ph.caption}">
                            </c:forEach>
                        </div>
                    </c:if>
                    <%-- Thống kê Like, Comment --%>
                    <div class="post-stats d-flex justify-content-between align-items-center">
                        <c:if test="${likeCount > 0}">
                            <span><i class="bi bi-hand-thumbs-up-fill text-primary me-1"></i>${likeCount}</span>
                        </c:if>
                        <c:if test="${commentDAO.countByPostId(post.id) > 0}">
                            <span class="ms-auto">${commentDAO.countByPostId(post.id)} bình luận</span>
                        </c:if>
                    </div>
                    <%-- Nút Like, Comment --%>
                    <div class="post-actions">
                        <form action="${pageContext.request.contextPath}/like" method="post" class="flex-grow-1">
                            <input type="hidden" name="postId" value="${post.id}">
                            <button type="submit" class="post-action-btn w-100 ${liked ? 'liked' : ''}">
                                <span class="icon">${liked ? '❤️' : '🤍'}</span>
                                <span class="${liked ? 'liked-text' : ''}">Thích</span>
                            </button>
                        </form>
                        <button type="button" class="post-action-btn flex-grow-1" onclick="document.getElementById('comment-input-${post.id}').focus()">
                            <i class="bi bi-chat-dots icon"></i> Bình luận
                        </button>
                    </div>
                    <%-- Khu vực comment --%>
                    <div class="comment-section">
                        <c:forEach items="${commentsList}" var="cm">
                            <c:if test="${cm.parentCommentId == 0}">
                                <c:set var="commentAuthor" value="${userDAO.getById(cm.userId)}"/>
                                <div class="comment-item">
                                    <img src="${not empty commentAuthor.avatarUrl ? commentAuthor.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty commentAuthor.avatarUrl ? commentAuthor.username : ''}" alt="" class="comment-avatar">
                                    <div class="comment-body">
                                        <a href="${pageContext.request.contextPath}/profile?id=${commentAuthor.id}" class="comment-author">${not empty commentAuthor.fullName ? commentAuthor.fullName : commentAuthor.username}</a> ${cm.content}
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                        <form action="${pageContext.request.contextPath}/comment" method="post" class="comment-form">
                            <input type="hidden" name="postId" value="${post.id}">
                            <img src="${not empty me.avatarUrl ? me.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty me.avatarUrl ? me.username : ''}" alt="" class="comment-avatar">
                            <input type="text" name="content" id="comment-input-${post.id}" class="form-control" placeholder="Viết bình luận..." required>
                            <button type="submit" class="btn btn-primary btn-sm">Gửi</button>
                        </form>
                    </div>
                </article>
            </c:forEach>
            <c:if test="${empty posts}">
                <div class="fb-post-card text-center py-5 text-muted">
                    <i class="bi bi-newspaper display-4"></i>
                    <p class="mt-2 mb-0">Chưa có bài viết. Theo dõi thêm bạn bè hoặc đăng bài đầu tiên!</p>
                </div>
            </c:if>
        </main>

        <%-- Sidebar phải (gợi ý / trống) --%>
        <aside class="fb-sidebar-right d-none d-xl-block">
            <div class="fb-shortcuts">
                <div class="p-3 border-bottom">
                    <h6 class="mb-0 fw-bold">Gợi ý</h6>
                </div>
                <p class="p-3 small text-muted mb-0">Theo dõi thêm bạn bè để xem bài viết của họ trên bảng tin.</p>
            </div>
        </aside>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function previewPhotos(input) {
            var names = [];
            if (input.files) for (var i = 0; i < input.files.length; i++) names.push(input.files[i].name);
            document.getElementById('photoNames').textContent = names.length ? names.join(', ') : '';
        }
    </script>
</body>
</html>
