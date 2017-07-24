pragma solidity ^0.4.10;

contract GuaranteeInternalStub 
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
    }
    
    //handle a guarantee request
    function Handle(string comment) {
        //get the submitted request
    
        State = IssuanceState.Handling;
        Comment=comment;         
    }


    //issue a digitalGuarantee
    function Issue(string comment)  {
        State = IssuanceState.Issued;
        Comment=comment;
    }

    //reject a guarantee request
    function Reject(string comment) {
        State = IssuanceState.Rejected;
        Comment=comment;              
    }

    
}