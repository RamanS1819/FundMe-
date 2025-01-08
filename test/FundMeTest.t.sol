// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    // us -> FundMeTest -> FundMe
    FundMe fundMe;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsDeployer() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    // What can we do to work with addresses outside our system?
    // 1. Unit
    //    - Testing a specific part of our code
    // 2. Integration
    //    - Testing how our code works with other parts of code
    // 3. Forked
    //    - Testing how our code works with the real world (testing our code on a simulated real environment)
    // 4. Staging
    //   - Testing our code in a real environment that is not prod

      function testPriceFeedVersionIsAccurate() public view {
            uint256 version = fundMe.getVersion();
            assertEq(version, 6);
      }

}
