package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FollowDAO extends DBConnect {

    public boolean follow(int followerId, int followingId) {
        if (followerId == followingId) return false;
        String sql = "INSERT INTO follows (follower_id, following_id) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, followerId);
            ps.setInt(2, followingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean unfollow(int followerId, int followingId) {
        String sql = "DELETE FROM follows WHERE follower_id = ? AND following_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, followerId);
            ps.setInt(2, followingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean isFollowing(int followerId, int followingId) {
        String sql = "SELECT 1 FROM follows WHERE follower_id = ? AND following_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, followerId);
            ps.setInt(2, followingId);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Integer> getFollowingIds(int followerId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT following_id FROM follows WHERE follower_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, followerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(rs.getInt("following_id"));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int countFollowers(int userId) {
        String sql = "SELECT COUNT(*) FROM follows WHERE following_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int countFollowing(int userId) {
        String sql = "SELECT COUNT(*) FROM follows WHERE follower_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
