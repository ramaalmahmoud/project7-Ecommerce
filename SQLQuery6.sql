

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

CREATE TABLE UserAddresses (
    AddressID INT PRIMARY KEY IDENTITY(1,1),  
    UserID INT,  -- Foreign key to Users table
    Street NVARCHAR(255),  -- Street name
    City NVARCHAR(100),    -- City name
    HomeNumberCode NVARCHAR(50),  -- Home number or code
    CONSTRAINT FK_UserAddresses_Users FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);
ALTER TABLE Users
DROP COLUMN Address;

ALTER TABLE Orders
ADD OrderDate DATE;


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
CREATE TABLE UserRoles (
UserID INT,
Role NVARCHAR(50),
CONSTRAINT PK_UserRoles PRIMARY KEY (UserID, Role),
CONSTRAINT FK_UserRole_User FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
INSERT INTO UserRoles (UserID, Role)
VALUES
(1, 'Admin'),
(2, 'Client');


-- 9. OrderItems Table
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    ProductID INT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    Quantity INT,
);

alter table Users
add  Uid NVARCHAR(100)
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

-- Insert Categories
INSERT INTO Categories (CategoryName, CategoryDescription, CategoryImage)
VALUES 
('Chocolate', 'Delicious and creamy chocolate treats.', 'https://serenadechocolatier.com/wp-content/uploads/Solid-Chocolate-Bars.jpg'),
('Gummies', 'Sweet and chewy gummy candies.', 'https://cdn11.bigcommerce.com/s-riqk6cih6h/images/stencil/758w/image-manager/albanese-gummies-landing-page-banners-transparent-1600x1200-with-shadow.png?t=1699975186'),
('Lollipops', 'Colorful and flavorful lollipops.', 'https://www.yumjunkie.com/cdn/shop/products/rainbow-swirl-lollipop-134356-ic_800x.jpg?v=1552002213'),
('Hard Candies', 'Classic hard candy sweets.', 'https://m.media-amazon.com/images/I/71LvbCYZt+L.jpg');

