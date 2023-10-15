/*
  Warnings:

  - Added the required column `availableAmount` to the `P2POrder` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `P2POrder` ADD COLUMN `availableAmount` DOUBLE NOT NULL;
