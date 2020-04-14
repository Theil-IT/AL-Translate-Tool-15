page 78611 "BAC Languages"
{
    Caption = 'Languages (Translate Module)';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Language;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Windows Language ID"; "Windows Language ID")
                {
                    ApplicationArea = All;
                }
                field("Windows Language Name"; "Windows Language Name")
                {
                    ApplicationArea = All;
                }
                field("BAC ISO code"; "BAC ISO code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}