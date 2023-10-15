-- AlterTable
ALTER TABLE `P2PListing` ADD COLUMN `isDeposited` BOOLEAN NOT NULL DEFAULT false,
    MODIFY `isActive` BOOLEAN NOT NULL DEFAULT false;
