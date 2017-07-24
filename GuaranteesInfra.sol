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
