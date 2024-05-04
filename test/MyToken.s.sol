// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MyToken.sol";

contract MyTokenTest is Test {
    MyToken public myToken;

    address public owner;
    address public ZERO_ADDRESS = address(0);
    address public spender = address(1);
    address public user = address(2);

    string public name = "MyToken";
    string public symbol = "MTK";

    uint256 public decimals = 18;
    uint256 public amount = 1000 * 1e18;
    uint256 public initialSupply = 1000 * 1e18;

    event Transfer(address indexed from, address indexed to, uint256 value);    

    // ======= Set up =======

    function setUp() public {
        owner = address(this);
        myToken = new MyToken();
    }

    // ======= Initial state =======

    function testInitialState() public {
        assertEq(myToken.name(), name);
        assertEq(myToken.symbol(), symbol);
        assertEq(myToken.decimals(), decimals);
        assertEq(myToken.totalSupply(), initialSupply);
    }

    // ======= Functionality tests =======

    function testFailUnauthorisedMint(uint256 amount) public {
        vm.prank(owner);
        myToken.mint(user, amount);
    }

    function testMintZeroAddress(uint256 amount) public {
        vm.prank(owner);
        myToken.mint(ZERO_ADDRESS, amount);
    }

    function testIncreaseTotalSupply(uint256 amount) public {
        uint256 expectedTotalSupply = initialSupply + amount;
        vm.prank(owner);
        myToken.mint(owner, amount);
        assertEq(myToken.totalSupply(), expectedTotalSupply);
    }

    function testIncreaseRecipientBalance(uint256 amount) public {
        vm.prank(owner);
        myToken.mint(user, amount);
        assertEq(myToken.balanceOf(user), amount);
    }

    function testEmitTransferEventForMint(uint256 amount) public {
        vm.expectEmit(true,true,false,true);
        emit Transfer(ZERO_ADDRESS, user, amount);
        vm.prank(owner);
        myToken.mint(user, amount);
    }
}