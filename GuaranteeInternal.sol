pragma solidity ^0.4.10;

import "./GuaranteesInfra.sol";
import "./GuaranteesConstants.sol";
import "./DigitalGuarantee.sol";

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

        handling(comment);                             
        logs("handle","end");                        
    }

    //issue a digitalGuarantee
    function issue(string comment) onlyBank
                          inIssueState(IssuanceState.handling) {
              
        //get the submitted request
        logs("issue","start");                        
        IssuedGuarantee guarantee = issuedGuarantees[getCustomerAddress()]; 
        guarantee.issuedUrl = "http://www.google.com/";
        guarantee.comment = comment;
        guarantee.issuanceState = IssuanceState.issued;

        DigitalGuaranteeAsset digital = new DigitalGuaranteeAsset(getCustomerAddress(), getBankAddress(), getBeneficiaryAddress());
        digital.issue();
        loga("digital issue",this);                        
        
        issued(comment);                              
        logs("issue","end");                        
    }

    //reject a guarantee request
    function reject(string comment) onlyBank
                          inIssueState(IssuanceState.handling) {
              
        //get the submitted request
        logs("reject","start");                        
        IssuedGuarantee guarantee = issuedGuarantees[getCustomerAddress()]; 
        guarantee.comment = comment;
        guarantee.issuanceState = IssuanceState.rejected;

        issued(comment);                              
        logs("reject","end");                        
    }
}