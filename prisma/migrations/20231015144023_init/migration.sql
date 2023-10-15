-- CreateTable
CREATE TABLE `P2PPartner` (
    `id` VARCHAR(191) NOT NULL,
    `userId` VARCHAR(191) NOT NULL,
    `address` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `P2PPartner_userId_key`(`userId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PartnerBalance` (
    `tokenAddress` VARCHAR(191) NOT NULL,
    `tokenChainId` INTEGER NOT NULL,
    `amount` DOUBLE NOT NULL,

    UNIQUE INDEX `PartnerBalance_tokenAddress_tokenChainId_key`(`tokenAddress`, `tokenChainId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `PartnerBalance` ADD CONSTRAINT `PartnerBalance_tokenAddress_tokenChainId_fkey` FOREIGN KEY (`tokenAddress`, `tokenChainId`) REFERENCES `Token`(`address`, `chainId`) ON DELETE RESTRICT ON UPDATE CASCADE;
