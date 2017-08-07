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

contract LexBranch is LexingtonBase('LexBranch') {
    enum States { Active, LeftLeafSpecified, RightLeafSpecified }
    States public State;
    address public Owner;
    address public Changer;
    string public Data;
    
    address public LeftLeaf;
    address public RightLeaf;
    
    function LexBranch(string data, address changer) {
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
        ContractUpdated('ModifyData');
    }
    
    function AddLeft(string data, address changer) {
        if (State != States.Active)
            revert();
        LeftLeaf = new LexLeaf(data, changer);
        State = States.LeftLeafSpecified;
        ContractUpdated('AddLeft');
    }
    
    function AddRight(string data, address changer) {
        if (State != States.LeftLeafSpecified)
            revert();
        RightLeaf = new LexLeaf(data, changer);
        State = States.RightLeafSpecified;
        ContractUpdated('AddRight');
    }
    
    function ModifyLeft(string data) {
        if (State == States.Active)
            revert();
        LexLeaf leaf = LexLeaf(LeftLeaf);
        leaf.ModifyData(data);
        ContractUpdated('ModifyLeft');
    }
    
    function ModifyRight(string data) {
        if (State != States.RightLeafSpecified)
            revert();
        LexLeaf leaf = LexLeaf(RightLeaf);
        leaf.ModifyData(data);
        ContractUpdated('ModifyRight');
    }
}