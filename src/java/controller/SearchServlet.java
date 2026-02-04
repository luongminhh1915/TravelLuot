package controller;

import dal.FollowDAO;
import dal.UserDAO;
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

@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User me = (User) session.getAttribute("user");
        String q = req.getParameter("q");
        if (q == null) q = "";
        q = q.trim();

        UserDAO userDAO = new UserDAO();
        FollowDAO followDAO = new FollowDAO();
        List<Integer> followingIds = followDAO.getFollowingIds(me.getId());

        List<User> results = q.isEmpty() ? List.of() : userDAO.searchByNameOrUsername(q);
        List<User> safeResults = new ArrayList<>(results);
        // loại bỏ chính mình khỏi kết quả
        safeResults.removeIf(u -> u.getId() == me.getId());

        req.setAttribute("q", q);
        req.setAttribute("results", safeResults);
        req.setAttribute("followingIds", followingIds);
        req.setAttribute("me", me);
        req.getRequestDispatcher("/search.jsp").forward(req, resp);
    }
}

