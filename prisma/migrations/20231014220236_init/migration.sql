-- AlterTable
ALTER TABLE `Transaction` ALTER COLUMN `destinationChainId` DROP DEFAULT,
    ALTER COLUMN `fromChainId` DROP DEFAULT;
