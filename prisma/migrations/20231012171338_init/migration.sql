-- CreateTable
CREATE TABLE `Transaction` (
    `id` VARCHAR(191) NOT NULL,
    `fromUserId` VARCHAR(191) NOT NULL,
    `destinationUserId` VARCHAR(191) NOT NULL,
    `fromAddress` VARCHAR(191) NOT NULL,
    `destinationAddress` VARCHAR(191) NOT NULL,
    `chainId` INTEGER NOT NULL,
    `tokenAddress` VARCHAR(191) NOT NULL,
    `amount` DOUBLE NOT NULL,
    `note` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Transaction` ADD CONSTRAINT `Transaction_tokenAddress_chainId_fkey` FOREIGN KEY (`tokenAddress`, `chainId`) REFERENCES `Token`(`address`, `chainId`) ON DELETE RESTRICT ON UPDATE CASCADE;
