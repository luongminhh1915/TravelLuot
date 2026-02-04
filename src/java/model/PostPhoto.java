package model;

import java.time.LocalDateTime;

public class PostPhoto {
    private int id;
    private int postId;
    private String imageUrl;
    private int sortOrder;
    private String caption;
    private LocalDateTime createdAt;

    public PostPhoto() {}

    public PostPhoto(int id, int postId, String imageUrl, int sortOrder, String caption, LocalDateTime createdAt) {
        this.id = id;
        this.postId = postId;
        this.imageUrl = imageUrl;
        this.sortOrder = sortOrder;
        this.caption = caption;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public int getSortOrder() { return sortOrder; }
    public void setSortOrder(int sortOrder) { this.sortOrder = sortOrder; }
    public String getCaption() { return caption; }
    public void setCaption(String caption) { this.caption = caption; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
