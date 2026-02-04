<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty profileUser.fullName ? profileUser.fullName : profileUser.username} - TravelLuot</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="profile-page">
    <%-- Navbar giống Facebook --%>
    <nav class="navbar navbar-expand-lg fb-navbar">
        <div class="container-fluid px-3">
            <a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/home">
                <i class="bi bi-airplane me-1"></i> TravelLuot
            </a>
            <form class="d-none d-md-flex flex-grow-1 justify-content-center mx-3" action="${pageContext.request.contextPath}/search" method="get">
                <input class="form-control" type="search" name="q" placeholder="Tìm kiếm bạn bè" aria-label="Search" style="max-width: 320px;">
            </form>
            <div class="d-flex align-items-center gap-1 ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/home" title="Trang chủ"><i class="bi bi-house-door-fill fs-5"></i></a>
                <a class="nav-link" href="${pageContext.request.contextPath}/profile" title="Cá nhân"><i class="bi bi-person-circle fs-5"></i></a>
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
        <aside class="fb-sidebar-left d-none d-lg-block"></aside>
        <main class="fb-feed">
            <%-- Cover + Avatar + Thông tin --%>
            <div class="fb-profile-card">
                <div class="fb-profile-cover">
                    <c:if test="${not empty profileUser.coverUrl}">
                        <img src="${profileUser.coverUrl}" alt="Ảnh bìa" class="fb-profile-cover-img">
                    </c:if>
                    <c:if test="${profileUser.id == me.id}">
                        <button type="button" class="btn btn-light btn-sm fb-btn-cover-edit" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                            <i class="bi bi-camera-fill me-1"></i> Chỉnh sửa ảnh bìa
                        </button>
                    </c:if>
                </div>
                <div class="fb-profile-avatar-wrap">
                    <div class="position-relative">
                        <img src="${not empty profileUser.avatarUrl ? profileUser.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty profileUser.avatarUrl ? profileUser.username : ''}" alt="" class="fb-profile-avatar">
                        <c:if test="${profileUser.id == me.id}">
                            <button type="button" class="btn btn-light btn-sm fb-btn-avatar-edit" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                                <i class="bi bi-camera-fill"></i>
                            </button>
                        </c:if>
                    </div>
                    <c:if test="${profileUser.id != me.id}">
                        <form action="${pageContext.request.contextPath}/follow" method="post">
                            <input type="hidden" name="userId" value="${profileUser.id}">
                            <button type="submit" class="btn ${isFollowing ? 'btn-secondary' : 'btn-primary'} fb-btn-follow">
                                <i class="bi bi-person-plus me-1"></i>${isFollowing ? 'Đang theo dõi' : 'Thêm bạn bè'}
                            </button>
                        </form>
                    </c:if>
                    <c:if test="${profileUser.id == me.id}">
                        <button type="button" class="btn btn-primary fb-btn-follow" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                            <i class="bi bi-pencil-square me-1"></i> Chỉnh sửa trang cá nhân
                        </button>
                    </c:if>
                </div>
                <div class="fb-profile-info">
                    <h2>${not empty profileUser.fullName ? profileUser.fullName : profileUser.username}</h2>
                    <p class="username">@${profileUser.username}</p>
                    <c:if test="${not empty profileUser.bio}">
                        <p class="bio">${profileUser.bio}</p>
                    </c:if>
                    <div class="fb-profile-stats">
                        <a href="#" class="fb-profile-stat-link" data-bs-toggle="modal" data-bs-target="#followersModal">
                            <strong>${followers}</strong> người theo dõi
                        </a>
                        <a href="#" class="fb-profile-stat-link" data-bs-toggle="modal" data-bs-target="#followingModal">
                            <strong>${following}</strong> đang theo dõi
                        </a>
                    </div>
                </div>
            </div>

            <%-- Tab Bài viết --%>
            <ul class="nav nav-tabs mb-3 border-0">
                <li class="nav-item">
                    <a class="nav-link active fw-semibold text-dark border-0 border-bottom border-3 border-primary pb-2" href="#">Bài viết</a>
                </li>
            </ul>

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
                                <div class="post-checkin"><i class="bi bi-geo-alt-fill me-1"></i><span class="location-name">${loc.name}</span> ${loc.city}</div>
                            </c:if>
                            <div class="post-time">${post.createdAtFormatted}</div>
                        </div>
                    </div>
                    <c:if test="${not empty post.content}">
                        <div class="post-content">${post.content}</div>
                    </c:if>
                    <c:if test="${!empty photos}">
                        <div class="post-photos">
                            <c:forEach items="${photos}" var="ph">
                                <img src="${ph.imageUrl}" alt="${ph.caption}">
                            </c:forEach>
                        </div>
                    </c:if>
                    <div class="post-stats d-flex justify-content-between align-items-center">
                        <c:if test="${likeCount > 0}"><span><i class="bi bi-hand-thumbs-up-fill text-primary me-1"></i>${likeCount}</span></c:if>
                        <c:if test="${commentDAO.countByPostId(post.id) > 0}"><span class="ms-auto">${commentDAO.countByPostId(post.id)} bình luận</span></c:if>
                    </div>
                    <div class="post-actions">
                        <form action="${pageContext.request.contextPath}/like" method="post" class="flex-grow-1">
                            <input type="hidden" name="postId" value="${post.id}">
                            <button type="submit" class="post-action-btn w-100 ${liked ? 'liked' : ''}"><span class="icon">${liked ? '❤️' : '🤍'}</span><span class="${liked ? 'liked-text' : ''}">Thích</span></button>
                        </form>
                        <button type="button" class="post-action-btn flex-grow-1" onclick="document.getElementById('comment-input-p${post.id}').focus()"><i class="bi bi-chat-dots icon"></i> Bình luận</button>
                    </div>
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
                        <c:if test="${me != null}">
                        <form action="${pageContext.request.contextPath}/comment" method="post" class="comment-form">
                            <input type="hidden" name="postId" value="${post.id}">
                            <img src="${not empty me.avatarUrl ? me.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty me.avatarUrl ? me.username : ''}" alt="" class="comment-avatar">
                            <input type="text" name="content" id="comment-input-p${post.id}" class="form-control" placeholder="Viết bình luận..." required>
                            <button type="submit" class="btn btn-primary btn-sm">Gửi</button>
                        </form>
                        </c:if>
                    </div>
                </article>
            </c:forEach>
            <c:if test="${empty posts}">
                <div class="fb-post-card text-center py-5 text-muted">
                    <i class="bi bi-newspaper display-4"></i>
                    <p class="mt-2 mb-0">Chưa có bài viết nào.</p>
                </div>
            </c:if>

            <%-- Modal chỉnh sửa hồ sơ --%>
            <c:if test="${profileUser.id == me.id}">
                <div class="modal fade" id="editProfileModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Chỉnh sửa trang cá nhân</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <form action="${pageContext.request.contextPath}/profile/edit" method="post" enctype="multipart/form-data">
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label class="form-label">Họ tên</label>
                                        <input type="text" name="fullName" class="form-control" value="${profileUser.fullName}">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Giới thiệu bản thân</label>
                                        <textarea name="bio" class="form-control" rows="3" placeholder="Viết vài dòng giới thiệu...">${profileUser.bio}</textarea>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label">Ảnh đại diện</label>
                                            <input type="file" name="avatar" accept="image/*" class="form-control">
                                            <div class="small text-muted mt-1">Tối đa 5MB, định dạng JPG, PNG.</div>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label class="form-label">Ảnh bìa</label>
                                            <input type="file" name="cover" accept="image/*" class="form-control">
                                            <div class="small text-muted mt-1">Tối đa 5MB, định dạng JPG, PNG.</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </c:if>

            <%-- Modal người theo dõi --%>
            <div class="modal fade" id="followersModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-scrollable">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Người theo dõi</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <c:if test="${empty followersList}">
                                <p class="text-muted mb-0">Chưa có ai theo dõi.</p>
                            </c:if>
                            <c:forEach items="${followersList}" var="u">
                                <a href="${pageContext.request.contextPath}/profile?id=${u.id}" class="fb-follow-item">
                                    <img src="${not empty u.avatarUrl ? u.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty u.avatarUrl ? u.username : ''}" alt="">
                                    <div>
                                        <div class="fw-semibold">${not empty u.fullName ? u.fullName : u.username}</div>
                                        <div class="text-muted small">@${u.username}</div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Modal đang theo dõi --%>
            <div class="modal fade" id="followingModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-dialog-scrollable">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Đang theo dõi</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <c:if test="${empty followingList}">
                                <p class="text-muted mb-0">Chưa theo dõi ai.</p>
                            </c:if>
                            <c:forEach items="${followingList}" var="u">
                                <a href="${pageContext.request.contextPath}/profile?id=${u.id}" class="fb-follow-item">
                                    <img src="${not empty u.avatarUrl ? u.avatarUrl : 'https://ui-avatars.com/api/?name='}${empty u.avatarUrl ? u.username : ''}" alt="">
                                    <div>
                                        <div class="fw-semibold">${not empty u.fullName ? u.fullName : u.username}</div>
                                        <div class="text-muted small">@${u.username}</div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <aside class="fb-sidebar-right d-none d-xl-block"></aside>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
