pragma solidity ^0.4.20;

import "./Library.sol";
import "./Basic.sol";

// 自动ICO合约
contract AutoApply is Basic {
    // 锁定的token
    struct LockToken {
        uint releaseTime;
        uint value;
        bool valid;
    }
    // 是否开启申购
    bool public canBuy=true;
    // 申购数量
    mapping (address => uint256) public ethDeposit;
    // 锁定的token账户
    mapping (address => LockToken[]) public lockedBalanceOf;

    // 事件通知
    // Token授权消息
    event Grant(address indexed to, uint locktime, uint value);
    // Token解除锁定消息
    event Claim(address indexed to, uint value);
    // 认购
    event Buy(address from, uint value);
    // 退款
    event Refund(address to, uint value);

    /**
     * 初始化
     * @param _initialSupply 发行币供应量
     * @param _tokenName 发行币名
     * @param _tokenSymbol 发行币符号
     */
    function AutoApply(
        uint256 _initialSupply,
        string _tokenName,
        string _tokenSymbol
    ) public Basic(_initialSupply, _tokenName, _tokenSymbol) Owner() { }

    /**
     * 支付
     */
    function () payable public {
        // 存储以太币
        ethDeposit[msg.sender] += msg.value;
        Buy(msg.sender, msg.value);
    }

    /**
     * 退款,由线下操作，仅在此记账
     * @param _to    退款账户地址
     * @param _value 以太币退款
     */
    function refund(address _to, uint _value) onlyOwner public {
        // 账面的金额要够
        require(ethDeposit[_to] >= _value);
        ethDeposit[_to] -= _value;
        // 把以太币转回去
        _to.transfer(_value);
        Refund(_to, _value);
    }

    /**
     * 授予锁定期token, 员工/BTC
     * @param _to 授予账户
     * @param _locktime 锁定时间(从今天开始接下去计算)
     * @param _value token数量
     */
    function grant(address _to, uint _locktime, uint _value) onlyOwner public {
        // 检查是不是够授权
        require(balanceOf[owner] >= _value);
        // 授予锁定token
        lockedBalanceOf[_to].push(LockToken({releaseTime:now+_locktime, value:_value, valid:true}));
        // 扣减owner的token
        balanceOf[owner] -= _value;
        Grant(_to, _locktime, _value);
    }

    /**
     * 根据eth授予锁定期token
     * @param _to       授予账户
     * @param _locktime 锁定时间(从今天开始接下去计算)
     * @param _price    eth和token的比价
     * @param _restrictEth 最大置换金额
     */
    function grantByEthDeposit(address _to, uint _locktime, uint _price, uint _restrictEth) onlyOwner public {
        // 账户里有以太币
        require(ethDeposit[_to] > 0);
        uint amount = Common.min(ethDeposit[_to], _restrictEth) * _price;
        // 默认1个token起置换
        require(amount > 0);
        // 扣除已置换的eth
        ethDeposit[_to] -= Common.min(ethDeposit[_to], _restrictEth);
        grant(_to, _locktime, amount);
    }

    /**
     * 到期解除锁定
     */
    function claim() public {
        _claimTo(msg.sender);
    }

    /**
     * 到期解除锁定
     * @param _to token账户
     */
    function claimTo(address _to) onlyOwner public {
        _claimTo(_to);
    }

    /**
     * 到期解除锁定
     * @param _to token账户
     */
    function _claimTo(address _to) internal {
        LockToken[] storage lockContracts = lockedBalanceOf[_to];
        for( uint i=0; i<lockContracts.length; i+=1) {
            if( lockContracts[i].valid && lockContracts[i].releaseTime <= now ) {
                balanceOf[_to] += lockContracts[i].value;
                lockContracts[i].valid = false;
                Claim(_to, lockContracts[i].value);
            }
        }
    }

    /**
     * 查询账户详情, 如果满足条ä»¶就释放
     */
    function query(address _addr) public returns(uint, uint){
        _claimTo(_addr);
        uint256 lockedBalance=0;
        LockToken[] storage lockContracts = lockedBalanceOf[_addr];
        for( uint i=0; i<lockContracts.length; i+=1) {
            if( lockContracts[i].valid ) {
                lockedBalance += lockContracts[i].value;
            }
        }
        return (balanceOf[_addr], lockedBalance);
    }

    /**
     * 是否开放申购
     * @param cb 是否开放申购
     */
    function openBuy(bool cb) onlyOwner public {
        canBuy = cb;
    }

}

