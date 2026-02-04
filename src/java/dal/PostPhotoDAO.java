package dal;

import model.PostPhoto;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PostPhotoDAO extends DBConnect {

    public boolean insert(int postId, String imageUrl, int sortOrder, String caption) {
        String sql = "INSERT INTO post_photos (post_id, image_url, sort_order, caption) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.setString(2, imageUrl);
            ps.setInt(3, sortOrder);
            ps.setString(4, caption != null ? caption : "");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<PostPhoto> getByPostId(int postId) {
        List<PostPhoto> list = new ArrayList<>();
        String sql = "SELECT * FROM post_photos WHERE post_id = ? ORDER BY sort_order, id";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private PostPhoto map(ResultSet rs) throws SQLException {
        PostPhoto p = new PostPhoto();
        p.setId(rs.getInt("id"));
        p.setPostId(rs.getInt("post_id"));
        p.setImageUrl(rs.getString("image_url"));
        p.setSortOrder(rs.getInt("sort_order"));
        p.setCaption(rs.getString("caption"));
        Timestamp t = rs.getTimestamp("created_at");
        p.setCreatedAt(t != null ? t.toLocalDateTime() : null);
        return p;
    }
}
