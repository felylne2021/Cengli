/*
  Warnings:

  - You are about to drop the column `tokenId` on the `Transaction` table. All the data in the column will be lost.

*/
-- DropForeignKey
-- ALTER TABLE `Transaction` DROP FOREIGN KEY `Transaction_tokenId_fkey`;

-- AlterTable
-- ALTER TABLE `Transaction` DROP COLUMN `tokenId`;

-- AddForeignKey
-- ALTER TABLE `Transaction` ADD CONSTRAINT `Transaction_tokenId_fkey` FOREIGN KEY (`tokenId`) REFERENCES `Token`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
