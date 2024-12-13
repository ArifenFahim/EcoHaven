-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 13, 2024 at 09:31 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ecommerceapp`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddReview` (IN `userId` INT, IN `productId` INT, IN `rating` INT, IN `reviewText` TEXT)   BEGIN
    INSERT INTO Reviews (user_id, product_id, rating, review_text)
    VALUES (userId, productId, rating, reviewText);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RemoveReview` (IN `reviewId` INT)   BEGIN
    DELETE FROM Reviews 
    WHERE review_id = reviewId;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `is_active` enum('0','1') NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `name`, `email`, `password`, `is_active`) VALUES
(9, 'Radoanul Arifen ', 'arifen15-5284@diu.edu.bd', '$2y$10$vq7rl8DUt5QAKYkGRXZXjuf.295LjajbsYvOwgFDo9sWYu3589gbO', '0'),
(10, 'Ashik Mahmud Pullock', 'pullock15-4981@diu.edu.bd', '$2y$10$m8A2gJNlkqtqoxa3MyfkRO.lyIPK0AFq3eOrSg3hNdOX2uqNap4ba', '0'),
(11, 'S.M Meriyan Islam', 'islam15-5285@diu.edu.bd', '$2y$10$AKJMXASKqAHZNcoUzvDBxusXfSZKxRClfswcRXfm6xLqfFoUCSYVe', '0'),
(12, 'Miskat Rasid Riad', 'riad15-5066@diu.edu.bd', '$2y$10$RmrVJ.6xOBJTtc3g3MESYOHSW2/KZfxXHyFlFuePkIW.SAJQR.PRW', '0');

-- --------------------------------------------------------

--
-- Table structure for table `brands`
--

CREATE TABLE `brands` (
  `brand_id` int(100) NOT NULL,
  `brand_title` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `brands`
--

INSERT INTO `brands` (`brand_id`, `brand_title`) VALUES
(1, 'LuxeNature Foods'),
(11, 'NatureNest'),
(12, 'LushAura'),
(13, 'BotaniPure'),
(14, 'EcoWear Co');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(10) NOT NULL,
  `p_id` int(10) NOT NULL,
  `ip_add` varchar(250) NOT NULL,
  `user_id` int(10) DEFAULT NULL,
  `qty` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `p_id`, `ip_add`, `user_id`, `qty`) VALUES
(1, 4, '::1', 4, 1),
(7, 24, '::1', 3, 2),
(124, 24, '::1', 10, 1),
(125, 25, '::1', 10, 1);

--
-- Triggers `cart`
--
DELIMITER $$
CREATE TRIGGER `after_cart_delete` AFTER DELETE ON `cart` FOR EACH ROW BEGIN
    -- Delete the corresponding order when a row is deleted from the cart
    DELETE FROM orders 
    WHERE user_id = OLD.user_id AND product_id = OLD.p_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_cart_insert` AFTER INSERT ON `cart` FOR EACH ROW BEGIN
    -- Check if an order already exists for the same user_id and product_id
    IF NOT EXISTS (
        SELECT 1 
        FROM orders 
        WHERE user_id = NEW.user_id AND product_id = NEW.p_id
    ) THEN
        -- Insert into the orders table when a new row is added to the cart
        INSERT INTO orders (user_id, product_id, qty)
        VALUES (NEW.user_id, NEW.p_id, NEW.qty);
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_product_stock_after_cart_remove` AFTER DELETE ON `cart` FOR EACH ROW BEGIN
    -- Update the stock of the product in the products table after an item is removed from the cart
    UPDATE products
    SET product_qty = product_qty + OLD.qty
    WHERE product_id = OLD.p_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `cat_id` int(100) NOT NULL,
  `cat_title` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`cat_id`, `cat_title`) VALUES
(2, 'Organic Foods'),
(3, 'Eco-Friendly Products'),
(4, 'Natural Skincare'),
(5, 'Herbal Supplements'),
(6, 'Eco-Clothing'),
(14, 'Eco-Friendly Furniture');

-- --------------------------------------------------------

--
-- Table structure for table `customer_feedback`
--

CREATE TABLE `customer_feedback` (
  `FeedbackID` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `Rating` int(11) DEFAULT NULL CHECK (`Rating` between 1 and 5),
  `Comment` text DEFAULT NULL,
  `FeedbackDate` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_feedback`
