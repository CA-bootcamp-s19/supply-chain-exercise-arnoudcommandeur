Nice work Arnoud!

I recommend you upgrade to use the latest solidity as some things have changed
from 0.5.0 to 0.7.3. Now that you have the infrastructure add a few more tests.

For example (think of more):
  - [ ] can an item be purchased if buyer doesn't have enough funds?
  - [ ] can an item be purchased twice?
  - [ ] can a random user ship an item?

## *.call.value* changed from 0.5.0 to 0.7.3:
  Use call{value: offer} to invoke **supplyChain.buyItem(sku)** with msg.sender

``` Solidity
  /// See: https://solidity.readthedocs.io/en/v0.7.3/070-breaking-changes.html#changes-to-the-syntax
  address(supplyChain).call{value: offer}(abi.encodeWithSignature("buyItem(uint)", sku));
```

## ProxySupplyChain

Conceptually this is not a proxy for the supply chain.  This contract isn't
really a proxy for the supply chain. It is a proxy for a user of the supply
chain.

Important users are:
  * seller :- puts an item for sale
  * buyer  :- user with funds who attempts to buy an item that is on sale

It is more accurate to call this contract an Actor that plays the part of
a seller, buyer or random actor


## truffle-config development network

If you have this defined you need to start ganache-cli or ganache before
testing. Without it `truffle test` will create a ganache provider behind the
scene.
