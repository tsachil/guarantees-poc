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
contract GuaranteeRequestStub is LexingtonBase('GuaranteeRequestStub')
{
    //enum IssuanceState { Creating,Created,Handling, Issued, Rejected }
    //IssuanceState public State;
    //guarantee request states
    enum RequestState { Creating, Created, Submitted, Withdrawaled, Accepted, Rejected }
    RequestState public State;

    address public Bank;
    address public Customer;
    address public Beneficiary;
    address public InternalAuditor;


    string public CustomerName;
    string public BeneficiaryName;
    string public StartDate;
    string public EndDate;
    uint public Amount;
    string public Wording;
    string public Comment;
    string public Purpose;
    
    function GuaranteeRequestStub() 
    {
        
        Customer=msg.sender;
        //Beneficiary=beneficiary;

        State = RequestState.Created;
        ContractCreated();
    }
    


    //submit function to initiat the request
    function Submit(uint amount, string startDate, string endDate,
                    string cname, address caddress, string bname,
                    address baddress, string purpose, string wording, string comment) 
        {
            Amount = amount;
            StartDate=startDate;
            EndDate = endDate;
            CustomerName = cname;
            Customer = caddress;
            BeneficiaryName = bname;
            Beneficiary = baddress;
            Purpose = purpose;
            Comment = comment;
            Wording = wording;
            State = RequestState.Submitted;
         	/*When updating state */
	        ContractUpdated("Submit");

    }

    //customer withdrawal request
    function Withdrawal(string comment) {
        Comment = comment;
        State = RequestState.Withdrawaled;
        ContractUpdated("Withdrawal");
    
    }


    //***
    //*** BANK functions and events
    //***
    //reject a guarantee request
    function Reject(string comment) {
         Comment=comment;              
         State = RequestState.Rejected;
         ContractUpdated("Rejected");
       }
   
    //bank accept request
    function Accept(string comment)  {
        Comment = comment;
        State = RequestState.Accepted;
        ContractUpdated("Accepted");
    }
 
    
}