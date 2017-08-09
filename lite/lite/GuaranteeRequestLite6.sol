pragma solidity ^0.4.10;

/**
* LexingtonBase contract to allow contract interaction with another contract under the framework
**/
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

contract GuaranteeRequestLite6 is LexingtonBase('GuaranteeRequestLite6') 
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
    string public wordingFile;
    //guarantee request internal variables
    string requestCustomerAddress;
    string requestBeneficiaryAddress;
    string requestWording;

    //premissions modifier for bank functions
    modifier onlyBank() {
        if ( msg.sender != _bank ) {
            guaranteesLog("###ERROR-not performd by BANK address");
            revert();
        }
        guaranteesLog("#pass BANK action check");
        _;
    }

    //premissions modifier for customer functions
    modifier onlyCustomer() {
        if ( msg.sender != _customer ) {
            guaranteesLog("###ERROR-not performd by CUSTOMER address");
            revert();
        }
        guaranteesLog("#pass CUSTOMER action check");
        _;
    }

    //premissions modifier for customer functions
    modifier onlyInState(RequestState requestedState) {
        if ( State != requestedState ) {
            guaranteesLog("###ERROR-not in state ");
            revert();
        }
        guaranteesLog("#pass state check");
        _;
    }

    //general log event
    event guaranteesLog(string log);

    //------------------------------------------------------------------------//

    /**
    * contract constructor
    **/
    function GuaranteeRequestLite6(address bank, address beneficiary) {
        //assign participants      
        _customer=msg.sender;
        _bank = bank;
        _beneficiary = beneficiary;
        //set starting state
        State = RequestState.Created;
        //signaling lexington on the contract creation
        ContractCreated();
        guaranteesLog("# contract GuaranteeRequestLite6 created");
    }

    /**
    * customer submit function to initiat the request for the bank to handle
    **/
    function Submit(uint amount, string startDate, string endDate,
                    string cname, string caddress, string bname,
                    string baddress, string purpose, string wording, string comment, string wordingFileUpload)
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
        wordingFile = wordingFileUpload;
        //change the contract state
        State = RequestState.Submitted;
        //signaling lexington the contract was updated
        ContractUpdated("Submit");
        guaranteesLog("# customer submit guarantee request ");
    }

    /**
    * customer withdrawal request can be done at any time
    **/
    function Withdrawal(string comment) {
        requestComment = comment;
        //change the contract state
        State = RequestState.Withdrawaled;
        //signaling lexington the contract was updated
        ContractUpdated("Withdrawal");
        guaranteesLog("# customer withdrawal guarantee request ");
    }

    /**
    * bank reject a guarantee request
    **/
    function Reject(string comment) onlyBank() 
                                    onlyInState(RequestState.Submitted) {
        requestComment=comment;    
        //change the contract state          
        State = RequestState.Rejected;
        //signaling lexington the contract was updated
        ContractUpdated("Reject");
        guaranteesLog("# bank reject guarantee request ");
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
        //signaling lexington the contract was updated
        ContractUpdated("Accept");
        guaranteesLog("# bank accept guarantee request ");
    }

}