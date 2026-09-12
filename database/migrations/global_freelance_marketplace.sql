/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 100411 (10.4.11-MariaDB)
 Source Host           : localhost:3306
 Source Schema         : global_freelance_marketplace

 Target Server Type    : MySQL
 Target Server Version : 100411 (10.4.11-MariaDB)
 File Encoding         : 65001

 Date: 25/08/2026 00:58:06
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for audit_logs
-- ----------------------------
DROP TABLE IF EXISTS `audit_logs`;
CREATE TABLE `audit_logs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NULL DEFAULT NULL,
  `action` varchar(120) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `entity_type` varchar(80) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `entity_id` bigint UNSIGNED NULL DEFAULT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `user_agent` varchar(255) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_audit_logs_action`(`action` ASC) USING BTREE,
  INDEX `idx_audit_logs_entity`(`entity_type` ASC, `entity_id` ASC) USING BTREE,
  CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of audit_logs
-- ----------------------------

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(120) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `slug` varchar(140) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_persian_ci NULL,
  `icon` varchar(80) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `parent_id` bigint UNSIGNED NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `slug`(`slug` ASC) USING BTREE,
  INDEX `parent_id`(`parent_id` ASC) USING BTREE,
  CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of categories
-- ----------------------------

-- ----------------------------
-- Table structure for certifications
-- ----------------------------
DROP TABLE IF EXISTS `certifications`;
CREATE TABLE `certifications`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `issuing_organization` varchar(200) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `issue_date` date NULL DEFAULT NULL,
  `expiry_date` date NULL DEFAULT NULL,
  `credential_id` varchar(160) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `credential_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_persian_ci NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `certifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of certifications
-- ----------------------------

