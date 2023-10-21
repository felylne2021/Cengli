-- DropForeignKey
ALTER TABLE `Transaction` DROP FOREIGN KEY `Transaction_tokenAddress_fromChainId_fkey`;

-- AddForeignKey
ALTER TABLE `Transaction` ADD CONSTRAINT `Transaction_tokenAddress_fromChainId_fkey` FOREIGN KEY (`tokenAddress`, `fromChainId`) REFERENCES `Token`(`address`, `chainId`) ON DELETE CASCADE ON UPDATE CASCADE;
