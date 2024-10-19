-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 19, 2024 at 11:54 PM
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
-- Database: `weamdarawsheh`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteSupplyDocument` (IN `s_id` INT)   BEGIN
    -- Delete the item with the specified ID
    DELETE FROM `supplydocuments`
    WHERE `ID` = `s_id`;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteWarehouse` (IN `w_warehouseIDs` VARCHAR(255))   BEGIN

    DELETE FROM `wearhouses`
    WHERE FIND_IN_SET(`ID`, w_warehouseIDs);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertItem` (IN `i_name` VARCHAR(255), IN `i_description` VARCHAR(255), IN `i_quantity` INT, IN `i_warehouseID` INT, OUT `i_id` INT)   BEGIN
    INSERT INTO `items` (`item_id`, `item_name`, `item_description`, `quantity`, `warehouse_id`)
    VALUES (NULL, `i_name`, `i_description`, `i_quantity`, `i_warehouseID`);
    SET `i_id` = LAST_INSERT_ID();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertSupplyDocument` (IN `s_name` VARCHAR(255), IN `s_subject` VARCHAR(255), IN `s_createdBy` INT, IN `s_itemID` INT, OUT `s_id` INT)   BEGIN
  
    INSERT INTO `supplydocuments` (`supply_document_id`, `document_name`, `document_subject`, `created_by`, `created_date`, `item_id`)
    VALUES (NULL, `s_name`, `s_subject`, `s_createdBy`, NOW(), `s_itemID`);

    
    SET `s_id` = LAST_INSERT_ID();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertWarehouse` (IN `w_name` VARCHAR(255), IN `w_description` VARCHAR(255), IN `w_createdBy` INT, OUT `w_id` INT)   BEGIN
    -- Insert the new warehouse record
    INSERT INTO `wearhouses` (`warehouse_id`, `warehouse_name`, `warehouse_description`, `created_by`, `created_date`)	
    VALUES (NULL,`w_name`, `w_description`, `w_createdBy`,NOW());

    SET `w_id` = LAST_INSERT_ID();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ReturnItems` (IN `i_WearhouseID` INT)   BEGIN
    SELECT * 
    FROM `items`
    WHERE
        (`i_WearhouseID` IS NULL OR`i_WearhouseID` = '' OR `WearhouseID` = i_WearhouseID);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ReturnSupplyDocuments` (IN `s_createdBy` VARCHAR(255))   BEGIN
    SELECT * 
    FROM `supplydocuments`
    WHERE
        (`s_createdBy` IS NULL OR `s_createdBy` = '' OR `CreatedBy` = s_createdBy);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ReturnWarehouses` (IN `w_id` INT(255), IN `w_createdBy` INT(255), IN `w_name` VARCHAR(255))   BEGIN
 
    SELECT * 
    FROM `wearhouses`
    WHERE
        ( `ID` = w_id OR w_id IS NULL  OR w_id = '') AND
        (`created_by` = w_createdBy OR w_createdBy IS NULL OR w_createdBy ='') AND
        (`name` = w_name OR w_name IS NULL OR w_name ='')
         ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UserLogin` (IN `u_username` VARCHAR(255), IN `u_password` VARCHAR(255))   BEGIN
    SELECT `user_id`, `full_name`, `user_type`
    FROM `users`
    WHERE `username` = u_username
    AND `password` = u_password;
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `item_id` int(11) NOT NULL,
  `item_name` varchar(100) NOT NULL,
  `item_description` text DEFAULT NULL,
  `quantity` int(11) NOT NULL CHECK (`quantity` >= 0),
  `warehouse_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `supplydocuments`
--

CREATE TABLE `supplydocuments` (
  `supply_document_id` int(11) NOT NULL,
  `document_name` varchar(100) NOT NULL,
  `document_subject` text DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `warehouse_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `status` enum('Pending','Approved','Declined') NOT NULL DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `user_type` enum('Manager','Employee') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `full_name`, `username`, `password`, `user_type`) VALUES
(1, 'Weam Darawsheh ', 'weam', 'We@m25', 'Manager'),
(2, 'Bader Darawsheh', 'bebo', '123', 'Employee');

-- --------------------------------------------------------

--
-- Table structure for table `warehouses`
--

CREATE TABLE `warehouses` (
  `warehouse_id` int(11) NOT NULL,
  `warehouse_name` varchar(100) NOT NULL,
  `warehouse_description` text DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `warehouse_id` (`warehouse_id`);

--
-- Indexes for table `supplydocuments`
--
ALTER TABLE `supplydocuments`
  ADD PRIMARY KEY (`supply_document_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `warehouse_id` (`warehouse_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `warehouses`
--
ALTER TABLE `warehouses`
  ADD PRIMARY KEY (`warehouse_id`),
  ADD UNIQUE KEY `warehouse_name` (`warehouse_name`),
  ADD KEY `created_by` (`created_by`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `supplydocuments`
--
ALTER TABLE `supplydocuments`
  MODIFY `supply_document_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `warehouses`
--
ALTER TABLE `warehouses`
  MODIFY `warehouse_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `items`
--
ALTER TABLE `items`
  ADD CONSTRAINT `items_ibfk_1` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`warehouse_id`) ON DELETE CASCADE;

--
-- Constraints for table `supplydocuments`
--
ALTER TABLE `supplydocuments`
  ADD CONSTRAINT `supplydocuments_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `supplydocuments_ibfk_2` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouses` (`warehouse_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `supplydocuments_ibfk_3` FOREIGN KEY (`item_id`) REFERENCES `items` (`item_id`) ON DELETE CASCADE;

--
-- Constraints for table `warehouses`
--
ALTER TABLE `warehouses`
  ADD CONSTRAINT `warehouses_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
