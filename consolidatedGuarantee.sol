pragma solidity ^0.4.10;

//###
// general contract for better operations of the system
//###
contract owned {
    //owner address for ownership validation
    address owner;

    //constractor to verify real owner assignment
    function owned() { 
        owner = msg.sender; 
        log("owner=",owner);
    }
    
    //owner check modifier
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    //contract distruction by owner only
    function close() onlyOwner {
        log("##contract closed by owner=",owner);
        selfdestruct(owner);
    }
    //log event for debug purposes    
    event log(string loga, address logb);
}

//###
//general constants, methods and utillities for the guarantees process contracts
//###
contract GuaranteesConstants is owned {
    //***
    //*** GLOBAL VARIABLES
    //***
    address public bank;
    address public customer;
    address public beneficiary;
    
    string public customerName;
    string public beneficiaryName;
    string public startDate;
    string public endDate;
    uint public amount;
    
    //describes the customer object    
    struct Customer {
        string name;
        string localAddress;
        string id;
    }
    //holds all customers by their address
    mapping (address=>Customer) public customers;
    
    //describes the beneficiary object    
    struct Beneficiary {
        string name;
        string localAddress;
        string id;
    }
    //holds all the benefiieries by their address
    mapping (address=>Beneficiary) public beneficiaries;

    //describes the guarantee request object    
    struct RequestData {
        uint amount;
        string startDate;
        string endDate;
        Customer customer;
        Beneficiary beneficiary;
        string purpose;
        WordingType wordingType;
        string wording;
        string comment;
     
        RequestState requestState;
    }
    //holds all requests by their index number
    mapping (uint=>RequestData) requestData;

    //describes the guarantee payments options
    struct GuaranteePayment {
        string paymentSchedule;
        uint interestBaseCalculation;
        string paymentFrequency;
        string paymentStartDate;
        uint numberOfPayments;
        uint commission;
        uint paymentAmount;
        string accountToDebit;
        uint fees;
        string approvalDetails;
        LineOfCredit lineOfCredit;
        string lineOfCreditApprovalDetails;
        string legalCouncilApprovalDetails;
    }
    //holds all assigned payments options by their index number
    mapping (uint=>GuaranteePayment) paymentsData;

    //describes the guarantee object (after issuance)
    struct IssuedGuarantee {
        RequestData guaranteeRequest;
        uint indexation;
        string specialConditions;
        string idemnificationWording;
        string issuedUrl;
        string comment;
        GuaranteePayment guaranteePayment;
        IssuanceState issuanceState;
    }
    //hold all issued guarantees by their index number
    mapping(uint => IssuedGuarantee) issuedGuaranteesData;

    //describes the digital guarantee 
    struct DigitalGuarantee {
        IssuedGuarantee issuedGuarantee;
        uint amountChange;
        string endDateChange;
        string comment;
        GuaranteeState guaranteeState;
    }
    //hold all digital guarantees by their index number
    mapping(uint => DigitalGuarantee) digitalGuarantees;

    //line of credit options
    enum LineOfCredit { yes, no, notSufficient}
    //guarantee request wording type
    enum WordingType { standard, customerIssued, beneficiaryIssued}

    //##
    //guarantees contracts states
    //##
    //guarantee request states
    enum RequestState { created, submitted, withdrawaled, accepted, rejected }
    RequestState public requestState;
    
    //guarantee issuance states
    enum IssuanceState { handling, issued, rejected }
    IssuanceState public issuanceState;
    
    //digital guarantee states
    enum GuaranteeState { bankIssued, beneficieryChangeRequest,ended }
    GuaranteeState public guaranteeState;

    //***
    //*** MODIFIERS
    //***
    //premissions modifier for bank functions
    modifier onlyBank() {
        if ( msg.sender != bank ) {
            loga("###ERROR-not performd by BANK address",msg.sender);
            throw;
        }
        loga("#pass BANK action check",msg.sender);
        _;
    }

    //premissions modifier for customer functions
    modifier onlyCustomer() {
        if ( msg.sender != customer ) {
            loga("###ERROR-not performd by CUSTOMER address",msg.sender);
            throw;
        }
        loga("#pass CUSTOMER action check",msg.sender);
        _;
    }

    //premissions modifier for beneficiary functions
    modifier onlyBeneficiary() {
        if ( msg.sender != beneficiary ) {
            loga("###ERROR-not performd by BENEFICIERY address",msg.sender);            
            throw;
        }
        loga("#pass BENEFICIERY action check",msg.sender);
        _;
    }
    
    //***
    //*** FUNCTIONS
    //***
    function globalUpdate(uint u_amount, string cname, string bname, string sdate, 
                           string edate) {
        amount = u_amount;
        customerName = cname;
        beneficiaryName = bname;
        startDate = sdate;
        endDate = edate;
    }
    
    
    
    //@TODO protect this function so only the bank can assign its addresses
    function setBankAddress(address _bank) {
        loga("set bank address",_bank);
        bank = _bank;
    }

    function getBankAddress() returns (address) {
        return bank;
    }

    //@TODO protect this function so only the customer can assign its addresses
    function setCustomerAddress(address _customer) {
        loga("set customer address",_customer);
        customer = _customer;
    }

    function getCustomerAddress() returns (address) {
        return customer;
    }

    //@TODO protect this function so only the beneficiary can assign its addresses
    function setBeneficiaryAddress(address _beneficiary) {
        loga("set beneficiary address",_beneficiary);
        beneficiary = _beneficiary;
    }
    
    function getBeneficiaryAddress() returns (address) {
        return beneficiary;
    }

    //temp constractor to handle parties address assignemnt for test
    //@TODO remove assignments from this contract and into the sub contracts
    function GuaranteesConstants() {
        logs("GuaranteesConstants","start");
        setBankAddress(msg.sender);
        setCustomerAddress(msg.sender);
        setBeneficiaryAddress(msg.sender);
        logs("GuaranteesConstants","end");
    }

    //general log event
    event logs(string log, string data);
    event logi(string log, uint data);
    event loga(string log, address data);

    function whoami() returns(address){
        loga("whoami",msg.sender);
        loga("bank",bank);
        loga("customer",customer);
        loga("beneficiary",beneficiary);
        return msg.sender;
    }
}

