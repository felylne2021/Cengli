-- CreateTable
CREATE TABLE `ComethSponsoredAddress` (
    `chainId` INTEGER NOT NULL,
    `targetAddress` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `ComethSponsoredAddress_chainId_targetAddress_key`(`chainId`, `targetAddress`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `ComethSponsoredAddress` ADD CONSTRAINT `ComethSponsoredAddress_chainId_fkey` FOREIGN KEY (`chainId`) REFERENCES `Chain`(`chainId`) ON DELETE CASCADE ON UPDATE CASCADE;
