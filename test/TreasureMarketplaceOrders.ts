import { ethers, waffle, upgrades } from "hardhat";
import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import { expect } from "chai";
const { loadFixture } = waffle;

import type { BuyItem } from "./utils/types";
import type { MockWeth } from "../src/types/contracts/MockWETH.sol";
import type { MockERC20, MockERC721, OrderRouter } from "../src/types/contracts";
import type { TreasureMarketplace } from "../src/types/contracts/marketplaces/TreasureMarketplace";

import { encodeBytesData } from "./utils/utils"
import { deploy } from "./utils/contracts";

interface TestContext {
  signers: SignerWithAddress[];
  admin: SignerWithAddress;
  buyer: SignerWithAddress;
  seller: SignerWithAddress;
  mockWeth: MockWeth;
  mockERC20: MockERC20;
  mockERC721: MockERC721;
  treasureMarketplace: TreasureMarketplace;
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
    const TreasureMarketplace = await ethers.getContractFactory("TreasureMarketplace");
    const treasureMarketplace = <TreasureMarketplace>(await upgrades.deployProxy(
        TreasureMarketplace,
        [50, signers[0].address, mockERC20.address],
        { kind: "transparent", initializer: "initialize" },
    ));

    return {
      signers,
      admin: signers[0],
      buyer: signers[1],
      seller: signers[2],
      mockWeth,
      mockERC20,
      mockERC721,
      treasureMarketplace,
      orderRouter,
    };
  };

  beforeEach(async () => {
    ctx = await loadFixture(fixture);
  });

  describe("callTreasureMarketplace", () => {
    it("should create a listing directly on marketplace", async () => {
      const { admin, buyer, seller, mockWeth, mockERC20, mockERC721, treasureMarketplace } = ctx;
      // NFT to mint and sell
      let nftIndexToMint: number = 0;
      // init marketplace
      await treasureMarketplace.connect(admin).setWeth(mockWeth.address);
      await treasureMarketplace.connect(admin).setTokenApprovalStatus(mockERC721.address, 1, mockERC20.address);
      expect(await treasureMarketplace.connect(admin).getPaymentTokenForCollection(mockERC721.address)).to.equal(mockERC20.address);
      // setup more context
      await mockERC20.mint(buyer.address, ethers.utils.parseEther('100'));
      await mockERC721.safeMint(seller.address, nftIndexToMint);
      expect(await mockERC20.balanceOf(buyer.address)).to.equal(ethers.utils.parseEther('100'));
      expect(await mockERC721.balanceOf(seller.address)).to.equal(1);
      // create listing
      await mockERC721.connect(seller).setApprovalForAll(treasureMarketplace.address, true);
      await treasureMarketplace.connect(seller).createListing(mockERC721.address, 0, 1, ethers.utils.parseEther('10'), 1689955938, mockERC20.address);
      let listing = await treasureMarketplace.listings(mockERC721.address, 0, seller.address);
      expect(listing.paymentTokenAddress).to.equal(mockERC20.address)
    });

    it("should buy a listing on the marketplace using the orderRouter", async () => {
      const { admin, buyer, seller, mockWeth, mockERC20, mockERC721, treasureMarketplace, orderRouter } = ctx;
      // NFT to mint and sell
      let nftIndexToMint: number = 0;
      // craft data
      const buyItems: BuyItem[] = [
          {
              nftAddress: mockERC721.address,
              tokenId: nftIndexToMint,
              owner: seller.address,
              quantity: 1,
              maxPricePerItem: ethers.utils.parseEther('10'),
              paymentToken: mockERC20.address,
              usingEth:false
          },
      ];
      // encode data
      const bytesData = encodeBytesData(buyItems);
      // init marketplace
      await treasureMarketplace.connect(admin).setWeth(mockWeth.address);
      await treasureMarketplace.connect(admin).setTokenApprovalStatus(mockERC721.address, 1, mockERC20.address);
      expect(await treasureMarketplace.connect(admin).getPaymentTokenForCollection(mockERC721.address)).to.equal(mockERC20.address);
      // setup more context
      await mockERC20.mint(buyer.address, ethers.utils.parseEther('100'));
      await mockERC721.safeMint(seller.address, nftIndexToMint);
      expect(await mockERC20.balanceOf(buyer.address)).to.equal(ethers.utils.parseEther('100'));
      expect(await mockERC721.balanceOf(seller.address)).to.equal(1);
      // create listing
      await mockERC721.connect(seller).setApprovalForAll(treasureMarketplace.address, true);
      await treasureMarketplace.connect(seller).createListing(mockERC721.address, 0, 1, ethers.utils.parseEther('10'), 1689955938, mockERC20.address);
      let listing = await treasureMarketplace.listings(mockERC721.address, 0, seller.address);
      expect(listing.paymentTokenAddress).to.equal(mockERC20.address)
      // buy with OrderRouter contract
      await orderRouter.connect(buyer).fulfillOrder(4, treasureMarketplace.address, bytesData);
    });
  });
});
