package model;

import java.time.LocalDateTime;

public class Follow {
    private int followerId;
    private int followingId;
    private LocalDateTime createdAt;

    public Follow() {}

    public Follow(int followerId, int followingId, LocalDateTime createdAt) {
        this.followerId = followerId;
        this.followingId = followingId;
        this.createdAt = createdAt;
    }

    public int getFollowerId() { return followerId; }
    public void setFollowerId(int followerId) { this.followerId = followerId; }
    public int getFollowingId() { return followingId; }
    public void setFollowingId(int followingId) { this.followingId = followingId; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
