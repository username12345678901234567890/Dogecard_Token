// SPDX-License-Identifier: MIT
// Made by Sangyoon
pragma solidity ^0.8.15;

contract DCDToken {
    using SafeMath for uint256;
    
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    string public name = 'DOGECARD';
    string public symbol = 'DCD';
    uint8 public decimals = 18;
    uint256 public totalSupply = 10000000000 * 10 ** decimals;
    address public owner;
    bool public paused = false;
    modifier CheckPaused() {
        require(!paused, "All transactions are aborted");
        _;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not owner");
        _;
    }
    constructor(address _owner) {
        owner = _owner;  
        balances[owner] = totalSupply;
    }
    function balanceOf( address _ownerAddr) public view returns (uint256 balance) {
        return balances[_ownerAddr];
    }
    
    function transfer(address _to, uint256 _value) public CheckPaused returns (bool success) {
        require(balances[msg.sender] >= _value, "Insufficient balance");
        require(_to != address(0), "Invalid address");
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public CheckPaused returns (bool success) {
        require(_spender != address(0), "Invalid spender address");
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public CheckPaused returns (bool success) {
        require(balances[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        require(_to != address(0), "Invalid address");
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
        
        emit Transfer(_from, _to, _value);
        return true;
    }
    function mint(uint256 _amount) public onlyOwner returns (bool) {
        totalSupply = totalSupply.add(_amount);
        balances[owner] = balances[owner].add(_amount);
        emit Transfer(address(0), owner, _amount);
        return true;
    }
    
    function burn(uint256 _burn_amount, address _address) public onlyOwner {
        require(balances[_address] >= _burn_amount, "Insufficient balance to burn");
        balances[_address] = balances[_address].sub(_burn_amount);
        totalSupply = totalSupply.sub(_burn_amount);
    }
    
    function pause() public onlyOwner {
        paused = true;
    }
    
    function unpause() public onlyOwner {
        paused = false;
    }
}
// SafeMath 라이브러리 (Made By Sangyoon)
library SafeMath {
    // 오버플로우를 방지하기 위해 SafeMath를 사용합니다.
    function add(uint256 value_1, uint256 value_2) internal pure returns (uint256) {
        uint256 result = value_1 + value_2;
        require(result >= value_1, "OVERFLOW");
        return result;
    }
    
    function sub(uint256 value_1, uint256 value_2) internal pure returns (uint256) {
        require(value_2 <= value_1, "UNDERFLOW");
        uint256 result = value_1 - value_2;
        return result;
    }

    function mul(uint256 value_1, uint256 value_2) internal pure returns (uint256) {
        if (value_1 == 0) {
            return 0;
        }
        uint256 result = value_1 * value_2;
        require(result / value_1 == value_2, "OVERFLOW");
        return result;
    }

    function div(uint256 value_1, uint256 value_2) internal pure returns (uint256) {
        require(value_2 > 0, "ZERO");
        uint256 result = value_1 / value_2;
        return result;
    }
    
    function mod(uint256 value_1, uint256 value_2) internal pure returns (uint256) {
        require(value_1 != 0, "ZERO");
        return value_1 % value_2;
    }
}
