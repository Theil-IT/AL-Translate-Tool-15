page 78607 "BAC Translation Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "BAC Translation Setup";
    Caption = 'Translation Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("Default Source Language code"; "Default Source Language code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Source Languange to be defaulted on every project';
                }
            }
            group("Translate Tools")
            {
                field("Use Free Google Translate"; "Use Free Google Translate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Use the free Google API for translation. The limitation is that it is only possible to access the API a limited number of times each hour.';
                }

            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Project Nos."; "Project Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'No. Series to be used with Projects';
                }
            }
        }
        area(FactBoxes)
        {
            part(Logo; "BAC AL Logo FactBox")
            {
                ApplicationArea=All;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action("About Al Translation Tool")
            {
                RunObject = page "BAC About AL Translation Tool";
                Image = AboutNav;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea=All;
            }

        }
    }
    trigger OnOpenPage()
    begin
        if not get() then begin
            init();
            Insert();
        end;
        DownloadLogo();
    end;

    Procedure DownloadLogo()
    var
        InStr: InStream;
        Client: HttpClient;
        Response: HttpResponseMessage;
        Url: Label 'http://ba-consult.dk/downloads/Translate.jpg';
    begin
        if (Logo.Count() = 0) then begin
            Client.Get(Url, Response);
            Response.Content().ReadAs(InStr);
            clear(Logo);
            if rec.Logo.Count = 0 then
                rec."Logo".ImportStream(InStr, 'Default image');
            CurrPage.Update(true);
        end;
    end;
}