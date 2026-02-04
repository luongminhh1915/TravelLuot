package controller;

import dal.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "ProfileEditServlet", urlPatterns = {"/profile/edit"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 15 * 1024 * 1024)
public class ProfileEditServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User me = (User) session.getAttribute("user");

        String fullName = req.getParameter("fullName");
        String bio = req.getParameter("bio");

        String avatarUrl = null;
        String coverUrl = null;

        String realPath = getServletContext().getRealPath("/");
        if (realPath == null) {
            realPath = System.getProperty("user.dir");
        }
        File uploadDir = new File(realPath, UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        if (req.getContentType() != null && req.getContentType().toLowerCase().contains("multipart")) {
            Part avatarPart = null;
            Part coverPart = null;
            try {
                avatarPart = req.getPart("avatar");
            } catch (IllegalStateException ignore) {}
            try {
                coverPart = req.getPart("cover");
            } catch (IllegalStateException ignore) {}

            if (avatarPart != null && avatarPart.getSize() > 0 && avatarPart.getSubmittedFileName() != null && !avatarPart.getSubmittedFileName().isEmpty()) {
                String ext = avatarPart.getSubmittedFileName().lastIndexOf('.') >= 0
                        ? avatarPart.getSubmittedFileName().substring(avatarPart.getSubmittedFileName().lastIndexOf('.'))
                        : "";
                String fileName = UPLOAD_DIR + "/" + UUID.randomUUID() + ext;
                String fullPath = new File(realPath, fileName.replace("/", File.separator)).getAbsolutePath();
                avatarPart.write(fullPath);
                avatarUrl = req.getContextPath() + "/" + fileName.replace("\\", "/");
            }

            if (coverPart != null && coverPart.getSize() > 0 && coverPart.getSubmittedFileName() != null && !coverPart.getSubmittedFileName().isEmpty()) {
                String ext = coverPart.getSubmittedFileName().lastIndexOf('.') >= 0
                        ? coverPart.getSubmittedFileName().substring(coverPart.getSubmittedFileName().lastIndexOf('.'))
                        : "";
                String fileName = UPLOAD_DIR + "/" + UUID.randomUUID() + ext;
                String fullPath = new File(realPath, fileName.replace("/", File.separator)).getAbsolutePath();
                coverPart.write(fullPath);
                coverUrl = req.getContextPath() + "/" + fileName.replace("\\", "/");
            }
        }

        UserDAO userDAO = new UserDAO();
        boolean ok = userDAO.updateProfile(me.getId(), fullName, bio, avatarUrl, coverUrl);
        if (ok) {
            User refreshed = userDAO.getById(me.getId());
            if (refreshed != null) {
                session.setAttribute("user", refreshed);
            }
        }

        resp.sendRedirect(req.getContextPath() + "/profile");
    }
}

