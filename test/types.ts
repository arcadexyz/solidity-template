import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";
import type {  MockERC20, MockERC721 } from "../src/types/contracts";
import type {  MockWeth } from "../src/types/contracts/MockWETH.sol";
import type {  OrderRouter } from "../src/types/contracts";
import type {  TreasureMarketplace } from "../src/types/contracts/marketplaces/TreasureMarketplace";

type Fixture<T> = () => Promise<T>;

declare module "mocha" {
  export interface Context {
    mockERC20: MockERC20;
    mockERC721: MockERC721;
    mockWeth: MockWeth;
    treasureMarketplace: TreasureMarketplace;
    orderRouter: OrderRouter;
    loadFixture: <T>(fixture: Fixture<T>) => Promise<T>;
    signers: Signers;
  }
}

export interface Signers {
  admin: SignerWithAddress;
}
