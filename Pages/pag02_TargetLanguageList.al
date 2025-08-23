
page 78602 "BAC Target Language List"
{
    PageType = List;
    SourceTable = "BAC Target Language";
    Caption = 'Target Language List';
    PopulateAllFields = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Project Name"; Rec."Project Name")
                {
                    ApplicationArea = All;
                    QuickEntry = false;

                }
                field("Source Language"; Rec."Source Language")
                {
                    ApplicationArea = All;
                    QuickEntry = false;

                }
                field("Source Language ISO code"; Rec."Source Language ISO code")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }

                field("Target Language"; Rec."Target Language")
                {
                    ApplicationArea = All;
                }
                field("Target Language ISO code"; Rec."Target Language ISO code")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
            }
        }
        area(FactBoxes)
        {
            part(FactBox; "BAC Trans Source Factbox")
            {
                SubPageLink = "Project Code" = field("Project Code");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Translation Target")
            {
                Caption = 'Translation Target';
                ApplicationArea = All;
                Image = Translate;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = page "BAC Translation Target List";
                RunPageLink = "Project Code" = field("Project Code"),
                            "Target Language" = field("Target Language"),
                            "Target Language ISO code" = field("Target Language ISO code");
            }
            action("Translation Terms")
            {
                Caption = 'Translation Terms';
                ApplicationArea = All;
                Image = BeginningText;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = page "BAC Translation terms";
                RunPageLink = "Project Code" = field("Project Code"),
                            "Target Language" = field("Target Language ISO code");
            }
            action("Project Terms")
            {
                Caption = 'Project Terms';
                ApplicationArea = All;
                Image = BeginningText;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = page "BAC Translation terms";
                RunPageLink = "Project Code" = field("Project Code"),
                            "Target Language" = const('');
            }
            action("Export Translation File")
            {
                ApplicationArea = All;
                Caption = 'Export Translation File';
                Image = ExportFile;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    WarningTxt: Label 'Export the Translation file?';
                    ExportTranslation: XmlPort "BAC Export Translation Target";
                    ExportTranslation2018: XmlPort "BAC Export Trans Target 2018";
                    TransProject: Record "BAC Translation Project";
                begin
                    if Confirm(WarningTxt) then begin
                        TransProject.get(Rec."Project Code");
                        case TransProject."NAV Version" of
                            TransProject."NAV Version"::"Dynamics 365 Business Central":
                                begin
                                    ExportTranslation.SetProjectCode(Rec."Project Code", Rec."Source Language ISO code", Rec."Target Language ISO code");
                                    ExportTranslation.Run();
                                end;
                            TransProject."NAV Version"::"Dynamics NAV 2018":
                                begin
                                    ExportTranslation2018.SetProjectCode(Rec."Project Code", Rec."Source Language ISO code", Rec."Target Language ISO code");
                                    ExportTranslation2018.Run();
                                end;
                        end;
                    end;
                end;

            }
            action("Import Target")
            {
                ApplicationArea = All;
                Caption = 'Import Target';
                Image = ImportLog;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ImportTarget: XmlPort "BAC Import Translation Target";
                    ImportTarget2018: XmlPort "BAC Import Trans Target 2018";
                    TransTarget: Record "BAC Translation Target";
                    TransProject: Record "BAC Translation Project";
                    DeleteWarningTxt: Label 'This will overwrite existing Translation Target entries for %1';
                    ImportedTxt: Label 'The file %1 has been imported into project %2';
                    FileName: Text;
                begin
                    TransTarget.SetRange("Project Code", Rec."Project Code");
                    if not TransTarget.IsEmpty then
                        if not Confirm(DeleteWarningTxt, false, Rec."Project Code") then
                            exit;
                    TransProject.get(Rec."Project Code");
                    case TransProject."NAV Version" of
                        TransProject."NAV Version"::"Dynamics 365 Business Central":
                            begin
                                ImportTarget.SetProjectCode(Rec."Project Code", Rec."Source Language ISO code", Rec."Target Language ISO code");
                                ImportTarget.Run();
                                Success := ImportTarget.FileImported()
                            end;
                        TransProject."NAV Version"::"Dynamics NAV 2018":
                            begin
                                ImportTarget2018.SetProjectCode(Rec."Project Code", Rec."Source Language ISO code", Rec."Target Language ISO code");
                                ImportTarget2018.Run();
                                Success := ImportTarget2018.FileImported()
                            end;
                    end;
                    FileName := ImportTarget.GetFileName();
                    while (strpos(FileName, '\') > 0) do
                        FileName := copystr(FileName, strpos(FileName, '\') + 1);
                    if Success then
                        message(ImportedTxt, FileName, Rec."Project Code");
                end;
            }
            action("Import Base Target")
            {
                ApplicationArea = All;
                Caption = 'Import Base Target';
                Image = ImportCodes;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ImportTargetXML: XmlPort "BAC Import Base Trans. Target";
                    ImportTarget2018XML: XmlPort "BAC Import Base Trans Tgt 2018";
                    TransSource: Record "BAC Translation Source";
                    TransNotes: Record "BAC Base Translation Notes";
                    DeleteWarningTxt: Label 'This will overwrite the Base Translation target for %1';
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
                    TransProject.Get(Rec."Project Code");
                    case TransProject."NAV Version" of
                        TransProject."NAV Version"::"Dynamics 365 Business Central":
                            begin
                                ImportTargetXML.SetProjectCode(Rec."Project Code", Rec."Source Language ISO code", Rec."Target Language ISO code");
                                ImportTargetXML.Run();
                                Success := ImportTargetXML.FileImported()
                            end;
                        TransProject."NAV Version"::"Dynamics NAV 2018":
                            begin
                                ImportTarget2018XML.SetProjectCode(Rec."Project Code", Rec."Source Language ISO code", Rec."Target Language ISO code");
                                ImportTarget2018XML.Run();
                                Success := ImportTarget2018XML.FileImported();
                            end;
                    end;
                    TransProject.Get(Rec."Project Code");
                    if (TransProject."File Name" <> '') and Success then
                        message(ImportedTxt, TransProject."File Name", Rec."Project Code");
                end;
            }

        }
    }
    var
        Success: Boolean;

}
#pragma implicitwith restore
