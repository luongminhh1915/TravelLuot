package controller;

import dal.CommentDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "CommentServlet", urlPatterns = {"/comment"})
public class CommentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User me = (User) session.getAttribute("user");
        String postIdStr = req.getParameter("postId");
        String content = req.getParameter("content");
        String parentStr = req.getParameter("parentId");
        if (postIdStr == null || postIdStr.isEmpty() || content == null || content.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        int postId;
        try { postId = Integer.parseInt(postIdStr); } catch (NumberFormatException e) { resp.sendRedirect(req.getContextPath() + "/home"); return; }
        Integer parentId = null;
        if (parentStr != null && !parentStr.isEmpty()) try { parentId = Integer.parseInt(parentStr); } catch (NumberFormatException e) {}
        CommentDAO commentDAO = new CommentDAO();
        commentDAO.insert(me.getId(), postId, content.trim(), parentId);
        String ref = req.getHeader("Referer");
        if (ref != null && !ref.isEmpty()) resp.sendRedirect(ref);
        else resp.sendRedirect(req.getContextPath() + "/home");
    }
}
