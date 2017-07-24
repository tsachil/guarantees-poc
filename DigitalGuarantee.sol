pragma solidity ^0.4.10;

import "./GuaranteesInfra.sol";
import "./GuaranteesConstants.sol";
import "./GuaranteeInternal.sol";
import "./GuaranteeRequest.sol";

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

        changeRequested(amount, endDate, comment);                              
        logs("changeRequest","end");                        
    }
    
    //end the digital guarantee contract
    function end(string comment) onlyBank {
        logs("digital guarantee end","start");                        
        DigitalGuarantee guarantee = digitalGuarantees[getBeneficiaryAddress()]; 
        guarantee.issuedGuarantee = issuedGuaranteesData[0];
        guarantee.guaranteeState = GuaranteeState.ended;

        ended(comment);                              
        logs("digital guarantee end","end");                        
    }
}