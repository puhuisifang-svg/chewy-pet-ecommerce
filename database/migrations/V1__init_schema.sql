-- Chewy Pet E-commerce Schema V1
-- Sprint 0 初始化 | 北美宠物用品独立站 MVP
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- 用户表
-- ============================================================
CREATE TABLE IF NOT EXISTS `users` (
  `id`           BIGINT PRIMARY KEY AUTO_INCREMENT,
  `email`        VARCHAR(100) UNIQUE NOT NULL     COMMENT '登录邮箱',
  `password`     VARCHAR(255) NOT NULL             COMMENT 'BCrypt 加密密码',
  `username`     VARCHAR(50) NOT NULL              COMMENT '用户名',
  `first_name`   VARCHAR(50)                       COMMENT '名',
  `last_name`    VARCHAR(50)                       COMMENT '姓',
  `phone`        VARCHAR(20)                       COMMENT '手机号',
  `avatar`       VARCHAR(500)                      COMMENT '头像URL',
  `status`       TINYINT DEFAULT 1                 COMMENT '1=正常 0=禁用',
  `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ============================================================
-- 用户地址表
-- ============================================================
CREATE TABLE IF NOT EXISTS `user_addresses` (
  `id`            BIGINT PRIMARY KEY AUTO_INCREMENT,
  `user_id`       BIGINT NOT NULL,
  `full_name`     VARCHAR(100) NOT NULL,
  `phone`         VARCHAR(20),
  `address_line1` VARCHAR(200) NOT NULL,
  `address_line2` VARCHAR(200),
  `city`          VARCHAR(100) NOT NULL,
  `state`         VARCHAR(50) NOT NULL              COMMENT '州',
  `zip_code`      VARCHAR(20) NOT NULL,
  `country`       VARCHAR(50) DEFAULT 'US',
  `is_default`    TINYINT DEFAULT 0,
  `created_at`    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户收货地址';

-- ============================================================
-- 商品分类表
-- ============================================================
CREATE TABLE IF NOT EXISTS `categories` (
  `id`          BIGINT PRIMARY KEY AUTO_INCREMENT,
  `name`        VARCHAR(100) NOT NULL,
  `parent_id`   BIGINT DEFAULT 0,
  `slug`        VARCHAR(100) UNIQUE               COMMENT 'URL友好名称',
  `image`       VARCHAR(500),
  `sort_order`  INT DEFAULT 0,
  `status`      TINYINT DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品分类';

-- ============================================================
-- 商品表
-- ============================================================
CREATE TABLE IF NOT EXISTS `products` (
  `id`           BIGINT PRIMARY KEY AUTO_INCREMENT,
  `category_id`  BIGINT NOT NULL,
  `spu_code`     VARCHAR(100) UNIQUE NOT NULL      COMMENT 'SPU 编码',
  `name`         VARCHAR(200) NOT NULL,
  `brand`        VARCHAR(100)                      COMMENT '品牌',
  `description`  TEXT,
  `price`        DECIMAL(10,2) NOT NULL             COMMENT '基准价（含税）',
  `sale_price`   DECIMAL(10,2)                     COMMENT '促销价',
  `images`       JSON                              COMMENT '商品图片列表',
  `tags`         JSON                              COMMENT '标签（如 dog, cat, flea）',
  `autoship_eligible` TINYINT DEFAULT 1            COMMENT '是否支持AutoShip',
  `status`       TINYINT DEFAULT 1,
  `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_category_id` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品SPU';

-- ============================================================
-- 商品 SKU 表（新增）
-- MVP: 100+ SKU，按规格（尺寸/口味/包装）区分
-- ============================================================
CREATE TABLE IF NOT EXISTS `product_skus` (
  `id`           BIGINT PRIMARY KEY AUTO_INCREMENT,
  `product_id`   BIGINT NOT NULL                   COMMENT '关联SPU',
  `sku_code`     VARCHAR(100) UNIQUE NOT NULL       COMMENT 'SKU编码（如 FLEA-M-3PACK）',
  `spec_name`    VARCHAR(200)                       COMMENT '规格描述（如 Medium / 3-pack）',
  `price`        DECIMAL(10,2) NOT NULL             COMMENT 'SKU单独定价',
  `sale_price`   DECIMAL(10,2)                     COMMENT 'SKU促销价',
  `stock`        INT DEFAULT 0                     COMMENT '库存数量',
  `weight_lbs`   DECIMAL(8,2)                      COMMENT '重量(lbs)，用于物流计费',
  `barcode`      VARCHAR(50)                       COMMENT 'UPC/EAN条码',
  `image`        VARCHAR(500)                      COMMENT 'SKU独立图',
  `status`       TINYINT DEFAULT 1                 COMMENT '1=上架 0=下架',
  `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_product_id` (`product_id`),
  INDEX `idx_sku_code` (`sku_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品SKU';

-- ============================================================
-- 购物车明细表（新增，替代 shopping_cart）
-- ============================================================
CREATE TABLE IF NOT EXISTS `cart_items` (
  `id`           BIGINT PRIMARY KEY AUTO_INCREMENT,
  `user_id`      BIGINT NOT NULL,
  `sku_id`       BIGINT NOT NULL                   COMMENT '关联SKU',
  `product_id`   BIGINT NOT NULL                   COMMENT '冗余SPU，方便查询',
  `quantity`     INT NOT NULL DEFAULT 1,
  `is_autoship`  TINYINT DEFAULT 0                 COMMENT '是否加入AutoShip',
  `created_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at`   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY `uk_user_sku` (`user_id`, `sku_id`),
  INDEX `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车明细（关联SKU）';

-- ============================================================
-- 订单表
-- ============================================================
CREATE TABLE IF NOT EXISTS `orders` (
  `id`                  BIGINT PRIMARY KEY AUTO_INCREMENT,
  `order_no`            VARCHAR(50) UNIQUE NOT NULL   COMMENT '订单号（前缀CP+时间戳）',
  `user_id`             BIGINT NOT NULL,
  `subtotal`            DECIMAL(10,2) NOT NULL         COMMENT '商品小计',
  `discount_amount`     DECIMAL(10,2) DEFAULT 0.00,
  `shipping_fee`        DECIMAL(10,2) DEFAULT 0.00,
  `tax_amount`          DECIMAL(10,2) DEFAULT 0.00     COMMENT '销售税（美国各州不同）',
  `total_amount`        DECIMAL(10,2) NOT NULL,
  `status`              VARCHAR(20) DEFAULT 'pending'  COMMENT 'pending/paid/processing/shipped/delivered/cancelled/refunded',
  `fulfillment_type`    VARCHAR(20) DEFAULT 'overseas_warehouse' COMMENT 'overseas_warehouse/fba',
  `payment_method`      VARCHAR(20)                   COMMENT 'stripe/paypal',
  `payment_intent_id`   VARCHAR(200)                  COMMENT 'Stripe PaymentIntent ID',
  `shipping_address`    JSON                          COMMENT '收货地址快照',
  `tracking_number`     VARCHAR(100)                  COMMENT '物流单号',
  `carrier`             VARCHAR(50)                   COMMENT '承运商（如 UPS/FedEx）',
  `note`                VARCHAR(500),
  `created_at`          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at`          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_status` (`status`),
  INDEX `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- ============================================================
-- 订单明细表
-- ============================================================
CREATE TABLE IF NOT EXISTS `order_items` (
  `id`           BIGINT PRIMARY KEY AUTO_INCREMENT,
  `order_id`     BIGINT NOT NULL,
  `product_id`   BIGINT NOT NULL,
  `sku_id`       BIGINT NOT NULL                   COMMENT '关联SKU',
  `product_name` VARCHAR(200) NOT NULL              COMMENT '下单时商品名快照',
  `sku_code`     VARCHAR(100)                      COMMENT '下单时SKU编码快照',
  `spec_name`    VARCHAR(200)                      COMMENT '规格快照',
  `price`        DECIMAL(10,2) NOT NULL             COMMENT '下单时单价快照',
  `quantity`     INT NOT NULL,
  `subtotal`     DECIMAL(10,2) NOT NULL             COMMENT '行小计',
  INDEX `idx_order_id` (`order_id`),
  INDEX `idx_sku_id` (`sku_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单明细';

-- ============================================================
-- AutoShip 订阅表（Chewy 核心功能）
-- ============================================================
CREATE TABLE IF NOT EXISTS `autoship_subscriptions` (
  `id`                     BIGINT PRIMARY KEY AUTO_INCREMENT,
  `user_id`                BIGINT NOT NULL,
  `sku_id`                 BIGINT NOT NULL,
  `product_id`             BIGINT NOT NULL,
  `quantity`               INT NOT NULL DEFAULT 1,
  `frequency_days`         INT NOT NULL               COMMENT '周期天数: 7/14/30/60/90',
  `discount_rate`          DECIMAL(4,2) DEFAULT 5.00  COMMENT 'AutoShip折扣%',
  `status`                 VARCHAR(20) DEFAULT 'active' COMMENT 'active/paused/cancelled',
  `next_order_date`        DATE NOT NULL,
  `last_order_date`        DATE,
  `stripe_subscription_id` VARCHAR(200),
  `created_at`             TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at`             TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_user_id` (`user_id`),
  INDEX `idx_next_order_date` (`next_order_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='AutoShip自动订阅';

SET FOREIGN_KEY_CHECKS = 1;
