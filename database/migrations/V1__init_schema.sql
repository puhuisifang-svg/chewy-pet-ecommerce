-- Chewy Pet E-commerce Schema V1
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS `users` (
  `id`           BIGINT PRIMARY KEY AUTO_INCREMENT,
  `email`        VARCHAR(100) UNIQUE NOT NULL,
  `password`     VARCHAR(255) NOT NULL,
  `username`     VARCHAR(50) NOT NULL,
  `first_name`   VARCHAR(50),
  `last_name`    VARCHAR(50),
  `phone`        VARCHAR(20),
  `avatar`       VARCHAR(500),
  `status`       TINYINT DEFAULT 1,
  `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `user_addresses` (
  `id`           BIGINT PRIMARY KEY AUTO_INCREMENT,
  `user_id`      BIGINT NOT NULL,
  `full_name`    VARCHAR(100) NOT NULL,
  `phone`        VARCHAR(20),
  `address_line1` VARCHAR(200) NOT NULL,
  `address_line2` VARCHAR(200),
  `city`         VARCHAR(100) NOT NULL,
  `state`        VARCHAR(50) NOT NULL,
  `zip_code`     VARCHAR(20) NOT NULL,
  `country`      VARCHAR(50) DEFAULT 'US',
  `is_default`   TINYINT DEFAULT 0,
  `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `categories` (
  `id`           BIGINT PRIMARY KEY AUTO_INCREMENT,
  `name`         VARCHAR(100) NOT NULL,
  `parent_id`    BIGINT DEFAULT 0,
  `slug`         VARCHAR(100) UNIQUE,
  `image`        VARCHAR(500),
  `sort_order`   INT DEFAULT 0,
  `status`       TINYINT DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `products` (
  `id`           BIGINT PRIMARY KEY AUTO_INCREMENT,
  `category_id`  BIGINT NOT NULL,
  `sku`          VARCHAR(100) UNIQUE NOT NULL,
  `name`         VARCHAR(200) NOT NULL,
  `brand`        VARCHAR(100),
  `description`  TEXT,
  `price`        DECIMAL(10,2) NOT NULL,
  `sale_price`   DECIMAL(10,2),
  `stock`        INT DEFAULT 0,
  `weight`       DECIMAL(8,2),
  `images`       JSON,
  `tags`         JSON,
  `status`       TINYINT DEFAULT 1,
  `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `shopping_cart` (
  `id`           BIGINT PRIMARY KEY AUTO_INCREMENT,
  `user_id`      BIGINT NOT NULL,
  `product_id`   BIGINT NOT NULL,
  `quantity`     INT NOT NULL DEFAULT 1,
  `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `uk_user_product` (`user_id`, `product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `orders` (
  `id`           BIGINT PRIMARY KEY AUTO_INCREMENT,
  `order_no`     VARCHAR(50) UNIQUE NOT NULL,
  `user_id`      BIGINT NOT NULL,
  `total_amount` DECIMAL(10,2) NOT NULL,
  `discount_amount` DECIMAL(10,2) DEFAULT 0.00,
  `shipping_fee` DECIMAL(10,2) DEFAULT 0.00,
  `status`       VARCHAR(20) DEFAULT 'pending',
  `payment_method` VARCHAR(20),
  `payment_intent_id` VARCHAR(200),
  `shipping_address` JSON,
  `note`         VARCHAR(500),
  `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `order_items` (
  `id`           BIGINT PRIMARY KEY AUTO_INCREMENT,
  `order_id`     BIGINT NOT NULL,
  `product_id`   BIGINT NOT NULL,
  `product_name` VARCHAR(200) NOT NULL,
  `sku`          VARCHAR(100),
  `price`        DECIMAL(10,2) NOT NULL,
  `quantity`     INT NOT NULL,
  INDEX `idx_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `autoship_subscriptions` (
  `id`           BIGINT PRIMARY KEY AUTO_INCREMENT,
  `user_id`      BIGINT NOT NULL,
  `product_id`   BIGINT NOT NULL,
  `quantity`     INT NOT NULL DEFAULT 1,
  `frequency`    INT NOT NULL,
  `discount_rate` DECIMAL(4,2) DEFAULT 5.00,
  `status`       VARCHAR(20) DEFAULT 'active',
  `next_order_date` DATE NOT NULL,
  `last_order_date` DATE,
  `stripe_subscription_id` VARCHAR(200),
  `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_next_order_date` (`next_order_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET FOREIGN_KEY_CHECKS = 1;
