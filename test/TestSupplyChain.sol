pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SupplyChain.sol";
import "../contracts/ProxySupplyChain.sol";

contract TestSupplyChain {

    SupplyChain public supplyChain;
    uint public initialBalance = 1 ether;
    
    // Run before every test function
    function beforeEach() public {
        supplyChain = new SupplyChain();
        initialBalance = 1 ether;
    }

    // buyItem
    // test for failure if user does not send enough funds
    function testBuyItem() public returns (bool) {

        supplyChain.addItem("Test",1000);        

        bool r;

        (r, ) = address(supplyChain).call.value(500)(abi.encodeWithSignature("buyItem(uint256)",0));
        Assert.isFalse(r, "If this is true, something is broken!");
    }

  function () external payable {
  }

    // buyItem
    // test for purchasing an item that is not for Sale
    function testBuyItem2() public returns (bool) {
        bool r;

        supplyChain.addItem("Test",1000);        

        // Buy item, should pass
        (r, ) = address(supplyChain).call.value(1000)(abi.encodeWithSignature("buyItem(uint256)",0));
        Assert.isTrue(r, "If this is false, something is broken!");

        // Try to buy same item again, should fail
        (r, ) = address(supplyChain).call.value(1000)(abi.encodeWithSignature("buyItem(uint256)",0));
        Assert.isFalse(r, "If this is true, something is broken!");

        return true;
    }

    // shipItem
    // test for calls that are made by not the seller
    function testShipItem1() public returns (bool) {
        bool r = false;

        ProxySupplyChain Proxy = new ProxySupplyChain(supplyChain);

        supplyChain.addItem("Test",1000);
        (r, ) = address(supplyChain).call.value(1000)(abi.encodeWithSignature("buyItem(uint256)",0));

        r = Proxy.shipItem(0);
        Assert.isFalse(r, "If this is true, the contract does not work!");

        return r;
    }

    // shipItem
    // test for trying to ship an item that is not marked Sold
    function testShipItem2() public returns (bool) {
        bool r;

        supplyChain.addItem("Test",1000);        

        (r, ) = address(supplyChain).call(abi.encodeWithSignature("shipItem(uint256)",0));
        Assert.isFalse(r, "If this is true, something is broken!");

        return true;
    }


    // receiveItem
    // test calling the function from an address that is not the buyer
    function testReceivedItem1() public returns (bool) {
        bool r;
        ProxySupplyChain Proxy = new ProxySupplyChain(supplyChain);

        supplyChain.addItem("Test",1000);        
        supplyChain.buyItem.value(1000)(0);
        supplyChain.shipItem(0);

        r = Proxy.receiveItem(0);
        Assert.isFalse(r, "If this is true, the contract does not work!");

        return r;
    }

    // receiveItem
    // test calling the function on an item not marked Shipped
    function testReceivedItem2() public returns (bool) {
        bool r;

        supplyChain.addItem("Test",1000);        
        supplyChain.buyItem.value(1000)(0);

        (r, ) = address(supplyChain).call(abi.encodeWithSignature("receiveItem(uint256)",0));
        Assert.isFalse(r, "If this is true, something is broken!");

        return r;
    }
}

