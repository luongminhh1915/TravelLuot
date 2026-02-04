package controller;

import dal.FollowDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "FollowServlet", urlPatterns = {"/follow"})
public class FollowServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User me = (User) session.getAttribute("user");
        String userIdStr = req.getParameter("userId");
        if (userIdStr == null || userIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        int targetId;
        try {
            targetId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        FollowDAO followDAO = new FollowDAO();
        if (followDAO.isFollowing(me.getId(), targetId)) {
            followDAO.unfollow(me.getId(), targetId);
        } else {
            followDAO.follow(me.getId(), targetId);
        }
        String ref = req.getHeader("Referer");
        if (ref != null && !ref.isEmpty()) {
            resp.sendRedirect(ref);
        } else {
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }
}
