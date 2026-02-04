package dal;

import model.Location;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class LocationDAO extends DBConnect {

    public List<Location> getAll() {
        List<Location> list = new ArrayList<>();
        String sql = "SELECT * FROM locations ORDER BY name";
        try (Statement st = connection.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Location getById(int id) {
        String sql = "SELECT * FROM locations WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public int insert(String name, String address, String city, String country) {
        String sql = "INSERT INTO locations (name, address, city, country) OUTPUT INSERTED.id VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, address != null ? address : "");
            ps.setString(3, city != null ? city : "");
            ps.setString(4, country != null ? country : "Việt Nam");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public Integer findOrCreate(String name, String address, String city) {
        String sql = "SELECT id FROM locations WHERE name = ? AND (address = ? OR (address IS NULL AND ? IS NULL))";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, address != null ? address : "");
            ps.setString(3, address);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("id");
        } catch (SQLException e) { e.printStackTrace(); }
        int id = insert(name, address, city, "Việt Nam");
        return id > 0 ? id : null;
    }

    private Location map(ResultSet rs) throws SQLException {
        Location loc = new Location();
        loc.setId(rs.getInt("id"));
        loc.setName(rs.getString("name"));
        loc.setAddress(rs.getString("address"));
        loc.setCity(rs.getString("city"));
        loc.setCountry(rs.getString("country"));
        BigDecimal lat = rs.getBigDecimal("latitude");
        loc.setLatitude(rs.wasNull() ? null : lat);
        BigDecimal lng = rs.getBigDecimal("longitude");
        loc.setLongitude(rs.wasNull() ? null : lng);
        loc.setDescription(rs.getString("description"));
        Timestamp t = rs.getTimestamp("created_at");
        loc.setCreatedAt(t != null ? t.toLocalDateTime() : null);
        t = rs.getTimestamp("updated_at");
        loc.setUpdatedAt(t != null ? t.toLocalDateTime() : null);
        return loc;
    }
}
