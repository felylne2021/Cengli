/* eslint-disable */

const CengliP2PEscrow = artifacts.require("CengliP2PEscrow");
const MockERC20 = artifacts.require("MockERC20");

contract("CengliP2PEscrow", (accounts) => {
  let escrow, token;
  const [owner, buyer, partner] = accounts;

  beforeEach(async () => {
    console.log("Deploying escrow contract");

    escrow = await CengliP2PEscrow.new(owner, { from: owner });

    token = await MockERC20.new({ from: owner });
    console.log("Approving tokens");
    await token.approve(escrow.address, 100, { from: partner });
  });


  it("should accept an order", async () => {
    const tx = await escrow.acceptOrder(buyer, partner, token.address, 100, { from: owner });
    assert.equal(tx.logs[0].args.newStatus.toNumber(), 1);
  });

  it("should cancel an order", async () => {
    await escrow.acceptOrder(buyer, partner, token.address, 100, { from: owner });
    const tx = await escrow.cancelOrder(1, { from: owner });
    assert.equal(tx.logs[0].args.newStatus.toNumber(), 2);
  });

  it("should release funds", async () => {
    await escrow.acceptOrder(buyer, partner, token.address, 100, { from: owner });
    const tx = await escrow.releaseFunds(1, { from: owner });
    assert.equal(tx.logs[0].args.newStatus.toNumber(), 3);
  });

  it("should fetch order details", async () => {
    await escrow.acceptOrder(buyer, partner, token.address, 100, { from: owner });
    const order = await escrow.getOrder(1);
    assert.equal(order.buyer, buyer);
    assert.equal(order.partner, partner);
    assert.equal(order.token, token.address);
    assert.equal(order.amount.toNumber(), 100);
    assert.equal(order.status.toNumber(), 1);
  });
});
