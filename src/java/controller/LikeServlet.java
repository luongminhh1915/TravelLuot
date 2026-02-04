package controller;

import dal.PostLikeDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LikeServlet", urlPatterns = {"/like"})
public class LikeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User me = (User) session.getAttribute("user");
        String postIdStr = req.getParameter("postId");
        if (postIdStr == null || postIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        int postId;
        try {
            postId = Integer.parseInt(postIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        PostLikeDAO likeDAO = new PostLikeDAO();
        if (likeDAO.isLiked(me.getId(), postId)) {
            likeDAO.unlike(me.getId(), postId);
        } else {
            likeDAO.like(me.getId(), postId);
        }
        String ref = req.getHeader("Referer");
        if (ref != null && !ref.isEmpty()) {
            resp.sendRedirect(ref);
        } else {
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }
}
