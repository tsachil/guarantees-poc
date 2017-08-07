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

contract DigitalGuaranteeStub  is LexingtonBase('DigitalGuaranteeStub')
{
    //enum PackageState { Creating, Created, TransitionRequestPending, InTransit, FinalDelivery, Completed, OutOfCompliance }
    //PackageState public State;
    enum GuaranteeState { Creating, Created, BankIssued, BeneficiaryChangeMade,Ended }
    GuaranteeState public State;

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
    
    
    function DigitalGuaranteeStub(address bank, address customer, address beneficiary) 
    {
        Bank=bank;
        Customer=customer;
        Beneficiary=beneficiary;

        State = GuaranteeState.Created;
        ContractCreated();
               
    }
    //issue a digitalGuarantee
    function Issue() { 

        State = GuaranteeState.BankIssued;
        /*When updating state */
	    ContractUpdated("Issue");
    }

    //request to change a digital guarantee
    function ChangeRequest(uint amount, string endDate, string comment) { 


        Amount = amount;
        EndDate = endDate;
        //placeholder - to remove all warnings as it was unused otherwise
        Comment =  comment;
        State = GuaranteeState.BeneficiaryChangeMade;
        /*When updating state */
	    ContractUpdated("ChangeRequest");
    }

    
    //end the digital guarantee contract
    function End(string comment)  {
         //placeholder - to remove all warnings as it was unused otherwise
        Comment = comment;
        State = GuaranteeState.Ended;
	    ContractUpdated("End");
    }
}