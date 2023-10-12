-- CreateTable
CREATE TABLE `Chain` (
    `chainId` INTEGER NOT NULL,
    `chainName` VARCHAR(191) NOT NULL,
    `rpcUrl` VARCHAR(191) NOT NULL,
    `nativeCurrency` JSON NOT NULL,
    `blockExplorer` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`chainId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Token` (
    `address` VARCHAR(191) NOT NULL,
    `chainId` INTEGER NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `symbol` VARCHAR(191) NOT NULL,
    `decimals` INTEGER NOT NULL,
    `logoURI` VARCHAR(191) NOT NULL,
    `priceUsd` DOUBLE NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`address`, `chainId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Token` ADD CONSTRAINT `Token_chainId_fkey` FOREIGN KEY (`chainId`) REFERENCES `Chain`(`chainId`) ON DELETE RESTRICT ON UPDATE CASCADE;
