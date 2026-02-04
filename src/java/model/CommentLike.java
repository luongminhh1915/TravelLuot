package model;

import java.time.LocalDateTime;

public class CommentLike {
    private int userId;
    private int commentId;
    private LocalDateTime createdAt;

    public CommentLike() {}

    public CommentLike(int userId, int commentId, LocalDateTime createdAt) {
        this.userId = userId;
        this.commentId = commentId;
        this.createdAt = createdAt;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getCommentId() { return commentId; }
    public void setCommentId(int commentId) { this.commentId = commentId; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
