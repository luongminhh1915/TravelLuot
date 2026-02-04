package dal;

import model.User;
import util.PasswordUtil;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class UserDAO extends DBConnect {

    public User login(String usernameOrEmail, String password) {
        String sql = "SELECT * FROM users WHERE (username = ? OR email = ?) AND is_active = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, usernameOrEmail);
            ps.setString(2, usernameOrEmail);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && PasswordUtil.check(password, rs.getString("password_hash"))) {
                return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean register(String username, String email, String password, String fullName) {
        String sql = "INSERT INTO users (role_id, username, email, password_hash, full_name) VALUES (2, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, PasswordUtil.hash(password));
            ps.setString(4, fullName != null ? fullName : username);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public User getById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean existsUsername(String username) {
        try (PreparedStatement ps = connection.prepareStatement("SELECT 1 FROM users WHERE username = ?")) {
            ps.setString(1, username);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean existsEmail(String email) {
        try (PreparedStatement ps = connection.prepareStatement("SELECT 1 FROM users WHERE email = ?")) {
            ps.setString(1, email);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<User> searchByNameOrUsername(String q) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE is_active = 1 AND (full_name LIKE ? OR username LIKE ?) ORDER BY username";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String like = "%" + q + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateProfile(int id, String fullName, String bio, String avatarUrl, String coverUrl) {
        User current = getById(id);
        if (current == null) return false;
        String newFullName = (fullName != null && !fullName.isBlank()) ? fullName.trim() : current.getFullName();
        String newBio = bio != null ? bio.trim() : current.getBio();
        String newAvatar = avatarUrl != null ? avatarUrl : current.getAvatarUrl();
        String newCover = coverUrl != null ? coverUrl : current.getCoverUrl();

        String sql = "UPDATE users SET full_name = ?, bio = ?, avatar_url = ?, cover_url = ?, updated_at = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newFullName);
            ps.setString(2, newBio);
            ps.setString(3, newAvatar);
            ps.setString(4, newCover);
            ps.setTimestamp(5, Timestamp.valueOf(LocalDateTime.now()));
            ps.setInt(6, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private User map(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setRoleId(rs.getInt("role_id"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setFullName(rs.getString("full_name"));
        u.setAvatarUrl(rs.getString("avatar_url"));
        try {
            u.setCoverUrl(rs.getString("cover_url"));
        } catch (SQLException ignored) {
            // Older databases may not have cover_url yet
        }
        u.setBio(rs.getString("bio"));
        u.setIsActive(rs.getBoolean("is_active"));
        Timestamp t = rs.getTimestamp("created_at");
        u.setCreatedAt(t != null ? t.toLocalDateTime() : null);
        t = rs.getTimestamp("updated_at");
        u.setUpdatedAt(t != null ? t.toLocalDateTime() : null);
        return u;
    }
}
