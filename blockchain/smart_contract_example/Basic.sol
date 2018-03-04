pragma solidity ^0.4.20;

import "./Library.sol";
import "./Owner.sol";

// 基础合约
contract Basic is Owner {

    // Token名称
    string public name;
    // Token符号
    string public symbol;
    // Token总供应量
    uint256 public totalSupply;

    // 账户里可用token余额
    mapping (address => uint256) public balanceOf;

    // 事件通知
    // Token转账消息
    event Transfer(address indexed from, address indexed to, uint256 value);
    // Token销毁消息
    event Burn(address indexed from, uint256 value);
    // Token增发消息
    event Offer(uint256 value);

    /**
     * 初始化
     * @param _initialSupply 发行币供应量
     * @param _tokenName 发行币名
     * @param _tokenSymbol 发行币符号
     */
    function Basic(
        uint256 _initialSupply,
        string _tokenName,
        string _tokenSymbol
    ) public Owner() {
        totalSupply = _initialSupply; 
        balanceOf[msg.sender] = totalSupply;
        name = _tokenName;
        symbol = _tokenSymbol;
    }

    /**
     * Token转账(internal)
     * @param _from 来源账户
     * @param _to   目的账户
     * @param _value 金额
     */
    function _transfer(address _from, address _to, uint _value) internal {
        // 防止销毁
        require(_to != 0x0);

        require(balanceOf[_from] >= _value);
        // 防止溢出
        require(balanceOf[_to] + _value> balanceOf[_to]);

        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        // 转账
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        // 确保账户一致
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);

        Transfer(_from, _to, _value);
    }

    /**
     * Token从当前执行的账户转账给目的账户
     *
     * @param _to   目的账户
     * @param _value 金额
     */
    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    /**
     * Token从指定账æ·è½¬账给目的账户
     *
     * @param _from 来源账户
     * @param _to   目的账户
     * @param _value 金额
     */
    function transferFrom(address _from, address _to, uint256 _value) onlyOwner public {
        _transfer(_from, _to, _value);
    }

    /**
     * 销毁Token
     *
     * @param _from  销毁账户token
     * @param _value 金额
     */
    function burn(address _from, uint256 _value) onlyOwner public returns (bool success) {
        require(balanceOf[_from] >= _value);   
        balanceOf[_from] -= _value;
        totalSupply -= _value;
        Burn(_from, _value);
        return true;
    }

}


