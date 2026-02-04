package dal;

import model.Post;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PostDAO extends DBConnect {

    public int insert(int userId, String content) {
        String sql = "INSERT INTO posts (user_id, content) OUTPUT INSERTED.id VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, content != null ? content : "");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    /** Feed: bài của user + bài của người mình follow, mới nhất trước */
    public List<Post> getFeed(int currentUserId, List<Integer> followingIds, int limit, int offset) {
        List<Post> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM posts WHERE user_id = ?");
        if (followingIds != null && !followingIds.isEmpty()) {
            for (int i = 0; i < followingIds.size(); i++) sql.append(" OR user_id = ?");
        }
        sql.append(" ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int i = 1;
            ps.setInt(i++, currentUserId);
            if (followingIds != null)
                for (Integer fid : followingIds) ps.setInt(i++, fid);
            ps.setInt(i++, offset);
            ps.setInt(i, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Post> getByUserId(int userId, int limit, int offset) {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT * FROM posts WHERE user_id = ? ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Post getById(int id) {
        String sql = "SELECT * FROM posts WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private Post map(ResultSet rs) throws SQLException {
        Post p = new Post();
        p.setId(rs.getInt("id"));
        p.setUserId(rs.getInt("user_id"));
        p.setContent(rs.getString("content"));
        Timestamp t = rs.getTimestamp("created_at");
        p.setCreatedAt(t != null ? t.toLocalDateTime() : null);
        t = rs.getTimestamp("updated_at");
        p.setUpdatedAt(t != null ? t.toLocalDateTime() : null);
        return p;
    }
}
