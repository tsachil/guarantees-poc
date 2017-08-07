pragma solidity ^0.4.10;

contract LexingtonBase {
    event LexingtonContractCreated(string contractType, address originatingAddress);
    event LexingtonContractUpdated(string contractType, string action, address originatingAddress);
    
    string internal ContractType;

    function LexingtonBase(string contractType) internal {
        ContractType = contractType;
    }

    function ContractCreated() internal {
        LexingtonContractCreated(ContractType, msg.sender);
    }

    function ContractUpdated(string action) internal {
        LexingtonContractUpdated(ContractType, action, msg.sender);
    }
}

contract LexLeaf is LexingtonBase('LexLeaf') {
    enum States { Active, Modified }
    address public Owner;
    address public Changer;
    States public State;
    string public Data;
    
    function LexLeaf(string data, address changer) {
        Owner = msg.sender;
        Data = data;
        State = States.Active;
        Changer = changer;
        ContractCreated();
    }
    
    function ModifyData(string data) {
        if (msg.sender != Changer && msg.sender != Owner)
            revert();
        Data = data;
        State = States.Modified;
        ContractUpdated('ModifyData');
    }
}