//###
//customer request contract
//###
contract GuaranteeRequest is GuaranteesConstants{
    string public version = "1.01";
    //***
    //*** VARIABLES, types and states
    //***
    //holds customer request data by address
    mapping(address => RequestData) customerRequest;
    
    //request state modifier 
    modifier inRequestState(RequestState _state) {
        logi("inRequestState",uint(_state));
        if ( customerRequest[getCustomerAddress()].requestState != _state ) {
            logi("###ERROR - not in state",uint(_state));
            throw;
        }
        logi("#in state",uint(_state));
        _;
    }
    
    //***
    //*** CUSTOMER functions and events
    //***
    //constractor for request initiation, setting the customer address
    function GuaranteeRequest() {
        logs("GuaranteeRequest","");
        //set the current customer address
        setCustomerAddress(msg.sender);
    }

    //submit function to initiat the request
    function submit(uint amount, string startDate, string endDate,
                    string cname, string caddress, string bname,
                    string baddress, string purpose, string wording, string comment) 
                    onlyCustomer
                    inRequestState(RequestState.created){
        logi("amount",amount);
        logs("startDate",startDate);                        
        logs("endDate",endDate);                        
        logs("cname",cname);                        
        logs("caddress",caddress);                        
        logs("bname",bname);                        
        logs("baddress",baddress);                        
        logs("purpose",purpose);                        
        logs("wording",wording);                        
        logs("comment",comment);                        
        
        //craete the first contract
        RequestData customerRequestData = customerRequest[getCustomerAddress()]; 
        customerRequestData.amount = amount;
        customerRequestData.startDate = startDate;
        customerRequestData.endDate = endDate;
        customerRequestData.purpose = purpose;
        customerRequestData.wordingType = WordingType.customerIssued;
        customerRequestData.wording = wording;
        customerRequestData.customer.name = cname;
        customerRequestData.customer.localAddress = caddress;
        customerRequestData.beneficiary.name = bname;
        customerRequestData.beneficiary.localAddress = baddress;
        customerRequestData.comment = comment;
        customerRequestData.requestState = RequestState.submitted;
        requestState = RequestState.submitted;

        globalUpdate(amount, cname, bname, startDate, endDate);
        submitted(comment);
        logs("submitted","end");                        
    }
    event submitted(string comment);    

    event withdrawaled(string comment);
    //customer withdrawal request
    function withdrawal(string comment) onlyCustomer
                          inRequestState(RequestState.submitted) {

        //get the submitted request
        logs("withdrawal","start");                        
        RequestData customerRequestData = customerRequest[getCustomerAddress()]; 
        customerRequestData.requestState = RequestState.withdrawaled;
        requestState = RequestState.withdrawaled;
        customerRequestData.comment = comment;

        withdrawaled(comment);
        logs("withdrawal","end");                        
    }


    //***
    //*** BANK functions and events
    //***
    event rejected(string comment);
    //bank reject request
    function reject(string comment) onlyBank
                      inRequestState(RequestState.submitted) {
        logs("reject","start");                        
        //get the submitted request
        RequestData customerRequestData = customerRequest[getCustomerAddress()]; 
        customerRequestData.requestState = RequestState.rejected;
        requestState = RequestState.rejected;
        customerRequestData.comment = comment;
        
        rejected(comment);
        logs("reject","end");                        
    }
    
    event accepted(string comment);
    //bank accept request
    function accept(string comment) onlyBank 
                      inRequestState(RequestState.submitted) returns (address){
        logs("accept","start");     
        RequestData customerRequestData = customerRequest[getCustomerAddress()]; 
        customerRequestData.requestState = RequestState.accepted;
        requestState = RequestState.accepted;
        customerRequestData.comment = comment;
        //call the Guarantee contract
        GuaranteeInternal guarantee = new GuaranteeInternal(getCustomerAddress(), getBankAddress());
        //guarantee.handle(comment);
        accepted(comment);
        loga("accept",this);                        
        logs("accept","end");                        
        return this;
    }
    
    
}
//###
//bank internal process contract for handling the gurantee request
//###
contract GuaranteeInternal is GuaranteesConstants {
    //holds all issed guarantees by address
    mapping(address => IssuedGuarantee) issuedGuarantees;

    //initializing the internal guarantee contract
    function GuaranteeInternal(address customerAddress, address bankAddress) {
        logs("GuaranteeInternal","start");                        
        setBankAddress(bankAddress);
        setCustomerAddress(customerAddress);
        IssuedGuarantee issuedGuarantee = issuedGuarantees[customerAddress];
        issuedGuarantee.guaranteeRequest = requestData[0];
        logs("GuaranteeInternal","end");                        
    }

    //issue state modifier 
    modifier inIssueState(IssuanceState _state) {
        logi("inIssueState",uint(_state));
        if ( issuedGuarantees[getCustomerAddress()].issuanceState != _state ) {
            logi("###ERROR - not in issue state",uint(_state));
            throw;
        }
        logi("#in issue state",uint(_state));
        _;
    }

    event handling(string comment);
    event issued(string comment);
    event rejected(string comment);

    //handle a guarantee request
    function handle(string comment) onlyBank {
        //get the submitted request
        logs("handle","start");                        
        IssuedGuarantee guarantee = issuedGuarantees[getCustomerAddress()]; 
        guarantee.comment = comment;
        guarantee.issuanceState = IssuanceState.handling;
        issuanceState = IssuanceState.handling;

        handling(comment);                             
        logs("handle","end");                        
    }

    //issue a digitalGuarantee
    function issue(string comment) onlyBank {
                          //inIssueState(IssuanceState.handling) {
              
        //get the submitted request
        logs("issue","start");                        
        IssuedGuarantee guarantee = issuedGuarantees[getCustomerAddress()]; 
        guarantee.issuedUrl = "http://www.google.com/";
        guarantee.comment = comment;
        guarantee.issuanceState = IssuanceState.issued;
        issuanceState = IssuanceState.issued;
        DigitalGuaranteeAsset digital = new DigitalGuaranteeAsset(getCustomerAddress(), getBankAddress(), getBeneficiaryAddress());
        //digital.issue();
        loga("digital issue",this);                        
        
        issued(comment);                              
        logs("issue","end");                        
    }

    //reject a guarantee request
    function reject(string comment) onlyBank {
                          //inIssueState(IssuanceState.handling) {
              
        //get the submitted request
        logs("reject","start");                        
        IssuedGuarantee guarantee = issuedGuarantees[getCustomerAddress()]; 
        guarantee.comment = comment;
        guarantee.issuanceState = IssuanceState.rejected;
        issuanceState = IssuanceState.rejected;

        issued(comment);                              
        logs("reject","end");                        
    }
}


