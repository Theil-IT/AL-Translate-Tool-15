#pragma implicitwith disable
page 78600 "BAC Trans Project List"
{
    Caption = 'Translation Projects';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BAC Translation Project";
    SourceTableView = sorting("Project Code") order(descending);

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Project Code"; Rec."Project Code")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    trigger OnAssistEdit();
                    begin
                        if Rec.AssistEdit then
                            CurrPage.Update;
                    end;

                }
                field("Project Name"; Rec."Project Name")
                {
                    ApplicationArea = All;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Open Projects which means projects in process - Released Projects which means sent to customer, but not finished - Finished Projects which means sent to customer and done for now';
                }
                field("NAV Version"; Rec."NAV Version")
                {
                    ApplicationArea = All;
                }
                field("Source Language"; Rec."Source Language")
                {
                    ApplicationArea = All;
                }
                field("Source Language ISO code"; Rec."Source Language ISO code")
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Base Translation Imported"; Rec."Base Translation Imported")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Import Source")
            {
                ApplicationArea = All;
                Caption = 'Import Source';
                Image = ImportCodes;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ImportSourceXML: XmlPort "BAC Import Translation Source";
                    ImportSource2018XML: XmlPort "BAC Import Trans. Source 2018";
                    TransSource: Record "BAC Translation Source";
                    TransNotes: Record "BAC Translation Notes";
                    DeleteWarningTxt: Label 'This will overwrite the Translation source for %1';
                    TransProject: Record "BAC Translation Project";
                    ImportedTxt: Label 'The file %1 has been imported into project %2';
                begin
                    TransSource.SetRange("Project Code", Rec."Project Code");
                    if not TransSource.IsEmpty then
                        if Confirm(DeleteWarningTxt, false, Rec."Project Code") then begin
                            TransSource.DeleteAll();
                            TransNotes.DeleteAll();
                        end else
                            exit;
                    case Rec."NAV Version" of
                        Rec."NAV Version"::"Dynamics 365 Business Central":
                            begin
                                ImportSourceXML.SetProjectCode(Rec."Project Code");
                                ImportSourceXML.Run();
                                Success := ImportSourceXML.FileImported()
                            end;
                        Rec."NAV Version"::"Dynamics NAV 2018":
                            begin
                                ImportSource2018XML.SetProjectCode(Rec."Project Code");
                                ImportSource2018XML.Run();
                                Success := ImportSource2018XML.FileImported();
                            end;
                    end;
                    TransProject.Get(Rec."Project Code");
                    if (TransProject."File Name" <> '') and Success then
                        message(ImportedTxt, TransProject."File Name", Rec."Project Code");
                end;
            }
            action("Target Languages")
            {
                ApplicationArea = All;
                Caption = 'Target Languages';
                Image = Language;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = page "BAC Target Language List";
                RunPageLink = "Project Code" = field("Project Code"),
                "Source Language" = field("Source Language"),
                "Source Language ISO code" = field("Source Language ISO code");
            }
            action("Translation Source")
            {
                ApplicationArea = All;
                Caption = 'Translation Source';
                Image = SourceDocLine;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = page "BAC Translation Source List";
                RunPageLink = "Project Code" = field("Project Code");
            }
            action("All Translation Targets")
            {
                Caption = 'All Translation Targets';
                ApplicationArea = All;
                Image = Translate;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TargetRec: Record "BAC Translation Target";
                    TranslationTargetList: Page "BAC Translation Target List";
                begin
                    // Determine equivalent language

                    TargetRec.SetRange("Project Code", Rec."Project Code");

                    TranslationTargetList.SetTableView(TargetRec);
                    TranslationTargetList.Run();

                end;
            }
        }
    }
    var
        Success: Boolean;

    trigger OnOpenPage()
    var
        UserAccess: Record "BAC User Access";
        FilterTxt: Text;
    begin
        UserAccess.SetRange("User Id", UserId());
        if UserAccess.FindSet() then
            Repeat
                if FilterTxt <> '' then
                    FilterTxt += '|' + UserAccess."Project Code"
                else
                    FilterTxt := UserAccess."Project Code";
            until UserAccess.Next() = 0;
        if FilterTxt <> '' then begin
            Rec.FilterGroup(1);
            Rec.SetFilter("Project Code", FilterTxt);
            Rec.FilterGroup(0);
        end;
    end;
}
#pragma implicitwith restore
