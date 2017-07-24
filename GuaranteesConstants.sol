pragma solidity ^0.4.10;

import "./GuaranteesInfra.sol";
//###
//general constants, methods and utillities for the guarantees process contracts
//###
contract GuaranteesConstants is owned {
    //***
    //*** VARIABLES
    //***
    
    //holds the addresses of the participating parties for demo reasons
    struct Addresses {
        address bank;
        address customer;
        address beneficiary;
    }
    Addresses public addresses;

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
     
        RequestState state;
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
    //guarantee issuance states
    enum IssuanceState { handling, issued, rejected }
    //digital guarantee states
    enum GuaranteeState { bankIssued, beneficieryChangeRequest, ended }

    //***
    //*** MODIFIERS
    //***
    //premissions modifier for bank functions
    modifier onlyBank() {
        if ( msg.sender != addresses.bank ) {
            loga("###ERROR-not performd by BANK address",msg.sender);
            throw;
        }
        loga("#pass BANK action check",msg.sender);
        _;
    }

    //premissions modifier for customer functions
    modifier onlyCustomer() {
        if ( msg.sender != addresses.customer ) {
            loga("###ERROR-not performd by CUSTOMER address",msg.sender);
            throw;
        }
        loga("#pass CUSTOMER action check",msg.sender);
        _;
    }

    //premissions modifier for beneficiary functions
    modifier onlyBeneficiary() {
        if ( msg.sender != addresses.beneficiary ) {
            loga("###ERROR-not performd by BENEFICIERY address",msg.sender);            
            throw;
        }
        loga("#pass BENEFICIERY action check",msg.sender);
        _;
    }
    
    //***
    //*** FUNCTIONS
    //***
    //@TODO protect this function so only the bank can assign its addresses
    function setBankAddress(address bank) {
        loga("set bank address",bank);
        addresses.bank = bank;
    }

    function getBankAddress() returns (address) {
        return addresses.bank;
    }

    //@TODO protect this function so only the customer can assign its addresses
    function setCustomerAddress(address customer) {
        loga("set customer address",customer);
        addresses.customer = customer;
    }

    function getCustomerAddress() returns (address) {
        return addresses.customer;
    }

    //@TODO protect this function so only the beneficiary can assign its addresses
    function setBeneficiaryAddress(address beneficiary) {
        loga("set beneficiary address",beneficiary);
        addresses.beneficiary = beneficiary;
    }
    
    function getBeneficiaryAddress() returns (address) {
        return addresses.beneficiary;
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
        loga("bank",addresses.bank);
        loga("customer",addresses.customer);
        loga("beneficiary",addresses.beneficiary);
        return msg.sender;
    }
}