/*
  Warnings:

  - A unique constraint covering the columns `[tokenAddress,tokenChainId,partnerId]` on the table `PartnerBalance` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX `PartnerBalance_tokenAddress_tokenChainId_partnerId_key` ON `PartnerBalance`(`tokenAddress`, `tokenChainId`, `partnerId`);
