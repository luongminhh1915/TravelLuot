-- =============================================
-- DATABASE: MẠNG XÃ HỘI DU LỊCH (TravelLuot)
-- SQL SERVER
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = N'travel_luot')
BEGIN
    CREATE DATABASE travel_luot COLLATE Vietnamese_CI_AS;
END
GO

USE travel_luot;
GO

-- =============================================
-- 1. ROLES
-- =============================================
CREATE TABLE roles (
    id TINYINT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(20) NOT NULL UNIQUE,
    name NVARCHAR(50) NOT NULL,
    description NVARCHAR(255),
    created_at DATETIME2 DEFAULT GETDATE()
);
GO

INSERT INTO roles (code, name, description) VALUES
(N'ADMIN', N'Quản trị viên', N'Quản lý hệ thống'),
(N'USER',  N'Thành viên',   N'Người dùng thường');
GO

-- =============================================
-- 2. USERS
-- =============================================
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    role_id TINYINT NOT NULL DEFAULT 2,
    username NVARCHAR(50) NOT NULL UNIQUE,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    full_name NVARCHAR(100),
    avatar_url NVARCHAR(500),
    bio NVARCHAR(MAX),
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT fk_user_role 
        FOREIGN KEY (role_id) REFERENCES roles(id)
);
GO

-- =============================================
-- 3. LOCATIONS
-- =============================================
CREATE TABLE locations (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(200) NOT NULL,
    address NVARCHAR(500),
    city NVARCHAR(100),
    country NVARCHAR(100),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    description NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE()
);
GO

-- =============================================
-- 4. POSTS
-- =============================================
CREATE TABLE posts (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    content NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT fk_post_user 
        FOREIGN KEY (user_id) REFERENCES users(id)
);
GO

-- =============================================
-- 5. CHECK-INS
-- =============================================
CREATE TABLE check_ins (
    id INT IDENTITY(1,1) PRIMARY KEY,
    post_id INT NOT NULL UNIQUE,
    location_id INT NOT NULL,
    check_in_at DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT fk_ci_post 
        FOREIGN KEY (post_id) REFERENCES posts(id),
    CONSTRAINT fk_ci_location 
        FOREIGN KEY (location_id) REFERENCES locations(id)
);
GO

-- =============================================
-- 6. POST PHOTOS
-- =============================================
CREATE TABLE post_photos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    post_id INT NOT NULL,
    image_url NVARCHAR(500) NOT NULL,
    sort_order SMALLINT DEFAULT 0,
    caption NVARCHAR(255),
    created_at DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT fk_photo_post 
        FOREIGN KEY (post_id) REFERENCES posts(id)
);
GO

-- =============================================
-- 7. POST LIKES
-- =============================================
CREATE TABLE post_likes (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT pk_post_like 
        PRIMARY KEY (user_id, post_id),
    CONSTRAINT fk_pl_user 
        FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_pl_post 
        FOREIGN KEY (post_id) REFERENCES posts(id)
);
GO

-- =============================================
-- 8. COMMENTS
-- =============================================
CREATE TABLE comments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    parent_comment_id INT NULL,
    content NVARCHAR(MAX) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT fk_comment_user 
        FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_comment_post 
        FOREIGN KEY (post_id) REFERENCES posts(id),
    CONSTRAINT fk_comment_parent 
        FOREIGN KEY (parent_comment_id) REFERENCES comments(id)
);
GO

-- =============================================
-- 9. COMMENT LIKES
-- =============================================
CREATE TABLE comment_likes (
    user_id INT NOT NULL,
    comment_id INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT pk_comment_like 
        PRIMARY KEY (user_id, comment_id),
    CONSTRAINT fk_cl_user 
        FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_cl_comment 
        FOREIGN KEY (comment_id) REFERENCES comments(id)
);
GO

-- =============================================
-- 10. FOLLOWS
-- =============================================
CREATE TABLE follows (
    follower_id INT NOT NULL,
    following_id INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT pk_follow 
        PRIMARY KEY (follower_id, following_id),
    CONSTRAINT fk_follow_follower 
        FOREIGN KEY (follower_id) REFERENCES users(id),
    CONSTRAINT fk_follow_following 
        FOREIGN KEY (following_id) REFERENCES users(id),
    CONSTRAINT chk_follow_self 
        CHECK (follower_id <> following_id)
);
GO

-- =============================================
-- 11. LOCATION REVIEWS
-- =============================================
CREATE TABLE location_reviews (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    location_id INT NOT NULL,
    rating TINYINT NOT NULL,
    content NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT fk_review_user 
        FOREIGN KEY (user_id) REFERENCES users(id),
    CONSTRAINT fk_review_location 
        FOREIGN KEY (location_id) REFERENCES locations(id),
    CONSTRAINT uq_review 
        UNIQUE (user_id, location_id),
    CONSTRAINT chk_rating 
        CHECK (rating BETWEEN 1 AND 5)
);
GO