//###
//digital guarantee asset contract
//###
contract DigitalGuaranteeAsset is GuaranteesConstants {
    //holds all issued guarantees by address
    mapping(address => DigitalGuarantee) digitalGuarantees;

    //initializing the internal guarantee contract
    function DigitalGuaranteeAsset(address customerAddress, address bankAddress, address beneficiaryAddress) {
        logs("DigitalGuarantee","start");                        
        setBankAddress(bankAddress);
        setCustomerAddress(customerAddress);
        setBeneficiaryAddress(beneficiaryAddress);
        logs("DigitalGuarantee","end");                        
    }

    //issue state modifier 
    modifier inGuaranteeState(GuaranteeState _state) {
        logi("inGuaranteeState",uint(_state));
        if ( digitalGuarantees[getBeneficiaryAddress()].guaranteeState != _state ) {
            logi("###ERROR - not in guarantee state",uint(_state));
            throw;
        }
        logi("#in guarantee state",uint(_state));
        _;
    }

    event issued();
    event changeRequested(uint amount, string endDate, string comment);
    event ended(string comment);

    //issue a digitalGuarantee
    function issue() onlyBank {
        logs("digital guarantee issue","start");                        
        DigitalGuarantee guarantee = digitalGuarantees[getBeneficiaryAddress()]; 
        guarantee.issuedGuarantee = issuedGuaranteesData[0];
        guarantee.guaranteeState = GuaranteeState.bankIssued;
        guaranteeState = GuaranteeState.bankIssued;

        issued();                              
        logs("digital guarantee issue","end");                        
    }

    //request to change a digital guarantee
    function changeRequest(uint amount, string endDate, string comment) onlyBeneficiary
                          inGuaranteeState(GuaranteeState.bankIssued) {
              
        //get the submitted request
        logs("changeRequest","start");                        
        DigitalGuarantee guarantee = digitalGuarantees[getBeneficiaryAddress()]; 
        guarantee.comment = comment;
        guarantee.guaranteeState = GuaranteeState.beneficieryChangeRequest;
        guaranteeState = GuaranteeState.beneficieryChangeRequest;
        changeRequested(amount, endDate, comment);                              
        logs("changeRequest","end");                        
    }
    
    //end the digital guarantee contract
    function end(string comment) onlyBank {
        logs("digital guarantee end","start");                        
        DigitalGuarantee guarantee = digitalGuarantees[getBeneficiaryAddress()]; 
        guarantee.issuedGuarantee = issuedGuaranteesData[0];
        guarantee.guaranteeState = GuaranteeState.ended;
        guaranteeState = GuaranteeState.ended;
        ended(comment);                              
        logs("digital guarantee end","end");                        
    }
}