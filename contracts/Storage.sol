pragma solidity ^0.5.7;

import "./ERC20.sol";

contract Storage is Owned {

    Token public token;
    uint256 public rate =100;
    uint256 public tokensSold;

    mapping(address => uint256) TokensOnStake;
    
    constructor (address payable _tokenAddress) public {
        token = Token(_tokenAddress);
    }

    function buyToken() public payable {
        if(tokensSold == token.totalSupply()){
            revert();
        }
        else{
            require((msg.value * rate) <= token.balanceOf(address(this)));
            token.transfer(msg.sender, (msg.value * rate));
            tokensSold += (msg.value * rate);
        }
    }

    function requestData(uint256 value) public {
        require(token.balanceOf(msg.sender) >= value);
        // token.allowance(msg.sender, address(this));
        token.transferFrom(msg.sender, address(this), value);
        TokensOnStake[msg.sender] += value;
    }
    
    function getTokenForData(address newAddress) public{
        require(TokensOnStake[newAddress] >= rate);
        require(rate <= token.balanceOf(address(this)));
        token.transfer(msg.sender, rate);
        TokensOnStake[newAddress] -=rate;
    }
    
    function getBalance() public view returns (uint) {
        return token.balanceOf(msg.sender);
    }

    function getVaultBalance() public view returns (uint) {
        return token.balanceOf(address(this));
    }


    function tokenWithdraw() public onlyOwner {
        token.transfer(owner, token.balanceOf(address(this)));
    }

    function _forwardFunds() public onlyOwner {
        owner.transfer(address(this).balance);
    }

}
