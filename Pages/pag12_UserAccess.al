page 78612 "BAC User Access"
{
    Caption = 'User Access';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BAC User Access";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Project Code"; "Project Code")
                {
                    ApplicationArea = All;

                }
                field("User Id"; "User Id")
                {
                    ApplicationArea = All;

                }
                field("Project Name"; "Project Name")
                {
                    ApplicationArea = All;

                }
                field("User Name"; "User Name")
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnOpenPage()
    var
        UserAccess: Record "BAC User Access";
        NoAccessTxt: Label 'No Access';
    begin
        UserAccess.SetRange("User Id", "User Id");
        if not UserAccess.IsEmpty then
            Error(NoAccessTxt)
    end;
}