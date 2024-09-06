﻿

USE SixthProEcommerce;

-- 1. Users Table
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),  
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Password NVARCHAR(255),
    PasswordHash VARBINARY(MAX),
    PasswordSalt VARBINARY(MAX),
    Phone NVARCHAR(15),
    Address NVARCHAR(255),
    ProfileImage NVARCHAR(MAX),
    Points INT DEFAULT 0,
    UserType NVARCHAR(50), -- Admin, Customer
);


-- 2. Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100),
    CategoryDescription NVARCHAR(255),
    CategoryImage NVARCHAR(MAX),
);


-- 3. Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100),
    ProductDescription NVARCHAR(MAX),
    Price DECIMAL(10, 2),
    Stock INT,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    Discount DECIMAL(5, 2) DEFAULT 0,
    ProductImage NVARCHAR(MAX),
);


-- 4. Cart Table
CREATE TABLE Cart (
    CartID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    TotalAmount DECIMAL(10, 2),
);

-- 5. CartItems Table
CREATE TABLE CartItems (
    CartItemID INT PRIMARY KEY IDENTITY(1,1),
    CartID INT,
    FOREIGN KEY (CartID) REFERENCES Cart(CartID),
    ProductID INT, 
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    Quantity INT,
);

-- 6. Vouchers Table
CREATE TABLE Voucher (
    ID INT PRIMARY KEY IDENTITY,  -- معرف القسيمة
    VoucherCode VARCHAR(50) NULL,              -- رمز القسيمة (يمكن أن يكون NULL)
    DiscountValue DECIMAL NULL,                -- قيمة الخصم (يمكن أن تكون NULL، بدون تفاصيل دقة)
    ValidFrom DATE NULL,                       -- تاريخ بداية صلاحية القسيمة (يمكن أن يكون NULL)
    ValidTo DATE NULL,                         -- تاريخ نهاية صلاحية القسيمة (يمكن أن يكون NULL)
    MinimumCartValue DECIMAL NULL,             -- الحد الأدنى لقيمة سلة المشتريات لتفعيل القسيمة (يمكن أن يكون NULL)
    ProductID INT NULL,                        -- إذا كانت القسيمة مخصصة لمنتج معين (يمكن أن يكون NULL)
    MaxUsagePerUser INT NULL,                  -- الحد الأقصى لاستخدام القسيمة لكل مستخدم (يمكن أن يكون NULL)
    MaxTotalUsage INT NULL,                    -- الحد الأقصى لاستخدام القسيمة بشكل عام (يمكن أن يكون NULL)
    IsActive int NULL                     -- 0 for false, 1 for true
);

-- 7. UserVoucherUsage Table
CREATE TABLE UserVoucherUsage (
    ID INT PRIMARY KEY IDENTITY,
    UserID INT,                             -- معرف المستخدم
    VoucherID INT,                          -- معرف القسيمة
    UsageCount INT DEFAULT 1,               -- عدد مرات استخدام القسيمة من قبل هذا المستخدم
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (VoucherID) REFERENCES Voucher(ID)
);

-- 8. Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    TotalAmount DECIMAL(10, 2),
    PaymentMethod NVARCHAR(50), -- Credit Card, PayPal, cash
    OrderStatus NVARCHAR(50), -- Pending, Completed, Cancelled
);


-- 9. OrderItems Table
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    ProductID INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    Quantity INT,
);


-- 10. Comments Table
CREATE TABLE Comments (
    CommentID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CommentText NVARCHAR(1000),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Status VARCHAR(50), -- Pending or Approved
    CreatedAt DATETIME DEFAULT GETDATE(),
);

-- 11. Logger Table
CREATE TABLE Logger (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    LogMessage NVARCHAR(1000),
    LogLevel NVARCHAR(50), -- Info, Warning, Error
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 12. Feedback Table
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Email NVARCHAR(100),
    Subject NVARCHAR(255),
    Message NVARCHAR(1000),
    SentDate DATE,
);