/*
  Warnings:

  - You are about to drop the column `listingId` on the `P2POrder` table. All the data in the column will be lost.
  - Added the required column `partnerId` to the `P2POrder` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE `P2POrder` DROP FOREIGN KEY `P2POrder_listingId_fkey`;

-- AlterTable
ALTER TABLE `P2POrder` DROP COLUMN `listingId`,
    ADD COLUMN `p2PListingId` VARCHAR(191) NULL,
    ADD COLUMN `partnerId` VARCHAR(191) NOT NULL;

-- AddForeignKey
ALTER TABLE `P2POrder` ADD CONSTRAINT `P2POrder_partnerId_fkey` FOREIGN KEY (`partnerId`) REFERENCES `P2PPartner`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `P2POrder` ADD CONSTRAINT `P2POrder_p2PListingId_fkey` FOREIGN KEY (`p2PListingId`) REFERENCES `P2PListing`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
