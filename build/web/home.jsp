<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - TravelLuot</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-white">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">✈ TravelLuot</a>
            <div class="d-flex align-items-center gap-3">
                <a class="nav-link" href="${pageContext.request.contextPath}/home">Trang chủ</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/profile">Tôi</a>
                <span class="text-muted small">${me.username}</span>
                <a class="btn btn-outline-danger btn-sm" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
            </div>
        </div>
    </nav>

    <div class="container main-container">
        <%-- Form đăng bài --%>
        <div class="create-post-card bg-white">
            <form action="${pageContext.request.contextPath}/post" method="post" enctype="multipart/form-data">
                <div class="d-flex gap-2 mb-2">
                    <img src="${not empty me.avatarUrl ? me.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty me.avatarUrl ? me.username : ''}" alt="" class="post-avatar">
                    <div class="flex-grow-1">
                        <textarea name="content" class="form-control" placeholder="Chia sẻ chuyến đi của bạn..." rows="3"></textarea>
                    </div>
                </div>
                <div class="row g-2">
                    <div class="col-md-4">
                        <label class="form-label small text-muted">Check-in địa điểm (tùy chọn)</label>
                        <select name="locationId" class="form-select form-select-sm">
                            <option value="">-- Chọn địa điểm --</option>
                            <c:forEach items="${locations}" var="loc">
                                <option value="${loc.id}">${loc.name}${not empty loc.city ? ' - ' : ''}${loc.city}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small text-muted">Hoặc nhập địa điểm mới</label>
                        <input type="text" name="locationName" class="form-control form-control-sm" placeholder="Tên địa điểm">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small text-muted">Thành phố</label>
                        <input type="text" name="locationCity" class="form-control form-control-sm" placeholder="Thành phố">
                    </div>
                </div>
                <div class="create-post-actions">
                    <label class="btn btn-outline-primary btn-sm mb-0">
                        📷 Ảnh
                        <input type="file" name="photo1" accept="image/*" class="d-none" multiple onchange="previewPhotos(this)">
                    </label>
                    <span class="small text-muted" id="photoNames"></span>
                    <input type="file" name="photo2" accept="image/*" class="d-none" id="photo2">
                    <input type="file" name="photo3" accept="image/*" class="d-none" id="photo3">
                    <button type="submit" class="btn btn-primary ms-auto">Đăng</button>
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

            <div class="post-card card bg-white">
                <div class="card-body">
                    <div class="post-header">
                        <a href="${pageContext.request.contextPath}/profile?id=${author.id}">
                            <img src="${not empty author.avatarUrl ? author.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty author.avatarUrl ? author.username : ''}" alt="" class="post-avatar">
                        </a>
                        <div class="post-meta">
                            <a href="${pageContext.request.contextPath}/profile?id=${author.id}" class="text-dark text-decoration-none fw-bold">${not empty author.fullName ? author.fullName : author.username}</a>
                            <c:if test="${checkIn != null}">
                                <c:set var="loc" value="${locationDAO.getById(checkIn.locationId)}"/>
                                <div class="post-checkin">📍 <span>${loc.name}</span> ${loc.city != null ? loc.city : ''}</div>
                            </c:if>
                            <div class="text-muted small">
                                ${post.createdAtFormatted}
                            </div>
                        </div>
                        <c:if test="${author.id != me.id}">
                            <form action="${pageContext.request.contextPath}/follow" method="post" class="d-inline">
                                <input type="hidden" name="userId" value="${author.id}">
                                <button type="submit" class="btn btn-sm btn-outline-primary btn-follow">Follow</button>
                            </form>
                        </c:if>
                    </div>
                    <c:if test="${post.content != null && !post.content.isEmpty()}">
                        <div class="post-content">${post.content}</div>
                    </c:if>
                    <c:if test="${!empty photos}">
                        <div class="post-photos">
                            <c:forEach items="${photos}" var="ph">
                                <img src="${ph.imageUrl}" alt="${ph.caption}" class="w-100">
                            </c:forEach>
                        </div>
                    </c:if>
                    <div class="post-actions">
                        <form action="${pageContext.request.contextPath}/like" method="post" class="d-inline">
                            <input type="hidden" name="postId" value="${post.id}">
                            <button type="submit" class="${liked ? 'liked' : ''}">${liked ? '❤' : '🤍'} ${likeCount}</button>
                        </form>
                        <span class="text-muted">💬 ${commentDAO.countByPostId(post.id)}</span>
                    </div>
                    <div class="comment-list">
                        <c:forEach items="${commentsList}" var="cm">
                            <c:if test="${cm.parentCommentId == 0}">
                                <c:set var="commentAuthor" value="${userDAO.getById(cm.userId)}"/>
                                <div class="comment-item">
                                    <img src="${not empty commentAuthor.avatarUrl ? commentAuthor.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty commentAuthor.avatarUrl ? commentAuthor.username : ''}" alt="" class="comment-avatar">
                                    <div class="comment-body">
                                        <a href="${pageContext.request.contextPath}/profile?id=${commentAuthor.id}" class="comment-author text-decoration-none text-dark">${commentAuthor.fullName != null ? commentAuthor.fullName : commentAuthor.username}</a> ${cm.content}
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                        <form action="${pageContext.request.contextPath}/comment" method="post" class="comment-form">
                            <input type="hidden" name="postId" value="${post.id}">
                            <img src="${not empty me.avatarUrl ? me.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty me.avatarUrl ? me.username : ''}" alt="" class="comment-avatar">
                            <input type="text" name="content" class="form-control" placeholder="Viết bình luận..." required>
                            <button type="submit" class="btn btn-primary btn-sm">Gửi</button>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty posts}">
            <p class="text-center text-muted py-4">Chưa có bài viết. Theo dõi thêm bạn bè hoặc đăng bài đầu tiên!</p>
        </c:if>
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
