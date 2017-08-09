pragma solidity ^0.4.10;

contract DigitalLocker
{
    enum LockerState { Requested, DocumentReview, AvailableToShare, SharingRequestPending, SharingWithThirdParty, Terminated }
    address public Owner;
    address public BankAgent;
    string public LockerFriendlyName;
    string public LockerIdentifier;
    address public CurrentAuthorizedUser;   
    string public ExpirationDate;
    string public Image;
    address public ThirdPartyRequestor;
    string public IntendedPurpose;
    string public LockerStatus;
    string public RejectionReason;
    LockerState public State;
    function DigitalLocker(string lockerFriendlyName) 
    {
        Owner = msg.sender;
        LockerFriendlyName = lockerFriendlyName;
        State = LockerState.DocumentReview;
    }
    function BeginReviewProcess() 
    {
        /* Need to update, likely with registry to confirm sender is agent
        Also need to add a function to re-assign the agent.
        */
     if (Owner == msg.sender)
        {
            revert();
        }
        BankAgent = msg.sender;

        LockerStatus = "Pending";
        State = LockerState.DocumentReview;
    }
    function RejectApplication(string rejectionReason) 
    {
     if (BankAgent != msg.sender)
        {
            revert();
        }

        RejectionReason = rejectionReason;
        LockerStatus = "Rejected";
        State = LockerState.DocumentReview;
    }
    function UploadDocuments(string lockerIdentifier, string image)
    {
         if (BankAgent != msg.sender)
        {
            revert();
        }
            LockerStatus = "Approved";
            Image = image;
            LockerIdentifier = lockerIdentifier;
            State = LockerState.AvailableToShare;
    
    }
    function ShareWithThirdParty(address thirdParty, string expirationDate, string intendedPurpose)
    {
        if (Owner != msg.sender)
        {
            revert();
        }
        CurrentAuthorizedUser = thirdParty;
        LockerStatus ="Shared" ;
        IntendedPurpose = intendedPurpose;
        ExpirationDate = expirationDate;
        State = LockerState.SharingWithThirdParty;
    }
    function AcceptSharingRequest()
    {
        if (Owner != msg.sender)
        {
            revert();
        }
        CurrentAuthorizedUser = ThirdPartyRequestor;
        State = LockerState.SharingWithThirdParty;
    }
    function RejectSharingRequest()
    {
        if (Owner != msg.sender)
        {
            revert();
        }
            LockerStatus ="Available";
            CurrentAuthorizedUser=0x0;
            State = LockerState.AvailableToShare;
    }
    function RequestLockerAccess(string intendedPurpose)
    {
        
        if (Owner == msg.sender)
        {
            revert();
        }
        ThirdPartyRequestor = msg.sender;
        IntendedPurpose=intendedPurpose;
        State = LockerState.SharingRequestPending;
    }
    function ReleaseLockerAccess()
    {
        
        if (CurrentAuthorizedUser != msg.sender)
        {
            revert();
        }
        LockerStatus ="Available";
        ThirdPartyRequestor = 0x0;
        CurrentAuthorizedUser = 0x0;
        IntendedPurpose="";
        State = LockerState.AvailableToShare;
    }
    function RevokeAccessFromThirdParty()
    {
        if (Owner != msg.sender)
        {
            revert();
        }
            LockerStatus ="Available";
            CurrentAuthorizedUser=0x0;
            State = LockerState.AvailableToShare;
    }
    function Terminate()
    {
        if (Owner != msg.sender)
        {
            revert();
        }
        CurrentAuthorizedUser=0x0;
        State = LockerState.Terminated;
    }

    

}