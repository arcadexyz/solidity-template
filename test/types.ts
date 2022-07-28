import type { SignerWithAddress } from "@nomiclabs/hardhat-ethers/dist/src/signer-with-address";

import type { Greeter } from "../src/types/Greeter";
import type {  TreasureMarketplace } from "../src/types/contracts/marketplaces/TreasureMarketplace";

type Fixture<T> = () => Promise<T>;

declare module "mocha" {
  export interface Context {
    greeter: Greeter;
    treasureMarketplace: TreasureMarketplace;
    loadFixture: <T>(fixture: Fixture<T>) => Promise<T>;
    signers: Signers;
  }
}

export interface Signers {
  admin: SignerWithAddress;
}