--

INSERT INTO `customer_feedback` (`FeedbackID`, `customer_id`, `product_id`, `Rating`, `Comment`, `FeedbackDate`) VALUES
(1, 1, 1, 5, 'Excellent organic produce, super fresh!', '2024-11-17 20:50:22'),
(2, 2, 2, 4, 'Great quality but delivery was slightly delayed.', '2024-11-17 20:50:22'),
(3, 3, 3, 3, 'Average experience, packaging could be better.', '2024-11-17 20:50:22'),
(4, 4, 4, 5, 'Loved the eco-friendly approach!', '2024-11-17 20:50:22'),
(5, 5, 5, 4, 'Products are good, price is reasonable.', '2024-11-17 20:50:22'),
(6, 6, 6, 5, 'Absolutely amazing skincare products!', '2024-11-17 20:50:22'),
(7, 7, 7, 4, 'Good, but can improve delivery speed.', '2024-11-17 20:50:22'),
(8, 8, 8, 5, 'Perfect for my zero-waste lifestyle!', '2024-11-17 20:50:22'),
(9, 9, 9, 3, 'Quality is okay, but could be better.', '2024-11-17 20:50:22'),
(10, 10, 10, 5, 'Great product for the price!', '2024-11-17 20:50:22');

-- --------------------------------------------------------

--
-- Table structure for table `discounts`
--

