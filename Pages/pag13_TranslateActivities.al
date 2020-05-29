page 78613 "BAC Translation Activities"
{
    Caption = 'Translation Activities';
    PageType = CardPart;
    SourceTable = "BAC Translation Cue";

    layout
    {
        area(Content)
        {
            cuegroup("Statuses")
            {
                Caption = 'Statuses';
                field("Open Projects"; "Open Projects")
                {
                    ApplicationArea = All;
                    ToolTip = 'Open Projects - not sent to customer';
                }
                field("Released Projects"; "Released Projects")
                {
                    ApplicationArea = All;
                    ToolTip = 'Released Projects - sent to customer, but not finished';
                }
                field("Finished Projects"; "Finished Projects")
                {
                    ApplicationArea = All;
                    ToolTip = 'Finished Projects - sent to customer and done for now';
                }
            }
            cuegroup("Totals")
            {
                Caption = 'Totals';
                field("Projects this Month"; "Projects this Month")
                {
                    ApplicationArea = All;
                }
                field("Total Projects"; "Total Projects")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        ProjectFilterTxt: Text;

    trigger OnOpenPage()
    var
        DateFilterTxt: Text;
        DateFilterLbl: Label '%1..%2';
        UserAccess: Record "BAC User Access";
    begin
        if not Get() then begin
            Init();
            Insert();
        end;
        DateFilterTxt := StrSubstNo(DateFilterLbl, CalcDate('<-CM>', Today()), Today());
        SetFilter("Month Date Filter", DateFilterTxt);
        UserAccess.SetRange("User Id", UserId());
        if UserAccess.FindSet() then
            repeat
                if ProjectFilterTxt <> '' then
                    ProjectFilterTxt += '|' + UserAccess."Project Code"
                else
                    ProjectFilterTxt := UserAccess."Project Code";
            until UserAccess.Next() = 0;
        SetFilter("Project Filter", ProjectFilterTxt);
    end;
}