package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostLikeDAO extends DBConnect {

    public boolean like(int userId, int postId) {
        String sql = "INSERT INTO post_likes (user_id, post_id) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean unlike(int userId, int postId) {
        String sql = "DELETE FROM post_likes WHERE user_id = ? AND post_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean isLiked(int userId, int postId) {
        String sql = "SELECT 1 FROM post_likes WHERE user_id = ? AND post_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public int countByPostId(int postId) {
        String sql = "SELECT COUNT(*) FROM post_likes WHERE post_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Integer> getLikedPostIds(int userId, List<Integer> postIds) {
        List<Integer> list = new ArrayList<>();
        if (postIds == null || postIds.isEmpty()) return list;
        StringBuilder sql = new StringBuilder("SELECT post_id FROM post_likes WHERE user_id = ? AND post_id IN (");
        for (int i = 0; i < postIds.size(); i++) sql.append(i > 0 ? ",?" : "?");
        sql.append(")");
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            ps.setInt(1, userId);
            for (int i = 0; i < postIds.size(); i++) ps.setInt(i + 2, postIds.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(rs.getInt("post_id"));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
