page 78605 "BAC Trans Target Factbox"
{
    PageType = CardPart;
    SourceTable = "BAC Translation Target";
    Caption = 'Translation Target Factbox';
    Editable = false;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                ShowCaption = false;
                field(Instances; Instances)
                {
                    Caption = 'Instances';
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        Instances: Integer;

    trigger OnAfterGetRecord()
    var
        TransTarget: Record "BAC Translation Target";
    begin
        TransTarget.SetRange(Source, Source);
        Instances := TransTarget.Count;
    end;
}