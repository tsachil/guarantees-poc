pragma solidity ^0.4.13;

contract GuaranteeInternal 
{
    enum InternalState { Creating, Created, Handling, Issued, Rejected }
    InternalState public state;

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
    
    //contract payment variables

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
    modifier onlyInState(InternalState internalState) {
        if ( state != internalState ) {
            logi("###ERROR-not in state ",uint(internalState));
            revert();
        }
        logi("#pass state check",uint(internalState));
        _;
    }

    //general log event
    event log(string log);
    event logs(string log, string data);
    event logi(string log, uint data);
    event loga(string log, address data);

    //------------------------------------------------------------------------//
   
    
    function GuaranteeInternal(address bank, address customer) {
        _bank = bank;
        _customer = customer;

        state = InternalState.Created;
    }
    
    //handle a guarantee request
    function handle(string comment) {
        //get the submitted request

        requestComment = comment;         
        state = InternalState.Handling;
    }


    //issue a digitalGuarantee
    function issue(string comment)  {
        state = InternalState.Issued;
        requestComment=comment;
    }

    //reject a guarantee request
    function reject(string comment) {
        state = InternalState.Rejected;
        requestComment=comment;              
    }

    
}