-- ----------------------------
-- Table structure for contracts
-- ----------------------------
DROP TABLE IF EXISTS `contracts`;
CREATE TABLE `contracts`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `job_id` bigint UNSIGNED NOT NULL,
  `employer_id` bigint UNSIGNED NOT NULL,
  `freelancer_id` bigint UNSIGNED NOT NULL,
  `status` enum('pending','active','completed','cancelled','disputed') CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT 'pending',
  `total_amount` decimal(12, 2) NOT NULL,
  `payment_type` enum('fixed','hourly') CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT 'fixed',
  `start_date` date NULL DEFAULT NULL,
  `end_date` date NULL DEFAULT NULL,
  `terms` text CHARACTER SET utf8 COLLATE utf8_persian_ci NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `job_id`(`job_id` ASC) USING BTREE,
  INDEX `employer_id`(`employer_id` ASC) USING BTREE,
  INDEX `freelancer_id`(`freelancer_id` ASC) USING BTREE,
  INDEX `idx_contracts_status`(`status` ASC) USING BTREE,
  CONSTRAINT `contracts_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `contracts_ibfk_2` FOREIGN KEY (`employer_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `contracts_ibfk_3` FOREIGN KEY (`freelancer_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of contracts
-- ----------------------------

-- ----------------------------
-- Table structure for educations
-- ----------------------------
DROP TABLE IF EXISTS `educations`;
CREATE TABLE `educations`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `institution` varchar(200) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `degree` varchar(160) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `field_of_study` varchar(160) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `start_date` date NULL DEFAULT NULL,
  `end_date` date NULL DEFAULT NULL,
  `grade` varchar(20) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_persian_ci NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `educations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of educations
-- ----------------------------

-- ----------------------------
-- Table structure for employer_profiles
-- ----------------------------
DROP TABLE IF EXISTS `employer_profiles`;
CREATE TABLE `employer_profiles`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `company_name` varchar(160) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `company_logo` varchar(255) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `company_website` varchar(255) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `industry` varchar(120) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `company_size` enum('1-10','11-50','51-200','201-500','500+') CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `company_description` text CHARACTER SET utf8 COLLATE utf8_persian_ci NULL,
  `verification_status` enum('unverified','pending','verified') CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT 'unverified',
  `total_jobs_posted` int UNSIGNED NULL DEFAULT 0,
  `total_hired` int UNSIGNED NULL DEFAULT 0,
  `total_spent` decimal(12, 2) NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_employer_industry`(`industry` ASC) USING BTREE,
  CONSTRAINT `employer_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of employer_profiles
-- ----------------------------

-- ----------------------------
-- Table structure for freelancer_profiles
-- ----------------------------
DROP TABLE IF EXISTS `freelancer_profiles`;
CREATE TABLE `freelancer_profiles`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `professional_title` varchar(180) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `years_of_experience` tinyint UNSIGNED NULL DEFAULT 0,
  `languages` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `education_level` varchar(120) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `verification_status` enum('unverified','pending','verified') CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT 'unverified',
  `skill_verified` tinyint(1) NULL DEFAULT 0,
  `identity_verified` tinyint(1) NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_freelancer_experience`(`years_of_experience` ASC) USING BTREE,
  CONSTRAINT `freelancer_profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of freelancer_profiles
-- ----------------------------

-- ----------------------------
-- Table structure for job_invitations
-- ----------------------------
DROP TABLE IF EXISTS `job_invitations`;
CREATE TABLE `job_invitations`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `job_id` bigint UNSIGNED NOT NULL,
  `employer_id` bigint UNSIGNED NOT NULL,
  `freelancer_id` bigint UNSIGNED NOT NULL,
  `message` text CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `proposed_amount` decimal(12, 2) NOT NULL,
  `status` enum('pending','accepted','declined','expired') CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL DEFAULT 'pending',
  `responded_at` datetime NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_invitation`(`job_id` ASC, `freelancer_id` ASC) USING BTREE,
  INDEX `employer_id`(`employer_id` ASC) USING BTREE,
  INDEX `freelancer_id`(`freelancer_id` ASC) USING BTREE,
  INDEX `idx_invitations_status`(`status` ASC) USING BTREE,
  CONSTRAINT `job_invitations_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `job_invitations_ibfk_2` FOREIGN KEY (`employer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `job_invitations_ibfk_3` FOREIGN KEY (`freelancer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of job_invitations
-- ----------------------------

-- ----------------------------
-- Table structure for job_skills
-- ----------------------------
DROP TABLE IF EXISTS `job_skills`;
CREATE TABLE `job_skills`  (
  `job_id` bigint UNSIGNED NOT NULL,
  `skill_id` bigint UNSIGNED NOT NULL,
  PRIMARY KEY (`job_id`, `skill_id`) USING BTREE,
  INDEX `skill_id`(`skill_id` ASC) USING BTREE,
  CONSTRAINT `job_skills_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `job_skills_ibfk_2` FOREIGN KEY (`skill_id`) REFERENCES `skills` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of job_skills
-- ----------------------------

-- ----------------------------
-- Table structure for jobs
-- ----------------------------
DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `employer_id` bigint UNSIGNED NOT NULL,
  `title` varchar(180) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `slug` varchar(220) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `budget_min` decimal(12, 2) NULL DEFAULT NULL,
  `budget_max` decimal(12, 2) NULL DEFAULT NULL,
  `payment_type` enum('fixed','hourly') CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT 'fixed',
  `project_duration` enum('less_than_1_month','1_to_3_months','3_to_6_months','more_than_6_months') CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `experience_level` enum('entry','intermediate','expert') CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT 'intermediate',
  `category_id` bigint UNSIGNED NULL DEFAULT NULL,
  `status` enum('draft','open','in_progress','completed','cancelled') CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT 'draft',
  `proposal_count` int UNSIGNED NULL DEFAULT 0,
  `deadline` date NULL DEFAULT NULL,
  `is_featured` tinyint(1) NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `slug`(`slug` ASC) USING BTREE,
  INDEX `employer_id`(`employer_id` ASC) USING BTREE,
  INDEX `category_id`(`category_id` ASC) USING BTREE,
  INDEX `idx_jobs_status`(`status` ASC) USING BTREE,
  INDEX `idx_jobs_budget`(`budget_min` ASC, `budget_max` ASC) USING BTREE,
  INDEX `idx_jobs_featured`(`is_featured` ASC) USING BTREE,
  CONSTRAINT `jobs_ibfk_1` FOREIGN KEY (`employer_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `jobs_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of jobs
-- ----------------------------
INSERT INTO `jobs` VALUES (1, 3, 'طراحی سایت برای پزشکان', '-beb038', 'این یک سایت برای پزشکان کشور است', 300.00, 1000.00, 'fixed', NULL, 'intermediate', NULL, 'open', 0, NULL, 0, '2026-08-25 00:38:31', '2026-08-25 00:38:31');

-- ----------------------------
-- Table structure for languages
-- ----------------------------
DROP TABLE IF EXISTS `languages`;
CREATE TABLE `languages`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(80) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `code` varchar(10) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of languages
-- ----------------------------

-- ----------------------------
-- Table structure for messages
-- ----------------------------
DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `sender_id` bigint UNSIGNED NOT NULL,
  `receiver_id` bigint UNSIGNED NOT NULL,
  `job_id` bigint UNSIGNED NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `is_read` tinyint(1) NULL DEFAULT 0,
  `read_at` datetime NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sender_id`(`sender_id` ASC) USING BTREE,
  INDEX `receiver_id`(`receiver_id` ASC) USING BTREE,
  INDEX `job_id`(`job_id` ASC) USING BTREE,
  INDEX `idx_messages_read`(`is_read` ASC) USING BTREE,
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `messages_ibfk_3` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of messages
-- ----------------------------

-- ----------------------------
-- Table structure for milestones
-- ----------------------------
DROP TABLE IF EXISTS `milestones`;
CREATE TABLE `milestones`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `contract_id` bigint UNSIGNED NOT NULL,
  `title` varchar(180) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_persian_ci NULL,
  `amount` decimal(12, 2) NOT NULL,
  `due_date` date NULL DEFAULT NULL,
  `status` enum('pending','funded','submitted','revision','approved','released') CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT 'pending',
  `sort_order` int UNSIGNED NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `contract_id`(`contract_id` ASC) USING BTREE,
  INDEX `idx_milestones_status`(`status` ASC) USING BTREE,
  CONSTRAINT `milestones_ibfk_1` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of milestones
-- ----------------------------

-- ----------------------------
-- Table structure for notifications
-- ----------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `type` varchar(80) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `title` varchar(180) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `body` text CHARACTER SET utf8 COLLATE utf8_persian_ci NULL,
  `link` varchar(255) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `read_at` datetime NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_notifications_read`(`read_at` ASC) USING BTREE,
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notifications
-- ----------------------------

-- ----------------------------
-- Table structure for portfolio_images
-- ----------------------------
DROP TABLE IF EXISTS `portfolio_images`;
CREATE TABLE `portfolio_images`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `portfolio_id` bigint UNSIGNED NOT NULL,
  `image_path` varchar(255) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `thumbnail_path` varchar(255) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `alt_text` varchar(200) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `sort_order` int UNSIGNED NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `portfolio_id`(`portfolio_id` ASC) USING BTREE,
  CONSTRAINT `portfolio_images_ibfk_1` FOREIGN KEY (`portfolio_id`) REFERENCES `portfolios` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of portfolio_images
-- ----------------------------

-- ----------------------------
-- Table structure for portfolios
-- ----------------------------
DROP TABLE IF EXISTS `portfolios`;
CREATE TABLE `portfolios`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `title` varchar(200) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `slug` varchar(220) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_persian_ci NULL,
  `project_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `github_url` varchar(255) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `category_id` bigint UNSIGNED NULL DEFAULT NULL,
  `client_name` varchar(160) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `project_date` date NULL DEFAULT NULL,
  `technologies` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `project_result` text CHARACTER SET utf8 COLLATE utf8_persian_ci NULL,
  `sort_order` int UNSIGNED NULL DEFAULT 0,
  `is_featured` tinyint(1) NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `slug`(`slug` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `category_id`(`category_id` ASC) USING BTREE,
  INDEX `idx_portfolios_featured`(`is_featured` ASC) USING BTREE,
  CONSTRAINT `portfolios_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `portfolios_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of portfolios
-- ----------------------------

-- ----------------------------
-- Table structure for profiles
-- ----------------------------
DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `username` varchar(80) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `display_name` varchar(160) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `headline` varchar(180) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `bio` text CHARACTER SET utf8 COLLATE utf8_persian_ci NULL,
  `avatar_path` varchar(255) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `cover_path` varchar(255) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `location` varchar(120) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `timezone` varchar(64) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT 'UTC',
  `hourly_rate` decimal(10, 2) NULL DEFAULT NULL,
  `availability` enum('available','busy','unavailable') CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT 'available',
  `website` varchar(255) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `total_experience_years` tinyint UNSIGNED NULL DEFAULT 0,
  `completed_projects` int UNSIGNED NULL DEFAULT 0,
  `response_time` varchar(40) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `response_rate` tinyint UNSIGNED NULL DEFAULT 100,
  `rating` decimal(3, 2) NULL DEFAULT 0.00,
  `reviews_count` int UNSIGNED NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  INDEX `idx_profiles_availability`(`availability` ASC) USING BTREE,
  INDEX `idx_profiles_hourly_rate`(`hourly_rate` ASC) USING BTREE,
  CONSTRAINT `profiles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of profiles
-- ----------------------------
INSERT INTO `profiles` VALUES (1, 3, 'demo-employer', 'کارفرما شرکت ایده بان الماس', 'مدیریت پروژه و استخدام متخصص', 'ما به دنبال همکاری با متخصصان خلاق و حرفه‌ای هستیم.', NULL, NULL, NULL, 'UTC', NULL, 'available', NULL, 0, 0, NULL, 100, 0.00, 0, '2026-08-24 23:45:50', '2026-08-25 00:37:39');

-- ----------------------------
-- Table structure for proposal_messages
-- ----------------------------
DROP TABLE IF EXISTS `proposal_messages`;
CREATE TABLE `proposal_messages`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `proposal_id` bigint UNSIGNED NOT NULL,
  `sender_id` bigint UNSIGNED NOT NULL,
  `body` text CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sender_id`(`sender_id` ASC) USING BTREE,
  INDEX `idx_proposal_messages_proposal`(`proposal_id` ASC, `created_at` ASC) USING BTREE,
  CONSTRAINT `proposal_messages_ibfk_1` FOREIGN KEY (`proposal_id`) REFERENCES `proposals` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `proposal_messages_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of proposal_messages
-- ----------------------------

-- ----------------------------
-- Table structure for proposals
-- ----------------------------
DROP TABLE IF EXISTS `proposals`;
CREATE TABLE `proposals`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `job_id` bigint UNSIGNED NOT NULL,
  `freelancer_id` bigint UNSIGNED NOT NULL,
  `cover_letter` text CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `bid_amount` decimal(12, 2) NOT NULL,
  `estimated_duration` varchar(80) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `status` enum('pending','accepted','rejected','withdrawn','shortlisted') CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_proposal`(`job_id` ASC, `freelancer_id` ASC) USING BTREE,
  INDEX `freelancer_id`(`freelancer_id` ASC) USING BTREE,
  INDEX `idx_proposals_status`(`status` ASC) USING BTREE,
  CONSTRAINT `proposals_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `proposals_ibfk_2` FOREIGN KEY (`freelancer_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of proposals
-- ----------------------------
INSERT INTO `proposals` VALUES (1, 1, 1, 'من همه زبان ها را بلدم', 600.00, NULL, 'pending', '2026-08-25 00:40:23', '2026-08-25 00:40:23');

-- ----------------------------
-- Table structure for reviews
-- ----------------------------
DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `contract_id` bigint UNSIGNED NOT NULL,
  `reviewer_id` bigint UNSIGNED NOT NULL,
  `reviewee_id` bigint UNSIGNED NOT NULL,
  `rating` tinyint UNSIGNED NOT NULL,
  `communication_rating` tinyint UNSIGNED NULL DEFAULT NULL,
  `quality_rating` tinyint UNSIGNED NULL DEFAULT NULL,
  `professionalism_rating` tinyint UNSIGNED NULL DEFAULT NULL,
  `deadline_rating` tinyint UNSIGNED NULL DEFAULT NULL,
  `comment` text CHARACTER SET utf8 COLLATE utf8_persian_ci NULL,
  `is_public` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_review`(`contract_id` ASC, `reviewer_id` ASC) USING BTREE,
  INDEX `reviewee_id`(`reviewee_id` ASC) USING BTREE,
  INDEX `idx_reviews_rating`(`rating` ASC) USING BTREE,
  INDEX `reviews_ibfk_2`(`reviewer_id` ASC) USING BTREE,
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`reviewer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`reviewee_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `reviews_chk_rating` CHECK (`rating` >= 1 and `rating` <= 5)
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of reviews
-- ----------------------------

-- ----------------------------
-- Table structure for skills
-- ----------------------------
DROP TABLE IF EXISTS `skills`;
CREATE TABLE `skills`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `slug` varchar(120) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `category_id` bigint UNSIGNED NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_persian_ci NULL,
  `icon` varchar(80) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE,
  UNIQUE INDEX `slug`(`slug` ASC) USING BTREE,
  INDEX `category_id`(`category_id` ASC) USING BTREE,
  CONSTRAINT `skills_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of skills
-- ----------------------------
INSERT INTO `skills` VALUES (1, 'طراحی رابط کاربری', 'ui-design', NULL, NULL, NULL, '2026-08-24 23:49:34');
INSERT INTO `skills` VALUES (2, 'توسعه PHP', 'php-development', NULL, NULL, NULL, '2026-08-24 23:49:34');
INSERT INTO `skills` VALUES (3, 'توسعه JavaScript', 'javascript-development', NULL, NULL, NULL, '2026-08-24 23:49:34');
INSERT INTO `skills` VALUES (4, 'تولید محتوا', 'content-writing', NULL, NULL, NULL, '2026-08-24 23:49:34');
INSERT INTO `skills` VALUES (5, 'بازاریابی دیجیتال', 'digital-marketing', NULL, NULL, NULL, '2026-08-24 23:49:34');

-- ----------------------------
-- Table structure for transactions
-- ----------------------------
DROP TABLE IF EXISTS `transactions`;
CREATE TABLE `transactions`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `wallet_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `type` enum('deposit','payment','refund','withdrawal','fee','adjustment') CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `amount` decimal(12, 2) NOT NULL,
  `currency` varchar(3) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL DEFAULT 'USD',
  `status` enum('pending','completed','failed','cancelled') CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL DEFAULT 'pending',
  `provider` varchar(50) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `provider_reference` varchar(160) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `contract_id` bigint UNSIGNED NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8 COLLATE utf8_persian_ci NULL,
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `wallet_id`(`wallet_id` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `contract_id`(`contract_id` ASC) USING BTREE,
  INDEX `idx_transactions_type`(`type` ASC) USING BTREE,
  INDEX `idx_transactions_status`(`status` ASC) USING BTREE,
  CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`wallet_id`) REFERENCES `wallets` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `transactions_ibfk_3` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of transactions
-- ----------------------------

-- ----------------------------
-- Table structure for user_languages
-- ----------------------------
DROP TABLE IF EXISTS `user_languages`;
CREATE TABLE `user_languages`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `language_id` bigint UNSIGNED NOT NULL,
  `proficiency` enum('basic','conversational','fluent','native') CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL DEFAULT 'conversational',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_user_language`(`user_id` ASC, `language_id` ASC) USING BTREE,
  INDEX `language_id`(`language_id` ASC) USING BTREE,
  CONSTRAINT `user_languages_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `user_languages_ibfk_2` FOREIGN KEY (`language_id`) REFERENCES `languages` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_languages
-- ----------------------------

-- ----------------------------
-- Table structure for user_skills
-- ----------------------------
DROP TABLE IF EXISTS `user_skills`;
CREATE TABLE `user_skills`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `skill_id` bigint UNSIGNED NOT NULL,
  `level` enum('beginner','intermediate','advanced','expert') CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL DEFAULT 'intermediate',
  `years_experience` tinyint UNSIGNED NULL DEFAULT 0,
  `is_verified` tinyint(1) NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_user_skill`(`user_id` ASC, `skill_id` ASC) USING BTREE,
  INDEX `skill_id`(`skill_id` ASC) USING BTREE,
  INDEX `idx_user_skills_level`(`level` ASC) USING BTREE,
  CONSTRAINT `user_skills_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `user_skills_ibfk_2` FOREIGN KEY (`skill_id`) REFERENCES `skills` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_skills
-- ----------------------------

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` varchar(190) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `role` enum('freelancer','employer','admin') CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `country` varchar(100) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `email_verified_at` datetime NULL DEFAULT NULL,
  `two_factor_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `status` enum('active','suspended','pending') CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE,
  INDEX `idx_users_role_status`(`role` ASC, `status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'mrtz8bgy@gmail.com', '$2y$10$y75VHB/Db0eiFciVFC6c5..yu8nVuwUIhQyTb1B7siewGQZ.dWCni', 'freelancer', 'ایران', '2026-08-24 23:26:58', 0, 'active', '2026-08-24 23:15:57', '2026-08-24 23:26:58');
INSERT INTO `users` VALUES (2, 'admin@example.com', '$2y$10$bLibn140tARjEIyQ705tLOh8Tmshg7lT.0dno9XjM1pRq9GP9h2li', 'admin', 'Global', '2026-08-24 23:25:04', 0, 'active', '2026-08-24 23:25:04', '2026-08-24 23:25:04');
INSERT INTO `users` VALUES (3, 'employer@example.com', '$2y$10$iyyb20Wt3DLhKG7i8BCeWexwyvK/HtLpW7rgjpezc5TTOCMlWBib6', 'employer', 'ایران', '2026-08-24 23:45:50', 0, 'active', '2026-08-24 23:45:50', '2026-08-24 23:45:50');

-- ----------------------------
-- Table structure for wallets
-- ----------------------------
DROP TABLE IF EXISTS `wallets`;
CREATE TABLE `wallets`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `balance` decimal(12, 2) NOT NULL DEFAULT 0.00,
  `currency` varchar(3) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL DEFAULT 'USD',
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_wallets_currency`(`currency` ASC) USING BTREE,
  CONSTRAINT `wallets_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of wallets
-- ----------------------------

-- ----------------------------
-- Table structure for work_experiences
-- ----------------------------
DROP TABLE IF EXISTS `work_experiences`;
CREATE TABLE `work_experiences`  (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `company_name` varchar(160) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `job_title` varchar(160) CHARACTER SET utf8 COLLATE utf8_persian_ci NOT NULL,
  `start_date` date NULL DEFAULT NULL,
  `end_date` date NULL DEFAULT NULL,
  `is_current` tinyint(1) NULL DEFAULT 0,
  `description` text CHARACTER SET utf8 COLLATE utf8_persian_ci NULL,
  `location` varchar(120) CHARACTER SET utf8 COLLATE utf8_persian_ci NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_work_experiences_dates`(`start_date` ASC, `end_date` ASC) USING BTREE,
  CONSTRAINT `work_experiences_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_persian_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of work_experiences
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
