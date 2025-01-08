// SPDX-License-Identifier: MIT

// 1. Deploy mocks when we are on a local anvil chain
// 2. Kepp track of contract address across different chains
//  --- like Sepolia ETH/USD
//  --- like Mainnet ETH/USD

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
      // If we are on a local anvil chain, we can deploy mocks
      // Otherwise, grab the existing address from the live network
      NetworkConfig public activeNetworkConfig;

      uint8 public constant DECIMALS = 8;
      uint256 public constant INITIAL_PRICE = 2000e8;

      struct NetworkConfig {
            address priceFeed; // ETH/USD price feed address
      }

      constructor() {
            if (block.chainid == 11155111) {
                  activeNetworkConfig = getSepoliaEthConfig(); // sepolia
                  // mainnet
            } else if (block.chainid == 1) {
                  activeNetworkConfig = getMainnetEthConfig(); // mainnet

            }else {
                  activeNetworkConfig = getOrCreateAnvilEthConfig(); // anvil
            }
      }

      function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
            // price feed address
            NetworkConfig memory sepoliaConfig = NetworkConfig({
                  priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
            return sepoliaConfig;
      }

      function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
            // price feed address
            NetworkConfig memory ethConfig = NetworkConfig({
                  priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
            });
            return ethConfig;
      }

      function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory){
            if (activeNetworkConfig.priceFeed != address(0)) {
                  return activeNetworkConfig;
            }
            // price feed address

            // 1. Deploy mocks
            // 2. Return the mock address

            vm.startBroadcast();
            MockV3Aggregator mockEthUsd = new MockV3Aggregator(
                  DECIMALS,
                  int256(INITIAL_PRICE)
            );
            vm.stopBroadcast();

            NetworkConfig memory anvilConfig = NetworkConfig({
                  priceFeed: address(mockEthUsd)
            });
            return anvilConfig;
      }
}