-- AlterTable
ALTER TABLE `P2POrder` MODIFY `status` VARCHAR(191) NOT NULL DEFAULT 'WFSAC';

-- CreateTable
CREATE TABLE `ListingDeposit` (
    `listingId` VARCHAR(191) NOT NULL,
    `txHash` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`listingId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `ListingDeposit` ADD CONSTRAINT `ListingDeposit_listingId_fkey` FOREIGN KEY (`listingId`) REFERENCES `P2PListing`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
