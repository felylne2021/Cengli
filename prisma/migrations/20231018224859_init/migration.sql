-- CreateTable
CREATE TABLE `UserNotification` (
    `walletAddress` VARCHAR(191) NOT NULL,
    `fcmToken` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`walletAddress`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
