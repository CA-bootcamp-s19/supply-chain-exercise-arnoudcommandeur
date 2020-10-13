import "./SupplyChain.sol";

pragma solidity ^0.5.0;

contract ProxySupplyChain {

  /* set owner */
  address owner;

  /* SupplyChain contract */
  SupplyChain supplyChain;

  constructor(SupplyChain _supplyChain) public {
    /* Here, set the owner as the person who instantiated the contract */
    owner = msg.sender;
    supplyChain = _supplyChain;
  }

/* Call Function shipItem from supplyChain contract and return true/false */
  function shipItem(uint _sku) public returns (bool)
  {
    bool r;

    // Try to ship with current account
    (r, ) = address(supplyChain).call(abi.encodeWithSignature("shipItem(uint256)",_sku));

    return r;
}

/* Call Function receiveItem from supplyChain contract and return true/false */
  function receiveItem(uint _sku) public returns (bool)
  {
    bool r;

    // Try to set item to received with current account
    (r, ) = address(supplyChain).call(abi.encodeWithSignature("receiveItem(uint256)",_sku));

    return r;
  }


}
