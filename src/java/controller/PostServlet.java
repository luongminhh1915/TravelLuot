package controller;

import dal.*;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.UUID;

@WebServlet(name = "PostServlet", urlPatterns = {"/post"}, loadOnStartup = 1)
@jakarta.servlet.annotation.MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 20 * 1024 * 1024)
public class PostServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User me = (User) session.getAttribute("user");
        String content = req.getParameter("content");
        String locationIdStr = req.getParameter("locationId");
        Integer locationId = null;
        if (locationIdStr != null && !locationIdStr.isEmpty()) {
            try {
                locationId = Integer.parseInt(locationIdStr);
            } catch (NumberFormatException e) {
            }
        }
        String locName = req.getParameter("locationName");
        String locAddress = req.getParameter("locationAddress");
        String locCity = req.getParameter("locationCity");
        if (locationId == null && locName != null && !locName.isBlank()) {
            LocationDAO locDAO = new LocationDAO();
            Integer id = locDAO.findOrCreate(locName.trim(), locAddress != null ? locAddress.trim() : null, locCity != null ? locCity.trim() : null);
            if (id != null) {
                locationId = id;
            }
        }
        PostDAO postDAO = new PostDAO();
        int postId = postDAO.insert(me.getId(), content != null ? content : "");
        if (postId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/home?err=post");
            return;
        }
        if (locationId != null && locationId > 0) {
            CheckInDAO checkInDAO = new CheckInDAO();
            checkInDAO.insert(postId, locationId);
        }
        String realPath = getServletContext().getRealPath("/");
        if (realPath == null) {
            realPath = System.getProperty("user.dir");
        }
        File uploadDir = new File(realPath, UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        int order = 0;
        if (req.getContentType() != null && req.getContentType().toLowerCase().contains("multipart")) {
            Collection<Part> parts = req.getParts();
            for (Part part : parts) {
                if (part.getName() != null && part.getName().startsWith("photo") && part.getSize() > 0 && part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                    String ext = part.getSubmittedFileName().substring(part.getSubmittedFileName().lastIndexOf('.'));
                    String fileName = UPLOAD_DIR + "/" + UUID.randomUUID().toString() + ext;
                    String fullPath = getServletContext().getRealPath("/") + fileName.replace("/", File.separator);
                    part.write(fullPath);
                    String url = req.getContextPath() + "/" + fileName.replace("\\", "/");
                    PostPhotoDAO photoDAO = new PostPhotoDAO();
                    photoDAO.insert(postId, url, order++, null);
                }
            }
        }
        resp.sendRedirect(req.getContextPath() + "/home");
    }
}
