pragma solidity ^0.4.10;

contract GuaranteeRequestLite3 
{
    //guarantee request states
    enum RequestState { Creating, Created, Submitted, Withdrawaled, Accepted, Rejected }
    RequestState public requestState;
    //guarantee request personas
    address public Bank;
    address public Customer;
    address public Beneficiary;
    address public InternalAuditor;
    //guarantee request public variables
    string public requestCustomerName;
    string public requestBeneficiaryName;
    string public requestStartDate;
    string public requestEndDate;
    uint   public requestAmount;
    string public requestComment;
    string public requestPurpose;
    //guarantee request internal variables
    string requestCustomerAddress;
    string requestBeneficiaryAddress;
    string requestWording;

    //premissions modifier for bank functions
    modifier onlyBank() {
        if ( msg.sender != Bank ) {
            loga("###ERROR-not performd by BANK address",msg.sender);
            revert();
        }
        loga("#pass BANK action check",msg.sender);
        _;
    }

    //premissions modifier for customer functions
    modifier onlyCustomer() {
        if ( msg.sender != Customer ) {
            loga("###ERROR-not performd by CUSTOMER address",msg.sender);
            revert();
        }
        loga("#pass CUSTOMER action check",msg.sender);
        _;
    }

    //premissions modifier for customer functions
    modifier onlyInState(RequestState requestedState) {
        if ( requestState != requestedState ) {
            logi("###ERROR-not in state ",uint(requestedState));
            revert();
        }
        logi("#pass state check",uint(requestedState));
        _;
    }

    //general log event
    event log(string log);
    event logs(string log, string data);
    event logi(string log, uint data);
    event loga(string log, address data);

    //------------------------------------------------------------------------//

    /**
    * contract constructor
    **/
    function GuaranteeRequestLite3(address bank, address beneficiary) {
        //assign participants      
        Customer=msg.sender;
        Bank = bank;
        Beneficiary = beneficiary;
        //set starting state
        requestState = RequestState.Created;
        log("# contract GuaranteeRequestLite3 created");
    }

    /**
    * customer submit function to initiat the request for the bank to handle
    **/
    function Submit(uint amount, string startDate, string endDate,
                    string cname, string caddress, string bname,
                    string baddress, string purpose, string wording, string comment)
                    onlyCustomer()
                    onlyInState(RequestState.Created) {

        //assign input variables to be processed                        
        requestAmount = amount;
        requestStartDate=startDate;
        requestEndDate = endDate;
        requestCustomerName = cname;
        requestCustomerAddress = caddress;
        requestBeneficiaryName = bname;
        requestBeneficiaryAddress = baddress;
        requestPurpose = purpose;
        requestComment = comment;
        requestWording = wording;
        //change the contract state
        requestState = RequestState.Submitted;
        loga("# customer submit guarantee request ", Customer);
    }

    /**
    * customer withdrawal request can be done at any time
    **/
    function Withdrawal(string comment) {
        requestComment = comment;
        //change the contract state
        requestState = RequestState.Withdrawaled;
        loga("# customer withdrawal guarantee request ", Customer);
    }

    /**
    * bank reject a guarantee request
    **/
    function Reject(string comment) onlyBank() 
                                    onlyInState(RequestState.Submitted) {
        requestComment=comment;    
        //change the contract state          
        requestState = RequestState.Rejected;
        loga("# bank reject guarantee request ", Bank);
    }
   
    /**
    * bank accept guarantee request and initiate the internal process contract to proces the request
    **/
    function Accept(string comment)  onlyBank()
                                    onlyInState(RequestState.Submitted) {
        requestComment = comment;

        //initiate internal process contract


        //change the contract state
        requestState = RequestState.Accepted;
        loga("# bank accept guarantee request ", Bank);
    }

}