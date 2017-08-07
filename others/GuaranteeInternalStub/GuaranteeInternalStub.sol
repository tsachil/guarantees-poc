pragma solidity ^0.4.10;

contract LexingtonBase {
    event LexingtonContractCreated(string contractType, address originatingAddress);
    event LexingtonContractUpdated(string contractType, string action, address originatingAddress);
    
    string ContractType;

    function LexingtonBase(string contractType) {
        ContractType = contractType;
    }

    function ContractCreated() {
        LexingtonContractCreated(ContractType, msg.sender);
    }

    function ContractUpdated(string action) {
        LexingtonContractUpdated(ContractType, action, msg.sender);
    }
}

contract GuaranteeInternalStub  is LexingtonBase('GuaranteeInternalStub')
{
    enum IssuanceState { Creating,Created,Handling, Issued, Rejected }
    IssuanceState public State;

    address public Bank;
    address public Customer;
    address public Beneficiary;
    address public InternalAuditor;


    string public CustomerName;
    string public BeneficiaryName;
    string public StartDate;
    string public EndDate;
    uint public Amount;
    string public Comment;
    
    
    function GuaranteeInternalStub(address bank, address customer) 
    {
        Bank=bank;
        Customer=customer;
        //Beneficiary=beneficiary;

        State = IssuanceState.Created;
        ContractCreated();
    }
    
    //handle a guarantee request
    function Handle(string comment) {
        //get the submitted request
    
        Comment=comment;
        State = IssuanceState.Handling;
        /*When updating state */
	    ContractUpdated("Handle");          
    
    }


    //issue a digitalGuarantee
    function Issue(string comment)  {
        State = IssuanceState.Issued;
        Comment=comment;
    
        /*When updating state */
	    ContractUpdated("Issue");  
    }

    //reject a guarantee request
    function Reject(string comment) {
        State = IssuanceState.Rejected;
        Comment=comment;          
        /*When updating state */
	    ContractUpdated("Reject");     
    }

    
}