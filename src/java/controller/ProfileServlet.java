package controller;

import dal.*;
import model.Post;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User me = (User) session.getAttribute("user");
        String idStr = req.getParameter("id");
        int profileUserId = me.getId();
        if (idStr != null && !idStr.isEmpty()) {
            try { profileUserId = Integer.parseInt(idStr); } catch (NumberFormatException e) {}
        }
        UserDAO userDAO = new UserDAO();
        User profileUser = userDAO.getById(profileUserId);
        if (profileUser == null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        FollowDAO followDAO = new FollowDAO();
        boolean isFollowing = me.getId() != profileUserId && followDAO.isFollowing(me.getId(), profileUserId);
        int followers = followDAO.countFollowers(profileUserId);
        int following = followDAO.countFollowing(profileUserId);
        PostDAO postDAO = new PostDAO();
        int page = 1;
        String p = req.getParameter("page");
        if (p != null && !p.isEmpty()) try { page = Integer.parseInt(p); } catch (NumberFormatException e) {}
        List<Post> posts = postDAO.getByUserId(profileUserId, 20, (page - 1) * 20);
        List<Integer> postIds = posts.stream().map(Post::getId).collect(Collectors.toList());
        PostLikeDAO likeDAO = new PostLikeDAO();
        List<Integer> likedPostIds = postIds.isEmpty() ? new ArrayList<>() : likeDAO.getLikedPostIds(me.getId(), postIds);
        req.setAttribute("profileUser", profileUser);
        req.setAttribute("isFollowing", isFollowing);
        req.setAttribute("followers", followers);
        req.setAttribute("following", following);
        req.setAttribute("posts", posts);
        req.setAttribute("userDAO", userDAO);
        req.setAttribute("checkInDAO", new CheckInDAO());
        req.setAttribute("photoDAO", new PostPhotoDAO());
        req.setAttribute("likeDAO", likeDAO);
        req.setAttribute("commentDAO", new CommentDAO());
        req.setAttribute("locationDAO", new LocationDAO());
        req.setAttribute("likedPostIds", likedPostIds);
        req.setAttribute("me", me);
        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
    }
}
