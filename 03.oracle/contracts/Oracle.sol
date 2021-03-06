// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Oracle {
    address owner;
    uint256 public numberAsteroids;

    event __callbackNewData();

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    function update() public onlyOwner {
        emit __callbackNewData();
    }

    function setNumberAsteroids(uint256 _num) public onlyOwner {
        numberAsteroids = _num;
    }
}
