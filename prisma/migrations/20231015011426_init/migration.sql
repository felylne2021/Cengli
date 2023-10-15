/*
  Warnings:

  - You are about to drop the column `availableAmount` on the `P2POrder` table. All the data in the column will be lost.
  - Added the required column `availableAmount` to the `P2PListing` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE `OrderChat` DROP FOREIGN KEY `OrderChat_orderId_fkey`;

-- DropForeignKey
ALTER TABLE `P2POrder` DROP FOREIGN KEY `P2POrder_listingId_fkey`;

-- AlterTable
ALTER TABLE `P2PListing` ADD COLUMN `availableAmount` DOUBLE NOT NULL;

-- AlterTable
ALTER TABLE `P2POrder` DROP COLUMN `availableAmount`;

-- AddForeignKey
ALTER TABLE `P2POrder` ADD CONSTRAINT `P2POrder_listingId_fkey` FOREIGN KEY (`listingId`) REFERENCES `P2PListing`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `OrderChat` ADD CONSTRAINT `OrderChat_orderId_fkey` FOREIGN KEY (`orderId`) REFERENCES `P2POrder`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
