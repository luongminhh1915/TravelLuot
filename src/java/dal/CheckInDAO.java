package dal;

import model.CheckIn;

import java.sql.*;
import java.time.LocalDateTime;

public class CheckInDAO extends DBConnect {

    public boolean insert(int postId, int locationId) {
        String sql = "INSERT INTO check_ins (post_id, location_id) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.setInt(2, locationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public CheckIn getByPostId(int postId) {
        String sql = "SELECT * FROM check_ins WHERE post_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private CheckIn map(ResultSet rs) throws SQLException {
        CheckIn c = new CheckIn();
        c.setId(rs.getInt("id"));
        c.setPostId(rs.getInt("post_id"));
        c.setLocationId(rs.getInt("location_id"));
        Timestamp t = rs.getTimestamp("check_in_at");
        c.setCheckInAt(t != null ? t.toLocalDateTime() : null);
        return c;
    }
}
