-- CreateTable
CREATE TABLE `Chain` (
    `index` INTEGER NOT NULL DEFAULT 0,
    `chainId` INTEGER NOT NULL,
    `chainName` VARCHAR(191) NOT NULL,
    `rpcUrl` VARCHAR(191) NOT NULL,
    `nativeCurrency` JSON NOT NULL,
    `blockExplorer` VARCHAR(191) NOT NULL,
    `logoURI` VARCHAR(191) NOT NULL,
    `hyperlaneBridgeAddress` VARCHAR(191) NOT NULL DEFAULT '0x0',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`chainId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Token` (
    `id` VARCHAR(191) NOT NULL,
    `address` VARCHAR(191) NOT NULL,
    `chainId` INTEGER NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `symbol` VARCHAR(191) NOT NULL,
    `decimals` INTEGER NOT NULL,
    `logoURI` VARCHAR(191) NOT NULL,
    `priceUsd` DOUBLE NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Token_chainId_address_key`(`chainId`, `address`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `HyperlaneWarpRoute` (
    `id` VARCHAR(191) NOT NULL,
    `bridgeAddress` VARCHAR(191) NOT NULL,
    `chainId` INTEGER NOT NULL,
    `tokenAddress` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `HyperlaneWarpRoute_chainId_tokenAddress_key`(`chainId`, `tokenAddress`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Transaction` (
    `id` VARCHAR(191) NOT NULL,
    `fromUserId` VARCHAR(191) NOT NULL,
    `destinationUserId` VARCHAR(191) NOT NULL,
    `fromAddress` VARCHAR(191) NOT NULL,
    `destinationAddress` VARCHAR(191) NOT NULL,
    `fromChainId` INTEGER NOT NULL,
    `destinationChainId` INTEGER NOT NULL,
    `tokenAddress` VARCHAR(191) NOT NULL,
    `amount` DOUBLE NOT NULL,
    `note` VARCHAR(191) NULL,
    `tokenId` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `P2PPartner` (
    `id` VARCHAR(191) NOT NULL,
    `userId` VARCHAR(191) NOT NULL,
    `address` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL DEFAULT 'Larry Gonzales',
    `chainId` INTEGER NOT NULL DEFAULT 43113,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `P2PPartner_userId_chainId_key`(`userId`, `chainId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PartnerBalance` (
    `partnerId` VARCHAR(191) NOT NULL,
    `tokenId` VARCHAR(191) NOT NULL,
    `amount` DOUBLE NOT NULL,

    UNIQUE INDEX `PartnerBalance_tokenId_partnerId_key`(`tokenId`, `partnerId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `P2POrder` (
    `id` VARCHAR(191) NOT NULL,
    `partnerId` VARCHAR(191) NOT NULL,
    `buyerUserId` VARCHAR(191) NOT NULL,
    `buyerAddress` VARCHAR(191) NOT NULL,
    `destinationChainId` INTEGER NOT NULL,
    `tokenId` VARCHAR(191) NOT NULL,
    `amount` DOUBLE NOT NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'WFSAC',
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `P2POrderDeposit` (
    `orderId` VARCHAR(191) NOT NULL,
    `contractOrderId` VARCHAR(191) NOT NULL,
    `txHash` VARCHAR(191) NOT NULL,
    `from` VARCHAR(191) NOT NULL,
    `to` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`orderId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `OrderChat` (
    `orderId` VARCHAR(191) NOT NULL,
    `chatId` VARCHAR(191) NOT NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,

    PRIMARY KEY (`orderId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ComethSponsoredAddress` (
    `chainId` INTEGER NOT NULL,
    `targetAddress` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `ComethSponsoredAddress_chainId_targetAddress_key`(`chainId`, `targetAddress`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `UserNotification` (
    `walletAddress` VARCHAR(191) NOT NULL,
    `fcmToken` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`walletAddress`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Token` ADD CONSTRAINT `Token_chainId_fkey` FOREIGN KEY (`chainId`) REFERENCES `Chain`(`chainId`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `HyperlaneWarpRoute` ADD CONSTRAINT `HyperlaneWarpRoute_chainId_fkey` FOREIGN KEY (`chainId`) REFERENCES `Chain`(`chainId`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `HyperlaneWarpRoute` ADD CONSTRAINT `HyperlaneWarpRoute_chainId_tokenAddress_fkey` FOREIGN KEY (`chainId`, `tokenAddress`) REFERENCES `Token`(`chainId`, `address`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Transaction` ADD CONSTRAINT `Transaction_tokenId_fkey` FOREIGN KEY (`tokenId`) REFERENCES `Token`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `P2PPartner` ADD CONSTRAINT `P2PPartner_chainId_fkey` FOREIGN KEY (`chainId`) REFERENCES `Chain`(`chainId`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PartnerBalance` ADD CONSTRAINT `PartnerBalance_partnerId_fkey` FOREIGN KEY (`partnerId`) REFERENCES `P2PPartner`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PartnerBalance` ADD CONSTRAINT `PartnerBalance_tokenId_fkey` FOREIGN KEY (`tokenId`) REFERENCES `Token`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `P2POrder` ADD CONSTRAINT `P2POrder_partnerId_fkey` FOREIGN KEY (`partnerId`) REFERENCES `P2PPartner`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `P2POrder` ADD CONSTRAINT `P2POrder_tokenId_fkey` FOREIGN KEY (`tokenId`) REFERENCES `Token`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `P2POrderDeposit` ADD CONSTRAINT `P2POrderDeposit_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `P2POrder`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `OrderChat` ADD CONSTRAINT `OrderChat_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `P2POrder`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ComethSponsoredAddress` ADD CONSTRAINT `ComethSponsoredAddress_chainId_fkey` FOREIGN KEY (`chainId`) REFERENCES `Chain`(`chainId`) ON DELETE CASCADE ON UPDATE CASCADE;
