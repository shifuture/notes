pragma solidity ^0.4.20;

library Common {

    // Token小数转化为整数, 官方文档墙裂建议18, 不要改, 单位:WEI
    function toWei() pure internal returns(uint) {
        return 10 ** uint256(18);
    }

    // 小值
    function min(uint x, uint y) pure internal returns(uint) {
        if (x > y) {
            return y;
        } else {
            return x;
        }
    }

    // 大值
    function max(uint x, uint y) pure internal returns(uint) {
        if (x > y) {
            return x;
        } else {
            return y;
        }
    }
}


