-- DropForeignKey
ALTER TABLE `P2POrder` DROP FOREIGN KEY `P2POrder_tokenId_fkey`;

-- DropForeignKey
ALTER TABLE `PartnerBalance` DROP FOREIGN KEY `PartnerBalance_tokenId_fkey`;

-- AddForeignKey
ALTER TABLE `PartnerBalance` ADD CONSTRAINT `PartnerBalance_tokenId_fkey` FOREIGN KEY (`tokenId`) REFERENCES `Token`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `P2POrder` ADD CONSTRAINT `P2POrder_tokenId_fkey` FOREIGN KEY (`tokenId`) REFERENCES `Token`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
