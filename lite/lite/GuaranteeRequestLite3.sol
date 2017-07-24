pragma solidity ^0.4.10;

contract GuaranteeRequestLite3 
{
    //guarantee request states
    enum RequestState { Creating, Created, Submitted, Withdrawaled, Accepted, Rejected }
    RequestState public State;
    //guarantee request personas
    address public _bank;
    address public _customer;
    address public _beneficiary;
    address public _internalAuditor;
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
        if ( msg.sender != _bank ) {
            loga("###ERROR-not performd by BANK address",msg.sender);
            revert();
        }
        loga("#pass BANK action check",msg.sender);
        _;
    }

    //premissions modifier for customer functions
    modifier onlyCustomer() {
        if ( msg.sender != _customer ) {
            loga("###ERROR-not performd by CUSTOMER address",msg.sender);
            revert();
        }
        loga("#pass CUSTOMER action check",msg.sender);
        _;
    }

    //premissions modifier for customer functions
    modifier onlyInState(RequestState requestedState) {
        if ( State != requestedState ) {
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
        _customer=msg.sender;
        _bank = bank;
        _beneficiary = beneficiary;
        //set starting state
        State = RequestState.Created;
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
        State = RequestState.Submitted;
        loga("# customer submit guarantee request ", _customer);
    }

    /**
    * customer withdrawal request can be done at any time
    **/
    function Withdrawal(string comment) {
        requestComment = comment;
        //change the contract state
        State = RequestState.Withdrawaled;
        loga("# customer withdrawal guarantee request ", _customer);
    }

    /**
    * bank reject a guarantee request
    **/
    function Reject(string comment) onlyBank() 
                                    onlyInState(RequestState.Submitted) {
        requestComment=comment;    
        //change the contract state          
        State = RequestState.Rejected;
        loga("# bank reject guarantee request ", _bank);
    }
   
    /**
    * bank accept guarantee request and initiate the internal process contract to proces the request
    **/
    function Accept(string comment)  onlyBank()
                                    onlyInState(RequestState.Submitted) {
        requestComment = comment;

        //initiate internal process contract


        //change the contract state
        State = RequestState.Accepted;
        loga("# bank accept guarantee request ", _bank);
    }

}