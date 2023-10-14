-- DropForeignKey
ALTER TABLE `Token` DROP FOREIGN KEY `Token_chainId_fkey`;

-- AddForeignKey
ALTER TABLE `Token` ADD CONSTRAINT `Token_chainId_fkey` FOREIGN KEY (`chainId`) REFERENCES `Chain`(`chainId`) ON DELETE CASCADE ON UPDATE CASCADE;
