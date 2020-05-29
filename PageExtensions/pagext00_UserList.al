pageextension 78600 "BAC User Card" extends Users
{
    actions
    {
        addfirst(processing)
        {
            action("BAC User Access")
            {
                Caption = 'User Access';
                ApplicationArea = All;
                Image = ServiceAccessories;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = page "BAC User Access";
                RunPageLink = "User Id" = field("User Name");
            }
        }
    }
}