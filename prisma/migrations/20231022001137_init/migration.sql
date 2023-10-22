/*
  Warnings:

  - Added the required column `autoswapAddress` to the `HyperlaneWarpRoute` table without a default value. This is not possible if the table is not empty.
  - Added the required column `wrappedTokenAddress` to the `HyperlaneWarpRoute` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `HyperlaneWarpRoute` ADD COLUMN `autoswapAddress` VARCHAR(191) NOT NULL,
    ADD COLUMN `wrappedTokenAddress` VARCHAR(191) NOT NULL;
