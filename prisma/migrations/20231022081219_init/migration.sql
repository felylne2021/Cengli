-- CreateTable
CREATE TABLE `HyperlaneCCTPRoute` (
    `id` VARCHAR(191) NOT NULL,
    `bridgeAddress` VARCHAR(191) NOT NULL,
    `chainId` INTEGER NOT NULL,
    `tokenAddress` VARCHAR(191) NOT NULL,

    UNIQUE INDEX `HyperlaneCCTPRoute_chainId_tokenAddress_key`(`chainId`, `tokenAddress`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `HyperlaneCCTPRoute` ADD CONSTRAINT `HyperlaneCCTPRoute_chainId_fkey` FOREIGN KEY (`chainId`) REFERENCES `Chain`(`chainId`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `HyperlaneCCTPRoute` ADD CONSTRAINT `HyperlaneCCTPRoute_chainId_tokenAddress_fkey` FOREIGN KEY (`chainId`, `tokenAddress`) REFERENCES `Token`(`chainId`, `address`) ON DELETE CASCADE ON UPDATE CASCADE;
