-- AlterTable
ALTER TABLE `P2POrder` ALTER COLUMN `tokenAddress` DROP DEFAULT;

-- CreateTable
CREATE TABLE `P2POrderDeposit` (
    `orderId` VARCHAR(191) NOT NULL,
    `contractOrderId` INTEGER NOT NULL,
    `txHash` VARCHAR(191) NOT NULL,
    `from` VARCHAR(191) NOT NULL,
    `to` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`orderId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `P2POrderDeposit` ADD CONSTRAINT `P2POrderDeposit_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `P2POrder`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