CREATE TABLE `discounts` (
  `DiscountID` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `DiscountPercentage` decimal(5,2) NOT NULL,
  `StartDate` datetime NOT NULL,
  `EndDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `discounts`
--

INSERT INTO `discounts` (`DiscountID`, `product_id`, `DiscountPercentage`, `StartDate`, `EndDate`) VALUES
(1, 1, 10.00, '2024-11-01 00:00:00', '2024-11-15 23:59:59'),
(2, 2, 15.00, '2024-11-05 00:00:00', '2024-11-20 23:59:59'),
(3, 3, 5.00, '2024-11-10 00:00:00', '2024-11-25 23:59:59'),
(4, 4, 20.00, '2024-11-15 00:00:00', '2024-11-30 23:59:59'),
(5, 5, 25.00, '2024-11-01 00:00:00', '2024-11-10 23:59:59'),
(6, 6, 30.00, '2024-11-11 00:00:00', '2024-11-21 23:59:59'),
(7, 7, 10.00, '2024-11-01 00:00:00', '2024-11-15 23:59:59'),
(8, 8, 15.00, '2024-11-05 00:00:00', '2024-11-20 23:59:59'),
(9, 9, 20.00, '2024-11-10 00:00:00', '2024-11-25 23:59:59'),
(10, 10, 5.00, '2024-11-15 00:00:00', '2024-11-30 23:59:59');

-- --------------------------------------------------------

--
-- Table structure for table `exchange`
--

CREATE TABLE `exchange` (
  `exchange_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `exchange`
--

INSERT INTO `exchange` (`exchange_id`, `order_id`) VALUES
(10, 1),
(8, 2),
(9, 3),
(1, 4),
(2, 5),
(3, 6),
(4, 7),
(5, 8),
(6, 9),
(7, 10);

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `InventoryID` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `StockLevel` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `inventory_status`
-- (See below for the actual view)
--
CREATE TABLE `inventory_status` (
`product_id` int(100)
,`product_title` varchar(255)
,`StockLevel` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `NotificationID` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `Message` text NOT NULL,
  `NotificationDate` datetime DEFAULT current_timestamp(),
  `IsRead` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`NotificationID`, `user_id`, `Message`, `NotificationDate`, `IsRead`) VALUES
(1, 1, 'Your order #1 has been shipped.', '2024-11-15 11:00:00', 0),
(2, 2, 'Your order #2 is in transit.', '2024-11-16 13:00:00', 0),
(3, 3, 'Your order #3 has been delivered.', '2024-11-17 15:00:00', 1),
(4, 4, 'Order #4 is pending shipment.', '2024-11-18 10:00:00', 0),
(5, 5, 'A new discount on Product #105 is available.', '2024-11-19 08:00:00', 0),
(6, 6, 'Restock alert for Product #106.', '2024-11-20 09:00:00', 0),
(7, 7, 'Your order #7 has been shipped.', '2024-11-21 14:00:00', 1),
(8, 8, 'Your order #8 is pending.', '2024-11-22 16:00:00', 0),
(9, 9, 'Restock alert for Product #109.', '2024-11-23 10:00:00', 0),
(10, 10, 'A new eco-friendly product is available.', '2024-11-24 12:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `qty` int(11) NOT NULL,
  `trx_id` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `product_id`, `qty`, `trx_id`) VALUES
(95, 10, 24, 1, ''),
(96, 10, 25, 1, '');

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `after_order_delete` AFTER DELETE ON `orders` FOR EACH ROW BEGIN
    -- Delete from purchase_history when an order is deleted
    DELETE FROM purchase_history
    WHERE order_id = OLD.order_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_order_insert` AFTER INSERT ON `orders` FOR EACH ROW BEGIN
    -- Insert into purchase_history when a new order is placed
    INSERT INTO purchase_history (order_id)
    VALUES (NEW.order_id);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_product_stock_after_order` AFTER INSERT ON `orders` FOR EACH ROW BEGIN
    -- Update the stock of the product in the products table after an order is placed
    UPDATE products
    SET product_qty = product_qty - NEW.qty
    WHERE product_id = NEW.product_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_details`
--

CREATE TABLE `order_details` (
  `OrderDetailID` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `Subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_details`
--

INSERT INTO `order_details` (`OrderDetailID`, `order_id`, `product_id`, `Quantity`, `Subtotal`) VALUES
(31, 1, 1, 3, 59.97),
(32, 2, 2, 1, 15.99),
(33, 3, 3, 2, 39.98),
(34, 4, 4, 1, 19.99),
(35, 5, 5, 5, 74.95),
(36, 6, 6, 2, 29.98),
(37, 7, 7, 1, 24.99),
(38, 8, 8, 4, 99.96),
(39, 9, 9, 3, 89.97),
(40, 10, 10, 1, 12.99);

-- --------------------------------------------------------

--
-- Stand-in structure for view `order_summary`
-- (See below for the actual view)
--
CREATE TABLE `order_summary` (
`order_id` int(11)
,`user_id` int(11)
,`product_id` int(11)
,`product_title` varchar(255)
,`order_quantity` int(11)
,`product_price` int(100)
,`total_price` bigint(66)
);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `payment_status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`payment_id`, `order_id`, `payment_status`) VALUES
(1, 1, 'Completed'),
(2, 2, 'Completed'),
(3, 3, 'Pending'),
(4, 4, 'Cancelled'),
(5, 5, 'Completed'),
(6, 6, 'Pending'),
(7, 7, 'Completed'),
(8, 8, 'Completed'),
(9, 9, 'Completed'),
(10, 10, 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(100) NOT NULL,
  `product_cat` int(11) NOT NULL,
  `product_brand` int(100) NOT NULL,
  `product_title` varchar(255) NOT NULL,
  `product_price` int(100) NOT NULL,
  `product_qty` int(11) NOT NULL,
  `product_desc` text NOT NULL,
  `product_image` text NOT NULL,
  `product_keywords` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `product_cat`, `product_brand`, `product_title`, `product_price`, `product_qty`, `product_desc`, `product_image`, `product_keywords`) VALUES
