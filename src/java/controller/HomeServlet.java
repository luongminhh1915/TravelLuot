package controller;

import dal.*;
import model.Location;
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

@WebServlet(name = "HomeServlet", urlPatterns = {"/home", ""})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User me = (User) session.getAttribute("user");
        FollowDAO followDAO = new FollowDAO();
        List<Integer> followingIds = followDAO.getFollowingIds(me.getId());
        PostDAO postDAO = new PostDAO();
        int page = 1;
        String p = req.getParameter("page");
        if (p != null && !p.isEmpty()) try {
            page = Integer.parseInt(p);
        } catch (NumberFormatException e) {
        }
        int limit = 10;
        int offset = (page - 1) * limit;
        List<Post> posts = postDAO.getFeed(me.getId(), followingIds, limit, offset);
        UserDAO userDAO = new UserDAO();
        CheckInDAO checkInDAO = new CheckInDAO();
        PostPhotoDAO photoDAO = new PostPhotoDAO();
        PostLikeDAO likeDAO = new PostLikeDAO();
        CommentDAO commentDAO = new CommentDAO();
        LocationDAO locationDAO = new LocationDAO();
        List<Integer> postIds = posts.stream().map(Post::getId).collect(Collectors.toList());
        List<Integer> likedPostIds = postIds.isEmpty() ? new ArrayList<>() : likeDAO.getLikedPostIds(me.getId(), postIds);
        req.setAttribute("posts", posts);
        req.setAttribute("userDAO", userDAO);
        req.setAttribute("checkInDAO", checkInDAO);
        req.setAttribute("photoDAO", photoDAO);
        req.setAttribute("likeDAO", likeDAO);
        req.setAttribute("commentDAO", commentDAO);
        req.setAttribute("locationDAO", locationDAO);
        req.setAttribute("likedPostIds", likedPostIds);
        req.setAttribute("me", me);
        req.setAttribute("locations", locationDAO.getAll());
        req.getRequestDispatcher("/home.jsp").forward(req, resp);
    }
}
