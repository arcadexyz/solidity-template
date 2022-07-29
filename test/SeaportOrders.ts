import { ethers, waffle, upgrades } from "hardhat";
import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import { expect } from "chai";
const { loadFixture } = waffle;

import type { BuyItem } from "./utils/types";
import type { MockWeth } from "../src/types/contracts/MockWETH.sol";
import type { MockERC20, MockERC721, OrderRouter } from "../src/types/contracts";
import type { ConsiderationInterface } from "../src/types/contracts/marketplaces/SeaportV2";

import { deploy } from "./utils/contracts";

interface TestContext {
  signers: SignerWithAddress[];
  admin: SignerWithAddress;
  buyer: SignerWithAddress;
  seller: SignerWithAddress;
  mockWeth: MockWeth;
  mockERC20: MockERC20;
  mockERC721: MockERC721;
  orderRouter: OrderRouter;
}

describe("Treasure Marketplace order routing tests", () => {
  let ctx: TestContext;

  const fixture = async (): Promise<TestContext> => {
    // signers
    const signers: SignerWithAddress[] = await ethers.getSigners();
    // mocks
    const mockWeth = <MockWeth> await deploy("MockWeth", signers[0], []);
    const mockERC20 = <MockERC20> await deploy("MockERC20", signers[0], []);
    const mockERC721 = <MockERC721> await deploy("MockERC721", signers[0], []);
    // order router
    const orderRouter = <OrderRouter>await deploy("OrderRouter", signers[0], []);
    // marketplace

    return {
      signers,
      admin: signers[0],
      buyer: signers[1],
      seller: signers[2],
      mockWeth,
      mockERC20,
      mockERC721,
      orderRouter,
    };
  };

  beforeEach(async () => {
    ctx = await loadFixture(fixture);
  });

  describe("callTreasureMarketplace", () => {
    it("should create a listing directly on marketplace", async () => {
      const { admin, buyer, seller, mockWeth, mockERC20, mockERC721 } = ctx;
    });

    it("should buy a listing on the marketplace using the orderRouter", async () => {

    });
  });
});
