-- CreateTable
CREATE TABLE `P2PListing` (
    `id` VARCHAR(191) NOT NULL,
    `userId` VARCHAR(191) NOT NULL,
    `userAddress` VARCHAR(191) NOT NULL,
    `tokenAddress` VARCHAR(191) NOT NULL,
    `tokenChainId` INTEGER NOT NULL,
    `amount` DOUBLE NOT NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `P2POrder` (
    `id` VARCHAR(191) NOT NULL,
    `listingId` VARCHAR(191) NOT NULL,
    `buyerUserId` VARCHAR(191) NOT NULL,
    `buyerAddress` VARCHAR(191) NOT NULL,
    `amount` DOUBLE NOT NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'WFBP',
    `isBuyer` BOOLEAN NOT NULL DEFAULT true,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `OrderChat` (
    `orderId` VARCHAR(191) NOT NULL,
    `chatId` VARCHAR(191) NOT NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,

    PRIMARY KEY (`orderId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `P2PListing` ADD CONSTRAINT `P2PListing_tokenAddress_tokenChainId_fkey` FOREIGN KEY (`tokenAddress`, `tokenChainId`) REFERENCES `Token`(`address`, `chainId`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `P2POrder` ADD CONSTRAINT `P2POrder_listingId_fkey` FOREIGN KEY (`listingId`) REFERENCES `P2PListing`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `OrderChat` ADD CONSTRAINT `OrderChat_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `P2POrder`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