(24, 2, 1, 'Organic Apricots', 500, 21, 'Organic apricots are sweet, tangy, golden-orange fruits grown without synthetic chemicals. They have smooth skin, juicy flesh, and are rich in fiber, vitamins A and C, and potassium', '1733495253_Organic Dried Fruits.jpg', 'Apricots'),
(25, 2, 1, 'Black Raisin', 360, 19, 'Black raisins are dried grapes with a deep, dark color and a naturally sweet flavor. They are rich in antioxidants, iron, and fiber, making them a nutritious snack or ingredient for desserts and savory dishes', '1733495390_Organic Dried Fruits 2.jpg', 'Raisin'),
(26, 2, 1, 'Almond', 460, 10, 'Almonds are oval-shaped, crunchy nuts with a mild, buttery flavor. Packed with protein, healthy fats, vitamin E, and magnesium, they are a popular snack and versatile ingredient in both sweet and savory dishes.', '1733495455_Organic Dried Fruits 3.jpg', 'Almond'),
(27, 3, 11, 'Bamboo Toothbrush', 120, 10, '\r\nA bamboo toothbrush is an eco-friendly alternative to plastic toothbrushes, featuring a biodegradable bamboo handle and soft, durable bristles. It’s lightweight, comfortable to hold, and ideal for maintaining oral hygiene while reducing environmental impact. The bamboo is naturally antimicrobial, making it a hygienic and sustainable choice.', '1733495873_eco friendly 1.jpg', 'Toothbrush'),
(28, 3, 11, 'Wooden Cups', 320, 25, 'Wooden cups are eco-friendly, handcrafted drinking vessels made from natural wood. They offer a rustic, stylish design and are durable, lightweight, and reusable. Perfect for hot or cold beverages, these cups add a natural touch to your drinkware while being biodegradable and sustainable.', '1733496027_eco friendly 2.jpg', 'Cups'),
(29, 3, 11, 'Wooden Dish Brush', 450, 9, '\r\nA wooden dish brush is an eco-friendly cleaning tool made from sustainably sourced wood and natural bristles. It’s durable, ergonomic, and perfect for scrubbing dishes, pots, and pans. The biodegradable materials make it a sustainable alternative to plastic brushes, reducing environmental waste', '1733496221_eco friendly 3.jpg', 'Dish Brush'),
(30, 4, 12, 'Revolutionary Skin Care', 390, 12, 'Our natural, organic, revolutionary skincare line combines the purest botanical ingredients with cutting-edge formulations to nourish and rejuvenate your skin. Free from harmful chemicals, each product is crafted to enhance your natural beauty while promoting sustainabilit', '1733496513_N skin care 1.jpg', 'Skin Care'),
(31, 4, 12, 'Evolve Skincare', 720, 6, '\r\nEvolve Skincare is a premium brand focused on transforming your skincare routine with natural, organic ingredients. Designed to nurture, repair, and rejuvenate your skin, Evolve Skincare combines the best of nature with innovative formulations.', '1733496654_N skin care 2.png', 'Skincare'),
(32, 4, 12, 'Revolutionary Skin Care', 670, 5, '\r\nRevolutionary Skin Care is a forward-thinking skincare brand that combines cutting-edge technology with natural, organic ingredients to redefine beauty routines. Designed to deliver transformative results,', '1733496876_N skin care 3.png', 'Skin Care'),
(33, 5, 13, 'Karkuma Organic Turmeric', 500, 30, 'Karkuma Organic Turmeric Immune Booster is a functional food that helps maintain a strong immune system and supple health. The antioxidant-rich curcumin from turmeric promotes healthy inflammation, and Piperine helps the body absorb curcumin.', '1733498927_harbal 1.jpg', 'Organic Turmeric'),
(34, 5, 13, 'Spring Valley Black Cohosh', 430, 10, 'Spring Valley Black Cohosh Menopause Support Dietary Supplement Tablets, 40 mg, 100 Count', '1733498984_harbal 2.jpg', 'Black Cohosh'),
(35, 5, 13, 'Ginkgo biloba', 790, 23, 'Ginkgo biloba supports cognitive functions and stimulates peripheral circulation, which contributes to better hearing and vision. Ginkgo biloba, thanks to naturally occurring antioxidants (flavone glycosides), helps to protect cells against the harmful effects of free radicals. The composition has been enriched with BioPerine® black pepper extract. Black pepper supports digestion and nutrient absorption as well as enhances the effectiveness of herbal ingredients.', '1733499060_harbal 3.jpg', 'Ginkgo biloba'),
(36, 6, 14, 'Cotton V-Neck T-Shirt  ', 1190, 12, 'selling organic Scoop Neck Tee is an essential basic for your sustainable wardrobe.Fair Indigo clothing is made from organic Peruvian Pima Cotton.Yarns are certified by GOTS. Dyes are certified to Oeko-tex standard.', '1733499386_cloth 2.jpg', 'T-Shirt '),
(37, 6, 14, 'Padded Jacket Navy', 1599, 10, 'A corduroy essential in vintage look and oversized cropped fit: this jacket in timeless toffee tone is reminiscent of biker jackets from the old days and gives your look instantly a cool retro touch.\r\n', '1733500247_cloth 3.jpg', 'Jacket');

