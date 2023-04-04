import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from 'dotenv'
dotenv.config()
const config: HardhatUserConfig = {
  solidity: "0.8.18",
  defaultNetwork: "polygon_mumbai",
  networks: {
    hardhat: {
    },
    polygon_mumbai: {
      url: "https://polygon-mumbai.g.alchemy.com/v2/mPMnFvyCsSVLAFmXrTV7et0d94i9ss0X",
      accounts: [process.env.PRIVATE_KEY || "0xsidd"],
    }
  },

};

export default config;
