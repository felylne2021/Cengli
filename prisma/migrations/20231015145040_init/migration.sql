/*
  Warnings:

  - Added the required column `partnerId` to the `PartnerBalance` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `PartnerBalance` ADD COLUMN `partnerId` VARCHAR(191) NOT NULL;

-- AddForeignKey
ALTER TABLE `PartnerBalance` ADD CONSTRAINT `PartnerBalance_partnerId_fkey` FOREIGN KEY (`partnerId`) REFERENCES `P2PPartner`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