-- --------------------------------------------------------

--
-- Stand-in structure for view `products_sold`
-- (See below for the actual view)
--
CREATE TABLE `products_sold` (
`product_id` int(11)
,`product_title` varchar(255)
,`total_sold` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `product_details_with_stock`
-- (See below for the actual view)
--
CREATE TABLE `product_details_with_stock` (
`product_id` int(100)
,`product_cat` int(11)
,`product_brand` int(100)
,`product_title` varchar(255)
,`product_price` int(100)
,`product_qty` int(11)
,`StockLevel` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_history`
--

CREATE TABLE `purchase_history` (
  `history_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchase_history`
--

INSERT INTO `purchase_history` (`history_id`, `order_id`) VALUES
(50, 95),
(51, 96);

-- --------------------------------------------------------

--
-- Table structure for table `returns_product`
--

CREATE TABLE `returns_product` (
  `return_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `returns_product`
--

INSERT INTO `returns_product` (`return_id`, `order_id`, `reason`) VALUES
(1, 4, 'Defective item'),
(2, 5, 'Wrong item shipped'),
(3, 6, 'Didn’t meet expectations'),
(4, 7, 'Changed mind'),
(5, 8, 'Found a better product'),
(6, 9, 'Damaged during shipping'),
(7, 10, 'Product not as described'),
(8, 2, 'Needed different size'),
(9, 3, 'Product arrived late'),
(10, 1, 'Duplicate order');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` between 1 and 5),
  `review_text` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`review_id`, `user_id`, `product_id`, `rating`, `review_text`) VALUES
(1, 1, 1, 5, 'Excellent quality!'),
(2, 2, 2, 4, 'Very comfortable and sustainable.'),
(3, 3, 3, 5, 'Best toothbrush I’ve used.'),
(4, 4, 4, 4, 'Love the recycled paper.'),
(5, 5, 5, 3, 'Charges slower than expected.'),
(6, 6, 6, 5, 'Perfect for the environment.'),
(7, 7, 7, 4, 'Very durable.'),
(8, 8, 8, 5, 'Works well with my sensitive skin.'),
(9, 9, 9, 4, 'Useful and eco-friendly.'),
(10, 10, 10, 5, 'Great for daily use.');

-- --------------------------------------------------------

--
-- Table structure for table `shipments`
--

CREATE TABLE `shipments` (
  `ShipmentID` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `ShipmentDate` datetime NOT NULL,
  `Status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shipments`
--

INSERT INTO `shipments` (`ShipmentID`, `order_id`, `ShipmentDate`, `Status`) VALUES
(1, 1, '2024-11-15 10:00:00', 'Shipped'),
(2, 2, '2024-11-16 12:00:00', 'In Transit'),
(3, 3, '2024-11-17 14:30:00', 'Delivered'),
(4, 4, '2024-11-18 09:00:00', 'Pending'),
(5, 5, '2024-11-19 11:45:00', 'Shipped'),
(6, 6, '2024-11-20 16:00:00', 'Delivered'),
(7, 7, '2024-11-21 13:15:00', 'In Transit'),
(8, 8, '2024-11-22 15:30:00', 'Pending'),
(9, 9, '2024-11-23 10:45:00', 'Shipped'),
(10, 10, '2024-11-24 17:00:00', 'Delivered');

-- --------------------------------------------------------

--
-- Table structure for table `shoppingcart`
--

CREATE TABLE `shoppingcart` (
  `cart_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL CHECK (`quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shoppingcart`
--

INSERT INTO `shoppingcart` (`cart_id`, `user_id`, `product_id`, `quantity`) VALUES
(1, 1, 1, 2),
(2, 2, 3, 1),
(3, 3, 5, 1),
(4, 4, 7, 3),
(5, 5, 2, 1),
(6, 6, 9, 2),
(7, 7, 4, 1),
(8, 8, 6, 1),
(9, 9, 8, 2),
(10, 10, 10, 1);

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `SupplierID` int(11) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `ContactEmail` varchar(100) DEFAULT NULL,
  `PhoneNumber` varchar(15) DEFAULT NULL,
  `Address` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`SupplierID`, `Name`, `ContactEmail`, `PhoneNumber`, `Address`) VALUES
(1, 'GreenHarvest Farms', 'contact@greenharvest.com', '555-1234', '42 Nature Way, Greenfield'),
(2, 'EcoLife Supplies', 'support@ecolife.com', '555-5678', '88 Sustainable Rd, EcoCity'),
(3, 'PureNature Co.', 'info@purenature.com', '555-9876', '105 Organic Ave, Naturaltown'),
(4, 'SolarTech Solutions', 'service@solartech.com', '555-6543', '12 Solar Blvd, Sunville'),
(5, 'NatureGlow Skincare', 'help@natureglow.com', '555-3219', '22 Glow Street, EcoValley'),
(6, 'GreenFiber Textiles', 'textiles@greenfiber.com', '555-4321', '78 Organic Lane, EcoMetropolis'),
(7, 'EcoBox Co.', 'sales@ecobox.com', '555-8765', '90 Biodegradable St, GreenCity'),
(8, 'HerbalCare Supplies', 'contact@herbalcare.com', '555-5672', '15 Herb Alley, Wellnessville'),
(9, 'ReNew Creations', 'info@renewcreations.com', '555-5432', '33 Recycle Rd, Sustainability City'),
(10, 'EcoWood Furniture', 'orders@ecowood.com', '555-7654', '54 Forest Ave, EcoVillage');

-- --------------------------------------------------------

--
-- Table structure for table `userprofiles`
--

CREATE TABLE `userprofiles` (
  `profile_id` int(11) NOT NULL,
  `preference` varchar(100) DEFAULT NULL,
  `purchase_history_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `userprofiles`
--

INSERT INTO `userprofiles` (`profile_id`, `preference`, `purchase_history_id`, `user_id`) VALUES
(1, 'Prefers organic products', 1, 1),
(2, 'Eco-friendly household items', 2, 2),
(3, 'Sustainable clothing', 3, 3),
(4, 'Biodegradable personal care', 4, 4),
(5, 'Plastic-free accessories', 5, 5),
(6, 'Recycled stationery', 6, 6),
(7, 'Compostable materials', 7, 7),
(8, 'Plant-based cleaners', 8, 8),
(9, 'Reusable kitchenware', 9, 9),
(10, 'Eco-friendly electronics', 10, 10);

-- --------------------------------------------------------

--
-- Table structure for table `user_info`
--

CREATE TABLE `user_info` (
  `user_id` int(10) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(300) NOT NULL,
  `password` varchar(300) NOT NULL,
  `mobile` varchar(10) NOT NULL,
  `address1` varchar(300) NOT NULL,
  `address2` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `user_info`
--

INSERT INTO `user_info` (`user_id`, `first_name`, `last_name`, `email`, `password`, `mobile`, `address1`, `address2`) VALUES
(1, 'Mariyen', 'Islam', 'islam@gmail.com', '25f9e794323b453885f5181f1b624d0b', '1543876098', 'Dhaka', 'Noakhali'),
(2, 'Miskat', 'Rasid', 'rasid@gmail.com', '25f9e794323b453885f5181f1b624d0b', '1897650987', 'Dhaka', 'Cox Bazar'),
(3, 'Ashik Mahmud', 'Pullock', 'pullock@gmail.com', '25f9e794323b453885f5181f1b624d0b', '1624334044', 'Dhaka', 'Ashulia'),
(10, 'Arifen', 'Fahim', 'fahim@gmail.com', '25f9e794323b453885f5181f1b624d0b', '1632665398', 'Dhaka', 'cumilla');

-- --------------------------------------------------------

--
-- Stand-in structure for view `user_order_history`
-- (See below for the actual view)
--
CREATE TABLE `user_order_history` (
`order_id` int(11)
,`user_id` int(11)
,`product_id` int(11)
,`product_title` varchar(255)
,`order_quantity` int(11)
,`product_price` int(100)
,`total_price` bigint(66)
,`trx_id` varchar(255)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `user_purchase_history`
-- (See below for the actual view)
--
CREATE TABLE `user_purchase_history` (
`history_id` int(11)
,`order_id` int(11)
,`user_id` int(11)
,`product_id` int(11)
,`product_title` varchar(255)
,`order_quantity` int(11)
,`trx_id` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `wishlists`
--

CREATE TABLE `wishlists` (
  `wishlist_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `product_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`product_ids`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wishlists`
--

INSERT INTO `wishlists` (`wishlist_id`, `user_id`, `product_ids`) VALUES
(1, 1, '[\"1\", \"2\", \"3\"]'),
(2, 2, '[\"2\", \"4\", \"5\"]'),
(3, 3, '[\"1\", \"5\", \"6\"]'),
(4, 4, '[\"7\", \"8\"]'),
(5, 5, '[\"3\", \"9\"]'),
(6, 6, '[\"2\", \"10\"]'),
(7, 7, '[\"4\", \"5\"]'),
(8, 8, '[\"1\", \"6\", \"7\"]'),
(9, 9, '[\"8\", \"9\", \"10\"]'),
(10, 10, '[\"3\", \"7\", \"10\"]');

-- --------------------------------------------------------

--
-- Structure for view `inventory_status`
--
DROP TABLE IF EXISTS `inventory_status`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `inventory_status`  AS SELECT `p`.`product_id` AS `product_id`, `p`.`product_title` AS `product_title`, `i`.`StockLevel` AS `StockLevel` FROM (`products` `p` join `inventory` `i` on(`p`.`product_id` = `i`.`product_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `order_summary`
--
DROP TABLE IF EXISTS `order_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `order_summary`  AS SELECT `o`.`order_id` AS `order_id`, `o`.`user_id` AS `user_id`, `o`.`product_id` AS `product_id`, `p`.`product_title` AS `product_title`, `o`.`qty` AS `order_quantity`, `p`.`product_price` AS `product_price`, `o`.`qty`* `p`.`product_price` AS `total_price` FROM (`orders` `o` join `products` `p` on(`o`.`product_id` = `p`.`product_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `products_sold`
--
DROP TABLE IF EXISTS `products_sold`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `products_sold`  AS SELECT `o`.`product_id` AS `product_id`, `p`.`product_title` AS `product_title`, sum(`o`.`qty`) AS `total_sold` FROM (`orders` `o` join `products` `p` on(`o`.`product_id` = `p`.`product_id`)) GROUP BY `o`.`product_id` ;

-- --------------------------------------------------------

--
-- Structure for view `product_details_with_stock`
--
DROP TABLE IF EXISTS `product_details_with_stock`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `product_details_with_stock`  AS SELECT `p`.`product_id` AS `product_id`, `p`.`product_cat` AS `product_cat`, `p`.`product_brand` AS `product_brand`, `p`.`product_title` AS `product_title`, `p`.`product_price` AS `product_price`, `p`.`product_qty` AS `product_qty`, `i`.`StockLevel` AS `StockLevel` FROM (`products` `p` join `inventory` `i` on(`p`.`product_id` = `i`.`product_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `user_order_history`
--
DROP TABLE IF EXISTS `user_order_history`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `user_order_history`  AS SELECT `o`.`order_id` AS `order_id`, `o`.`user_id` AS `user_id`, `o`.`product_id` AS `product_id`, `p`.`product_title` AS `product_title`, `o`.`qty` AS `order_quantity`, `p`.`product_price` AS `product_price`, `o`.`qty`* `p`.`product_price` AS `total_price`, `o`.`trx_id` AS `trx_id` FROM (`orders` `o` join `products` `p` on(`o`.`product_id` = `p`.`product_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `user_purchase_history`
--
DROP TABLE IF EXISTS `user_purchase_history`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `user_purchase_history`  AS SELECT `ph`.`history_id` AS `history_id`, `ph`.`order_id` AS `order_id`, `o`.`user_id` AS `user_id`, `o`.`product_id` AS `product_id`, `p`.`product_title` AS `product_title`, `o`.`qty` AS `order_quantity`, `o`.`trx_id` AS `trx_id` FROM ((`purchase_history` `ph` join `orders` `o` on(`ph`.`order_id` = `o`.`order_id`)) join `products` `p` on(`o`.`product_id` = `p`.`product_id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`brand_id`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`cat_id`);

--
-- Indexes for table `customer_feedback`
--
ALTER TABLE `customer_feedback`
  ADD PRIMARY KEY (`FeedbackID`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `discounts`
--
ALTER TABLE `discounts`
  ADD PRIMARY KEY (`DiscountID`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `exchange`
--
ALTER TABLE `exchange`
  ADD PRIMARY KEY (`exchange_id`),
  ADD UNIQUE KEY `order_id` (`order_id`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`InventoryID`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`NotificationID`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`product_id`,`trx_id`);

--
-- Indexes for table `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`OrderDetailID`),
  ADD UNIQUE KEY `order_id` (`order_id`,`product_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD UNIQUE KEY `order_id` (`order_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `fk_product_cat` (`product_cat`),
  ADD KEY `fk_product_brand` (`product_brand`);

--
-- Indexes for table `purchase_history`
--
ALTER TABLE `purchase_history`
  ADD PRIMARY KEY (`history_id`),
  ADD UNIQUE KEY `order_id` (`order_id`);

--
-- Indexes for table `returns_product`
--
ALTER TABLE `returns_product`
  ADD PRIMARY KEY (`return_id`),
  ADD UNIQUE KEY `order_id` (`order_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`product_id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`SupplierID`);

--
-- Indexes for table `userprofiles`
--
ALTER TABLE `userprofiles`
  ADD PRIMARY KEY (`profile_id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD UNIQUE KEY `purchase_history_id` (`purchase_history_id`);

--
-- Indexes for table `user_info`
--
ALTER TABLE `user_info`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `brands`
--
ALTER TABLE `brands`
  MODIFY `brand_id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=126;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `cat_id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `InventoryID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=97;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `purchase_history`
--
ALTER TABLE `purchase_history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `user_info`
--
ALTER TABLE `user_info`
  MODIFY `user_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `inventory`
--
ALTER TABLE `inventory`
  ADD CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_product_brand` FOREIGN KEY (`product_brand`) REFERENCES `brands` (`brand_id`),
  ADD CONSTRAINT `fk_product_cat` FOREIGN KEY (`product_cat`) REFERENCES `categories` (`cat_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
