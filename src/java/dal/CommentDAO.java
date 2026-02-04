package dal;

import model.Comment;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO extends DBConnect {

    public int insert(int userId, int postId, String content, Integer parentCommentId) {
        String sql = "INSERT INTO comments (user_id, post_id, content, parent_comment_id) OUTPUT INSERTED.id VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            ps.setString(3, content);
            if (parentCommentId != null && parentCommentId > 0) ps.setInt(4, parentCommentId);
            else ps.setNull(4, Types.INTEGER);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Comment> getByPostId(int postId) {
        List<Comment> list = new ArrayList<>();
        String sql = "SELECT * FROM comments WHERE post_id = ? ORDER BY created_at ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int countByPostId(int postId) {
        String sql = "SELECT COUNT(*) FROM comments WHERE post_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Comment map(ResultSet rs) throws SQLException {
        Comment c = new Comment();
        c.setId(rs.getInt("id"));
        c.setUserId(rs.getInt("user_id"));
        c.setPostId(rs.getInt("post_id"));
        c.setParentCommentId(rs.getInt("parent_comment_id"));
        if (rs.wasNull()) c.setParentCommentId(0);
        c.setContent(rs.getString("content"));
        Timestamp t = rs.getTimestamp("created_at");
        c.setCreatedAt(t != null ? t.toLocalDateTime() : null);
        t = rs.getTimestamp("updated_at");
        c.setUpdatedAt(t != null ? t.toLocalDateTime() : null);
        return c;
    }
}
