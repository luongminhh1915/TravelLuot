<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty profileUser.fullName ? profileUser.fullName : profileUser.username} - TravelLuot</title>
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
        <div class="profile-card card bg-white mb-4">
            <div class="profile-cover"></div>
            <div class="profile-avatar-wrap d-flex align-items-end justify-content-between flex-wrap">
                <img src="${not empty profileUser.avatarUrl ? profileUser.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty profileUser.avatarUrl ? profileUser.username : ''}" alt="" class="profile-avatar">
                <c:if test="${profileUser.id != me.id}">
                    <form action="${pageContext.request.contextPath}/follow" method="post" class="me-3 mb-2">
                        <input type="hidden" name="userId" value="${profileUser.id}">
                        <button type="submit" class="btn ${isFollowing ? 'btn-secondary' : 'btn-primary'} btn-follow">${isFollowing ? 'Đang theo dõi' : 'Follow'}</button>
                    </form>
                </c:if>
            </div>
            <div class="card-body pt-0">
                <h4 class="mb-1">${not empty profileUser.fullName ? profileUser.fullName : profileUser.username}</h4>
                <p class="text-muted small mb-2">@${profileUser.username}</p>
                <c:if test="${not empty profileUser.bio}">
                    <p class="mb-2">${profileUser.bio}</p>
                </c:if>
                <div class="d-flex gap-4 text-muted small">
                    <span><strong class="text-dark">${followers}</strong> người theo dõi</span>
                    <span><strong class="text-dark">${following}</strong> đang theo dõi</span>
                </div>
            </div>
        </div>

        <h5 class="mb-3">Bài viết</h5>
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
                                <div class="post-checkin">📍 <span>${loc.name}</span> ${loc.city}</div>
                            </c:if>
                            <div class="text-muted small">${post.createdAtFormatted}</div>
                        </div>
                    </div>
                    <c:if test="${not empty post.content}">
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
                                        <a href="${pageContext.request.contextPath}/profile?id=${commentAuthor.id}" class="comment-author text-decoration-none text-dark">${not empty commentAuthor.fullName ? commentAuthor.fullName : commentAuthor.username}</a> ${cm.content}
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                        <c:if test="${me != null}">
                        <form action="${pageContext.request.contextPath}/comment" method="post" class="comment-form">
                            <input type="hidden" name="postId" value="${post.id}">
                            <img src="${not empty me.avatarUrl ? me.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty me.avatarUrl ? me.username : ''}" alt="" class="comment-avatar">
                            <input type="text" name="content" class="form-control" placeholder="Viết bình luận..." required>
                            <button type="submit" class="btn btn-primary btn-sm">Gửi</button>
                        </form>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
        <c:if test="${empty posts}">
            <p class="text-center text-muted py-4">Chưa có bài viết nào.</p>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
