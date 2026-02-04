package controller;

import dal.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (req.getSession(false) != null && req.getSession().getAttribute("user") != null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirmPassword");
        String fullName = req.getParameter("fullName");
        if (username == null || username.isBlank() || email == null || email.isBlank()
                || password == null || password.isBlank()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ username, email và mật khẩu.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        if (password.length() < 6) {
            req.setAttribute("error", "Mật khẩu tối thiểu 6 ký tự.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        if (!password.equals(confirm)) {
            req.setAttribute("error", "Xác nhận mật khẩu không khớp.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        UserDAO dao = new UserDAO();
        if (dao.existsUsername(username.trim())) {
            req.setAttribute("error", "Tên đăng nhập đã tồn tại.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        if (dao.existsEmail(email.trim())) {
            req.setAttribute("error", "Email đã được sử dụng.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }
        if (dao.register(username.trim(), email.trim(), password, fullName != null ? fullName.trim() : username.trim())) {
            req.setAttribute("success", "Đăng ký thành công. Vui lòng đăng nhập.");
            resp.sendRedirect(req.getContextPath() + "/login?registered=1");
        } else {
            req.setAttribute("error", "Có lỗi xảy ra. Thử lại sau.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
