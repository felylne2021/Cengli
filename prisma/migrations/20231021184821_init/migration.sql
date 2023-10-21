/*
  Warnings:

  - A unique constraint covering the columns `[userId,chainId]` on the table `P2PPartner` will be added. If there are existing duplicate values, this will fail.

*/
-- DropIndex
DROP INDEX `P2PPartner_userId_key` ON `P2PPartner`;

-- CreateIndex
CREATE UNIQUE INDEX `P2PPartner_userId_chainId_key` ON `P2PPartner`(`userId`, `chainId`);
