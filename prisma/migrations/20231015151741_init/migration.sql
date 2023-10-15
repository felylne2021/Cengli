/*
  Warnings:

  - You are about to drop the column `p2PListingId` on the `P2POrder` table. All the data in the column will be lost.
  - You are about to drop the `ListingDeposit` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `P2PListing` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `ListingDeposit` DROP FOREIGN KEY `ListingDeposit_listingId_fkey`;

-- DropForeignKey
ALTER TABLE `P2PListing` DROP FOREIGN KEY `P2PListing_tokenAddress_tokenChainId_fkey`;

-- DropForeignKey
ALTER TABLE `P2POrder` DROP FOREIGN KEY `P2POrder_p2PListingId_fkey`;

-- AlterTable
ALTER TABLE `P2POrder` DROP COLUMN `p2PListingId`;

-- DropTable
DROP TABLE `ListingDeposit`;

-- DropTable
DROP TABLE `P2PListing`;
