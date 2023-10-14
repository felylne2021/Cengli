/*
  Warnings:

  - You are about to drop the column `chainId` on the `Transaction` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE `Transaction` DROP FOREIGN KEY `Transaction_tokenAddress_chainId_fkey`;

-- AlterTable
ALTER TABLE `Transaction` DROP COLUMN `chainId`,
    ADD COLUMN `destinationChainId` INTEGER NOT NULL DEFAULT 80001,
    ADD COLUMN `fromChainId` INTEGER NOT NULL DEFAULT 5;

-- AddForeignKey
ALTER TABLE `Transaction` ADD CONSTRAINT `Transaction_tokenAddress_fromChainId_fkey` FOREIGN KEY (`tokenAddress`, `fromChainId`) REFERENCES `Token`(`address`, `chainId`) ON DELETE RESTRICT ON UPDATE CASCADE;
