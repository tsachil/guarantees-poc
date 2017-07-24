pragma solidity ^0.4.10;

import "./GuaranteesInfra.sol";
import "./GuaranteesConstants.sol";
import "./GuaranteeInternal.sol";

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
        if ( customerRequest[getCustomerAddress()].state != _state ) {
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
        customerRequestData.state = RequestState.submitted;

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
        customerRequestData.state = RequestState.withdrawaled;
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
        customerRequestData.state = RequestState.rejected;
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
        customerRequestData.state = RequestState.accepted;
        customerRequestData.comment = comment;
        //call the Guarantee contract
        GuaranteeInternal guarantee = new GuaranteeInternal(getCustomerAddress(), getBankAddress());
        guarantee.handle(comment);
        accepted(comment);
        loga("accept",this);                        
        logs("accept","end");                        
        return this;
    }
    
    
}