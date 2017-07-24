pragma solidity ^0.4.10;

contract GuaranteeRequest {
    
    //contract states
    enum RequestState { Creating, Created, Submitted, Withdrawaled, Accepted, Rejected }
    RequestState public state;
    
    //contract personas
    address public _bank;
    address public _customer;
    address public _beneficiary;
    address public _internalAuditor;
    
    //contract public variables
    string public requestCustomerName;
    string public requestBeneficiaryName;
    string public requestStartDate;
    string public requestEndDate;
    uint   public requestAmount;
    string public requestComment;
    string public requestPurpose;
    //contract internal variables
    string requestBeneficiaryAddress;
    string requestCustomerAddress;
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
        if ( state != requestedState ) {
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
    
    //constructor    
    function GuaranteeRequest(address bank, address beneficiary) {
        //assign customer id for this contract instance
        _customer=msg.sender;
        _bank = bank;
        _beneficiary = beneficiary;
        //assign initial state as created
        state = RequestState.Created;
    }
    
    //submit function to initiat the request
    function submit(uint amount, string startDate, string endDate,
                    string customerName, string customerAddress, string beneficiaryName,
                    string beneficiaryAddress, string purpose, string wording, string comment) 
                    onlyCustomer
                    onlyInState(RequestState.Created) {
                                    
        //populate the request data
        requestAmount = amount;
        requestStartDate=startDate;
        requestEndDate = endDate;
        requestCustomerName = customerName;
        requestBeneficiaryName = beneficiaryName;
        requestPurpose = purpose;
        requestComment = comment;

        requestBeneficiaryAddress = beneficiaryAddress;
        requestCustomerAddress = customerAddress;
        requestWording = wording;
        
        state = RequestState.Submitted;
        logs("#submitted",comment);
    }

    //customer withdrawal his request
    function withdrawal(string comment) onlyCustomer {
        requestComment = comment;
        state = RequestState.Withdrawaled;
        logs("#withdrawaled",comment);
     }

    //reject a guarantee request
    function reject(string comment) onlyBank 
                                    onlyInState(RequestState.Submitted) {
        requestComment = comment;
        state = RequestState.Rejected;
        logs("#rejected",comment);
    }
   
    //bank accept request
    function accept(string comment) onlyBank
                                    onlyInState(RequestState.Submitted) {
        requestComment = comment;
        state = RequestState.Accepted;
        logs("#accepted",comment);
    }
 
}