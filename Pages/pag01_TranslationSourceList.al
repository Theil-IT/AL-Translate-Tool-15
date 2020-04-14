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
                field("Trans-Unit Id"; "Trans-Unit Id")
                {
                    ApplicationArea = All;

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
                SubPageLink = "Project Code" = field ("Project Code"),
                            "Trans-Unit Id" = field ("Trans-Unit Id");
            }

        }
    }
}