page 78614 "BAC Translation Role Center"
{
    Caption = 'Translation Role Center';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part(Activities; "BAC Translation Activities")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Setup)
            {
                Caption = 'Translation Setup';
                RunObject = Page "BAC Translation Setup";
                ApplicationArea=All;
            }
        }
        area(Sections)
        {
            group(SectionsGroupName)
            {
                Caption = '';
                action(SectionsAction)
                {
                    ApplicationArea=All;
                    //RunObject = Page ObjectName;
                }
            }
        }
        area(Embedding)
        {
            action("Translation Projects")
            {
                ApplicationArea=All;
                RunObject = Page "BAC Trans Project List";
            }
        }
    }
}