pragma solidity ^0.4.10;

contract GuaranteeRequestStub 
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
    }
    


    //submit function to initiat the request
    function Submit(uint amount, string startDate, string endDate,
                    string cname, address caddress, string bname,
                    address baddress, string purpose, string wording, string comment) 
        {
            State = RequestState.Submitted;
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
    }

    //customer withdrawal request
    function Withdrawal(string comment) {
        State = RequestState.Withdrawaled;
        Comment = comment;
 
    }


    //***
    //*** BANK functions and events
    //***
    //reject a guarantee request
    function Reject(string comment) {
        State = RequestState.Rejected;
        Comment=comment;              
    }
   
    //bank accept request
    function Accept(string comment)  {
        State = RequestState.Accepted;
        Comment = comment;

    }
 
    
}