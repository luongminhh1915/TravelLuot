package model;

import java.time.LocalDateTime;

public class CheckIn {
    private int id;
    private int postId;
    private int locationId;
    private LocalDateTime checkInAt;

    public CheckIn() {}

    public CheckIn(int id, int postId, int locationId, LocalDateTime checkInAt) {
        this.id = id;
        this.postId = postId;
        this.locationId = locationId;
        this.checkInAt = checkInAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }
    public int getLocationId() { return locationId; }
    public void setLocationId(int locationId) { this.locationId = locationId; }
    public LocalDateTime getCheckInAt() { return checkInAt; }
    public void setCheckInAt(LocalDateTime checkInAt) { this.checkInAt = checkInAt; }
}
