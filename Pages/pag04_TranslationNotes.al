page 78604 "BAC Translation Notes"
{
    PageType = Listpart;
    SourceTable = "BAC Translation Notes";
    Caption = 'Translation Notes';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(From; From)
                {
                    ApplicationArea = All;

                }
                field(Annotates; Annotates)
                {
                    ApplicationArea = All;

                }
                field(Note; Note)
                {
                    ApplicationArea = All;
                }
                field(Priority; Priority)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
}