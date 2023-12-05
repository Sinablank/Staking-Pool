// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

// Import the IERC20 interface for token interaction
import "./Token.sol";
import "./Context.sol";

contract Stake is Context {

    string public Staking;
    address private owner;
    Token private _token;
    uint256 private totalValueLocked;

    constructor(USDT USDT_){
        _token = token_;
        owner = _msgSender();
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only the owner can call this function");
        _;}

    address[] public stakers;

    mapping (address=>uint) public stakingBalance;
    mapping (address=>bool) public oldUser;
    mapping (address=>bool) public isStaking;

    event stakeToken(address staker, uint256 amount);

    function getOwner() public view returns(address){
        return owner;
    }

    function contractAddress() public view returns(address){
        return address(this);
    }

    function getTotalValueLocked() public view returns(uint256){
        return totalValueLocked;
    }

    function getBalance() public view returns(uint256){
        return stakingBalance[_msgSender()];
    }

    function getUsdtAddress() public view returns(address){
        return address(_token);
    }

    function deposit(uint256 _amount) public {
        require(_amount > 0, "Amount should be more than zero");
        //approval will take place in design
        _token.transferFrom(_msgSender(), address(this), _amount);
        stakingBalance[_msgSender()] += _amount;
        totalValueLocked += _amount;
        if(!oldUser[_msgSender()]){
            stakers.push(_msgSender());
        }

        isStaking[_msgSender()] = true;
        oldUser[_msgSender()] = true;

        emit stakeToken (_msgSender(), _amount);
    }

    function Emergency (address payable recipient) public onlyOwner {
        require(recipient != address(0), "Invalid recipient address");

        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "Contract has no balance to transfer");

        recipient.transfer(contractBalance);
    }

    




}