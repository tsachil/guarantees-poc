pragma solidity ^0.4.13;

contract DigitalGuarantee 
{
    enum GuaranteeState { Creating, Created, BankIssued, BeneficiaryChangeMade,Ended }
    GuaranteeState public state;

    //contract personas
    address public _bank;
    address public _customer;
    address public _beneficiary;
    address public _internalAuditor;
    
    //contract public variables
    string public guaranteeCustomerName;
    string public guaranteeBeneficiaryName;
    string public guaranteeStartDate;
    string public guaranteeEndDate;
    uint   public guaranteeAmount;
    string public guaranteeComment;

    //new request variables
    string public requestEndDate;
    uint   public requestAmount;
    string public requestComment;
    
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

    //premissions modifier for beneficiary functions
    modifier onlyBeneficiary() {
        if ( msg.sender != _beneficiary ) {
            loga("###ERROR-not performd by BENEFICIARY address",msg.sender);
            revert();
        }
        loga("#pass BENEFICIARY action check",msg.sender);
        _;
    }

    //premissions modifier for customer functions
    modifier onlyInState(GuaranteeState guaranteeState) {
        if ( state != guaranteeState ) {
            logi("###ERROR-not in guarantee state ",uint(guaranteeState));
            revert();
        }
        logi("#pass guarantee state check",uint(guaranteeState));
        _;
    }

    //general log event
    event log(string log);
    event logs(string log, string data);
    event logi(string log, uint data);
    event loga(string log, address data);

    //------------------------------------------------------------------------//
    
    
    function DigitalGuarantee(address bank, address customer, address beneficiary) {
        _bank = bank;
        _customer = customer;
        _beneficiary = beneficiary;

        state = GuaranteeState.Created;
    }

    //issue a digitalGuarantee
    function bankIssue() { 

        state = GuaranteeState.BankIssued;

    }

    //request to change a digital guarantee
    function changeRequest(uint amount, string endDate, string comment) { 


        requestAmount = amount;
        requestEndDate = endDate;
        //placeholder - to remove all warnings as it was unused otherwise
        requestComment =  comment;
        state = GuaranteeState.BeneficiaryChangeMade;
    }

    
    //end the digital guarantee contract
    function end(string comment)  {
         //placeholder - to remove all warnings as it was unused otherwise
        requestComment = comment;
        state = GuaranteeState.Ended;
    }
}