-- Insert Products for Chocolate Category (ID = 1)
INSERT INTO Products (ProductName, ProductDescription, Price, Stock, CategoryID, ProductImage)
VALUES
('Milk Chocolate Bar', 'Smooth milk chocolate bar.', 2.99, 50, 1, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDo33EIv1Ee4D-YQJ2Y0ZWDBEpOKQnEgtIuw&s'),
('Dark Chocolate Bar', 'Rich dark chocolate bar.', 3.49, 40, 1, 'https://www.neuchatelchocolates.com/cdn/shop/products/MG_0889_3888x.jpg?v=1597087074'),
('White Chocolate Bar', 'Creamy white chocolate bar.', 3.29, 35, 1, 'https://www.snelgroves.net/cdn/shop/products/image.webp?v=1678762870&width=1445'),
('Hazelnut Chocolate', 'Chocolate with crunchy hazelnuts.', 4.19, 20, 1, 'https://media.istockphoto.com/id/171301120/photo/chocolate.jpg?s=612x612&w=0&k=20&c=8bf0f-AaxLAO_saSTAnEU_aBKh1_Ac9zds-hDDphfvM='),
('Caramel Chocolate', 'Milk chocolate with caramel filling.', 3.99, 45, 1, 'https://chocolatebox.com.au/cdn/shop/products/chewycaramel_1e8cf0d2-ff29-4ff5-b88d-90207bddb96f_1024x1024.jpg?v=1539361472'),
('Chocolate Truffles', 'Rich chocolate truffles with a soft center.', 5.99, 25, 1, 'https://i.ytimg.com/vi/4_YBELE4LpM/maxresdefault.jpg'),
('Mint Chocolate', 'Mint-flavored dark chocolate.', 2.89, 50, 1, 'https://cdn11.bigcommerce.com/s-riqk6cih6h/images/stencil/1280x1280/products/238/2141/240014_1__68398.1671489266.jpg?c=1'),
('Almond Chocolate', 'Milk chocolate with crunchy almonds.', 4.39, 30, 1, 'https://cdn11.bigcommerce.com/s-riqk6cih6h/images/stencil/1280x1280/products/359/1027/milk-chocolate-almonds_6__56193.1617647170.jpg?c=1'),
('Crispy Chocolate', 'Crispy rice milk chocolate.', 2.69, 40, 1, 'https://www.shutterstock.com/image-photo/two-halves-cut-chocolate-bar-600nw-2400261709.jpg'),
('Chocolate-Covered Raisins', 'Raisins coated with milk chocolate.', 3.49, 45, 1, 'https://kopperschocolate.com/cdn/shop/products/5021_ChocolateRaisins_pile_5348x3565-8-26_Edited.jpg?v=1680011975'),
('Peanut Butter Cups', 'Chocolate cups filled with peanut butter.', 3.79, 40, 1, 'https://theeburgerdude.com/wp-content/uploads/2023/10/Reeses-Blog-3-1024x1024.jpg'),
('Chocolate Wafer Bar', 'Crispy wafer covered in milk chocolate.', 2.59, 60, 1, 'https://www.flavorwest.com/media/catalog/product/cache/085fc105dc8f0c7aadbba120cd78cd81/c/h/chocolatewaferbarweb.jpg');

-- Insert Products for Gummies Category (ID = 2)
INSERT INTO Products (ProductName, ProductDescription, Price, Stock, CategoryID, ProductImage)
VALUES
('Gummy Bears', 'Classic gummy bears in various flavors.', 1.99, 100, 2, 'https://cdn11.bigcommerce.com/s-riqk6cih6h/images/stencil/1280x1280/products/140/2087/50270_1__56109.1656534407.jpg?c=1'),
('Sour Gummies', 'Tangy and sour gummy candies.', 2.29, 80, 2, 'https://nyspiceshop.com/cdn/shop/products/SuperSourWorms2_2000x.jpg?v=1638354808'),
('Fruit Gummy Rings', 'Fruit-flavored gummy rings.', 2.79, 70, 2, 'https://funfactorysweets.com/cdn/shop/products/assortedfruitrings_grande.jpg?v=1673999643'),
('Gummy Worms', 'Chewy gummy worms in fruity flavors.', 1.89, 90, 2, 'https://www.raisingthecandybar.com/cdn/shop/products/GummiWorms04964.jpg?v=1676504640'),
('Gummy Sharks', 'Fruit-flavored gummy sharks.', 2.39, 85, 2, 'https://cdn11.bigcommerce.com/s-riqk6cih6h/images/stencil/1280x1280/products/215/1410/50193_1__29479.1668014904.png?c=1'),
('Rainbow Gummy Belts', 'Colorful and chewy gummy belts.', 2.99, 75, 2, 'https://allcitycandy.com/cdn/shop/products/vidalsourrainbowbites_2048x.jpg?v=1712933944'),
('Gummy Fruit Slices', 'Gummy candies shaped like fruit slices.', 1.79, 95, 2, 'https://images.squarespace-cdn.com/content/v1/57bba614f5e23115c18ded52/1620671162526-SRRB7EZJN250EDHT2MJQ/large-assorted-unwrapped-fruit-slices-1c.jpg?format=1000w'),
('Gummy Hearts', 'Heart-shaped gummy candies.', 2.19, 65, 2, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCC3tEARW8OPk1qdKhhFI9lEIy5xhQtrPJFw&s'),
('Cola Gummies', 'Gummy candies with a cola flavor.', 2.49, 80, 2, 'https://truetreatscandy.com/wp-content/uploads/2017/05/Gummy-cola-scaled.jpg'),
('Gummy Peach Rings', 'Peach-flavored gummy rings.', 2.59, 70, 2, 'https://cdn11.bigcommerce.com/s-riqk6cih6h/images/stencil/1280x1280/products/538/2078/50129_albanese-peach-rings__19848.1656534117.png?c=1'),
('Gummy Sour Cherries', 'Sour cherry-flavored gummies.', 2.19, 60, 2, 'https://www.candywarehouse.com/cdn/shop/files/haribo-gummy-sour-cherries-candy-5lb-bag-candy-warehouse-1_2e8460be-870d-43cf-bafc-378264599d46.jpg?v=1689305338'),
('Gummy Frogs', 'Gummy candies shaped like frogs.', 2.89, 50, 2, 'https://allcitycandy.com/cdn/shop/products/125861-01_haribo-gummy-frogs-candy-3-75lb-box_2048x.jpg?v=1659027206');

-- Insert Products for Lollipops Category (ID = 3)
INSERT INTO Products (ProductName, ProductDescription, Price, Stock, CategoryID, ProductImage)
VALUES
('Cherry Lollipop', 'Classic cherry-flavored lollipop.', 0.99, 120, 3, 'https://www.ohnuts.com/noapp/showImage.cfm/extra-large/_MG_22471.jpg'),
('Strawberry Lollipop', 'Strawberry-flavored lollipop.', 1.19, 110, 3, 'https://m.media-amazon.com/images/I/61maDbPZAQL._AC_UF1000,1000_QL80_.jpg'),
('Cola Lollipop', 'Cola-flavored lollipop.', 0.89, 130, 3, 'https://atlas-content-cdn.pixelsquid.com/stock-images/chupa-chups-lollipop-cola-72rK8y4-600.jpg'),
('Sour Apple Lollipop', 'Tangy sour apple-flavored lollipop.', 1.29, 100, 3, 'https://m.media-amazon.com/images/I/51IMnYkQFtL.jpg'),
('Rainbow Swirl Lollipop', 'Colorful swirl lollipop.', 1.99, 90, 3, 'https://www.giantbradleyssweetshop.com/cdn/shop/files/Rainbow-Swirl-Lollipops-55g.webp?v=1696137889'),
('Grape Lollipop', 'Grape-flavored lollipop.', 1.09, 115, 3, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXMKp31RVRCdorYjMYpAfV3TqEzLqBWmM2Tg&s'),
('Orange Lollipop', 'Citrus orange-flavored lollipop.', 1.09, 105, 3, 'https://houseofcandy.in/cdn/shop/files/lolipops_3_1800x.png?v=1697197239'),
('Bubblegum Lollipop', 'Bubblegum-flavored lollipop.', 1.29, 95, 3, 'https://www.candywarehouse.com/cdn/shop/files/original-gourmet-bubble-gum-pops-60-piece-bag-candy-warehouse-1.jpg?v=1689319954'),
('Cotton Candy Lollipop', 'Cotton candy-flavored lollipop.', 1.49, 85, 3, 'https://www.brutusmonroe.com/cdn/shop/files/charms-fluffy-stuff-cotton-candy-pops-48-piece-box-candy-warehouse-1_0a1c2026-3dab-47d0-8e7b-61a29da7ff01_700x700.jpg?v=1715804966'),
('Watermelon Lollipop', 'Juicy watermelon-flavored lollipop.', 1.19, 110, 3, 'https://m.media-amazon.com/images/I/51Zp5u1Q8BL.jpg'),
('Blue Raspberry Lollipop', 'Blue raspberry-flavored lollipop.', 1.29, 100, 3, 'https://hammondscandies.com/cdn/shop/products/Untitleddesign_71.jpg?v=1613776860&width=2048'),
('Lemon Lollipop', 'Zesty lemon-flavored lollipop.', 0.99, 120, 3, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpY1KlsYy1wYeF0p9tsO3HOB7Sp_tLdvamPg&s');

-- Insert Products for Hard Candies Category (ID = 4)
INSERT INTO Products (ProductName, ProductDescription, Price, Stock, CategoryID, ProductImage)
VALUES
('Butterscotch Candy', 'Rich and creamy butterscotch candy.', 1.49, 75, 4, 'https://allcitycandy.com/cdn/shop/products/ButterscotchDiscsHardCandy1_2048x.jpg?v=1671727250'),
('Peppermint Candy', 'Classic peppermint-flavored candy.', 1.19, 95, 4, 'https://content.oppictures.com/Master_Images/Master_Variants/Variant_1500/835548.jpg'),
('Cinnamon Hard Candy', 'Spicy cinnamon-flavored hard candy.', 1.39, 85, 4, 'https://allcitycandy.com/cdn/shop/products/Sunrise_Cinnamon_Disks_Hard_Candy_-_3_LB_Bulk_Bag_600x.jpg?v=1572014724'),
('Lemon Drops', 'Zesty and tart lemon-flavored hard candy.', 1.29, 90, 4, 'https://www.lorentanuts.com/wp-content/uploads/2021/02/Lemon-Drops-Perspective-www.lorentanuts.com_.jpg'),
('Root Beer Barrels', 'Root beer-flavored hard candy.', 1.79, 60, 4, 'https://cdn.troyerscountrymarket.com/wp-content/uploads/2020/04/images__9_.jpg'),
('Strawberry Bonbons', 'Strawberry-flavored hard bonbons.', 1.59, 80, 4, 'https://i.ebayimg.com/images/g/-RsAAOSw9pNcwK2X/s-l1200.jpg'),
('Coffee Hard Candy', 'Hard candy with a coffee flavor.', 1.69, 70, 4, 'https://www.candywarehouse.com/cdn/shop/files/bali-s-best-hard-candy-coffee-1kg-bag-candy-warehouse-1_26ea36fd-8fee-4967-9788-7a9a90988dfa.jpg?v=1689303217'),
('Honey Drops', 'Hard candy made with real honey.', 1.99, 55, 4, 'https://www.candywarehouse.com/cdn/shop/files/arcor-honey-drops-hard-candy-6-ounce-bag-candy-warehouse-1.jpg?v=1689318053'),
('Fruit-flavored Candies', 'Assorted fruit-flavored hard candies.', 1.29, 100, 4, 'https://www.mashed.com/img/gallery/fruit-flavored-candy-was-my-childhood-nightmare/l-intro-1697050778.jpg'),
('Sour Lemon Candy', 'Sour and tangy lemon hard candy.', 1.29, 85, 4, 'https://www.lorentanuts.com/wp-content/uploads/2021/03/Lemon-Drops-www.LorentaNuts.com_.jpg'),
('Caramel Hard Candy', 'Classic caramel-flavored hard candy.', 1.79, 65, 4, 'https://m.media-amazon.com/images/I/61ZsirxWeWL._AC_UF894,1000_QL80_.jpg'),
('Cherry Hard Candy', 'Sweet cherry-flavored hard candy.', 1.19, 95, 4, 'https://www.bulkecandy.com/cdn/shop/products/golightly-sf-cherry-single-130360-im__24483.jpeg?v=1455584009');