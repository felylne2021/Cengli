-- AlterTable
ALTER TABLE `P2POrder` ADD COLUMN `tokenAddress` VARCHAR(191) NOT NULL DEFAULT '0x07865c6E87B9F70255377e024ace6630C1Eaa37F';

-- AddForeignKey
ALTER TABLE `P2POrder` ADD CONSTRAINT `P2POrder_destinationChainId_tokenAddress_fkey` FOREIGN KEY (`destinationChainId`, `tokenAddress`) REFERENCES `Token`(`chainId`, `address`) ON DELETE RESTRICT ON UPDATE CASCADE;
