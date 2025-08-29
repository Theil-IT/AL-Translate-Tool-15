
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
                field("Equivalent Language"; Rec."Equivalent Language")
                {
                    ApplicationArea = All;
                    QuickEntry = false;
                }
                field("Equivalent Language ISO code"; Rec."Equivalent Language ISO code")
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

                trigger OnAction()
                var
                    TargetRec: Record "BAC Translation Target";
                    TranslationTargetList: Page "BAC Translation Target List";
                    TargetLang: Text[10];
                begin
                    // Determine equivalent language
                    TargetLang := Rec."Equivalent Language ISO code" <> '' ? Rec."Equivalent Language ISO code" : Rec."Target Language ISO code";

                    TargetRec.SetRange("Project Code", Rec."Project Code");
                    TargetRec.SetRange("Target Language ISO code", TargetLang);

                    TranslationTargetList.SetTableView(TargetRec);
                    TranslationTargetList.Run();

                end;
            }
            action("Translation Terms")
            {
                Caption = 'Translation Terms';
                ApplicationArea = All;
                Image = BeginningText;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TransTermRec: Record "BAC Translation Term";
                    TranslationTerms: Page "BAC Translation terms";
                    TargetLang: Text[10];
                begin
                    // Determine equivalent language
                    TargetLang := Rec."Equivalent Language ISO code" <> ''
                        ? Rec."Equivalent Language ISO code"
                        : Rec."Target Language ISO code";

                    TransTermRec.SetRange("Project Code", Rec."Project Code");
                    TransTermRec.SetRange("Target Language", TargetLang);

                    TranslationTerms.SetTableView(TransTermRec);
                    TranslationTerms.Run();
                end;
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
            action("Export Translation Files")
            {
                ApplicationArea = All;
                Caption = 'Export Translation Files';
                Image = ExportFile;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ExportTranslation: XmlPort "BAC Export Translation Target";
                    TransProject: Record "BAC Translation Project";
                    TargetLangRec: Record "BAC Target Language"; // adjust if different
                    TempBlob: Codeunit "Temp Blob";
                    DataCompression: Codeunit "Data Compression";
                    OutStream: OutStream;
                    InStream: InStream;
                    FileName: Text;
                    TargetLang: Code[10];
                    ZipBlob: Codeunit "Temp Blob";
                    ToFile: Text;
                    ChoiceTxt: Label 'Export current language only,Export all languages';
                    Choice: Integer;
                begin
                    Choice := StrMenu(ChoiceTxt, 1); // default = current language
                    if Choice = 0 then
                        exit; // user cancelled

                    TransProject.Get(Rec."Project Code");

                    if Choice = 1 then begin
                        // -------------------
                        // Export current only
                        // -------------------
                        TargetLang := Rec."Equivalent Language ISO code" <> ''
                            ? Rec."Equivalent Language ISO code"
                            : Rec."Target Language ISO code";

                        TempBlob.CreateOutStream(OutStream);
                        ExportTranslation.SetProjectCode(
                            Rec."Project Code",
                            Rec."Source Language ISO code",
                            Rec."Target Language ISO code",
                            Rec."Equivalent Language ISO code");
                        ExportTranslation.SetDestination(OutStream);
                        ExportTranslation.Run();

                        TempBlob.CreateInStream(InStream);
                        FileName := ExportTranslation.GetFilename();
                        ToFile := FileName;
                        if DownloadFromStream(InStream, 'Export Translation', '', 'XLIFF files (*.xlf)|*.xlf', ToFile) then
                            Message('Translation exported to %1', ToFile);
                    end else begin
                        // -------------------
                        // Export all languages to ZIP
                        // -------------------
                        DataCompression.CreateZipArchive();

                        TargetLangRec.SetRange("Project Code", Rec."Project Code");
                        if TargetLangRec.FindSet() then
                            repeat
                                TargetLang := TargetLangRec."Equivalent Language ISO code" <> ''
                                    ? TargetLangRec."Equivalent Language ISO code"
                                    : TargetLangRec."Target Language ISO code";

                                Clear(ExportTranslation); // new instance per language
                                Clear(TempBlob);
                                TempBlob.CreateOutStream(OutStream);
                                ExportTranslation.SetProjectCode(
                                    Rec."Project Code",
                                    Rec."Source Language ISO code",
                                    TargetLangRec."Target Language ISO code",
                                    TargetLangRec."Equivalent Language ISO code");
                                ExportTranslation.SetDestination(OutStream);

                                ExportTranslation.Export();

                                // Use the filename logic from XmlPort itself
                                FileName := ExportTranslation.GetFilename();

                                TempBlob.CreateInStream(InStream);
                                DataCompression.AddEntry(InStream, FileName);
                            until TargetLangRec.Next() = 0;

                        ZipBlob.CreateOutStream(OutStream);
                        DataCompression.SaveZipArchive(OutStream);

                        ZipBlob.CreateInStream(InStream);
                        ToFile := Rec."Project Name" + '_Translations.zip';
                        if DownloadFromStream(InStream, 'Export All Translations', '', 'ZIP files (*.zip)|*.zip', ToFile) then
                            Message('All translations exported to %1', ToFile);
                    end;
                end;
            }

            action("Export Translation File old")
            {
                ApplicationArea = All;
                Caption = 'Unused';
                Image = ExportFile;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ExportTranslation: XmlPort "BAC Export Translation Target";
                    TempBlob: Codeunit "Temp Blob";
                    TestFile: Text;
                    OutStr: OutStream;
                    InStr: InStream;
                begin
                    Clear(TempBlob);
                    TempBlob.CreateOutStream(OutStr);

                    ExportTranslation.SetProjectCode('MR', 'en-US', 'da-DK', '');
                    ExportTranslation.SetDestination(OutStr);
                    ExportTranslation.Export(); // 👈 use Export() instead of Run()
                    TestFile := 'test.xlf';
                    TempBlob.CreateInStream(InStr);
                    DownloadFromStream(InStr, 'Test Export', '', 'XLIFF files (*.xlf)|*.xlf', TestFile);
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
