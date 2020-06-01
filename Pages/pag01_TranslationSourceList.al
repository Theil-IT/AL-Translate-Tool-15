page 78601 "BAC Translation Source List"
{
    PageType = List;
    SourceTable = "BAC Translation Source";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Field Name";"Field Name")
                {
                    ApplicationArea = All;

                }
                field("Trans-Unit Id"; "Trans-Unit Id")
                {
                    ApplicationArea = All;
                    Visible=false;

                }
                field(Source; Source)
                {
                    ApplicationArea = All;

                }
            }
        }
        area(Factboxes)
        {
            part(TransNotes; "BAC Translation Notes")
            {
                SubPageLink = "Project Code" = field("Project Code"),
                            "Trans-Unit Id" = field("Trans-Unit Id");
                ApplicationArea = All;
            }

        }
    }
    actions
    {
        area(Processing)
        {
            action("Show Empty Captions")
            {
                Caption = 'Show Empty Captions';
                ApplicationArea = All;
                Image = ShowSelected;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    SetRange(Source, '');
                end;
            }
            action("Show All Captions")
            {
                Caption = 'Show All Captions';
                ApplicationArea = All;
                Image = ShowList;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    SetRange(Source);
                end;
            }
        }
    }
}