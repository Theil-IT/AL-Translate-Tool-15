page 78603 "BAC Translation Target List"
{
    Caption = 'Translation Target List';
    PageType = List;
    SourceTable = "BAC Translation Target";
    PopulateAllFields = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Field Name"; "Field Name")
                {
                    ApplicationArea = All;

                }
                field("Trans-Unit Id"; "Trans-Unit Id")
                {
                    ApplicationArea = All;
                    Visible = false;

                }

                field(Source; Source)
                {
                    ApplicationArea = All;
                }
                field(Translate2; Translate)
                {
                    ApplicationArea = All;
                    ToolTip = 'Set the Translate field to no if you don''t want it to be translated';
                }
                field(Target; Target)
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the translated text';
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;

                }
                field(Occurrencies; Occurrencies)
                {
                    Visible = false;
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
                Editable = false;
                ApplicationArea = All;
            }
            part(TargetFactbox; "BAC Trans Target Factbox")
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
            action("Translate")
            {
                ApplicationArea = All;
                Caption = 'Translate';
                Image = Translation;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Enabled = ShowTranslate;

                trigger OnAction();
                var
                    Translater: Codeunit "BAC Translate Dispatcher";
                    Project: Record "BAC Translation Project";
                begin
                    Project.get(Rec."Project Code");
                    Rec.Target := Translater.Translate(Project."Project Code", Project."Source Language ISO code",
                                              Rec."Target Language ISO code",
                                              Rec.Source);
                    Rec.Target := ReplaceTermInTranslation(Rec."Target Language ISO code", Rec.Target);
                    Rec.Validate(Target);
                end;
            }
            action("Translate All")
            {
                ApplicationArea = All;
                Caption = 'Translate All';
                Image = Translations;
                Promoted = true;
                PromotedOnly = true;
                Enabled = ShowTranslate;
                PromotedCategory = Process;

                trigger OnAction();
                var
                    MenuSelectionTxt: Label 'Convert all,Convert only missing';
                begin
                    case StrMenu(MenuSelectionTxt, 1) of
                        1:
                            TranslateAll(false);

                        2:
                            TranslateAll(true);
                    end;
                end;
            }
            action("Select All")
            {
                ApplicationArea = All;
                Caption = 'Select All';
                Image = Approve;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    WarningTxt: Label 'Mark all untranslated lines to be translated?';
                    TransTarget: Record "BAC Translation Target";
                begin
                    CurrPage.SetSelectionFilter(TransTarget);
                    if TransTarget.Count = 1 then
                        TransTarget.Reset();
                    TransTarget.SetRange(Target, '');
                    if Confirm(WarningTxt) then
                        TransTarget.ModifyAll(Translate, true);
                    CurrPage.Update(false);

                end;
            }
            action("Select Empty Translations")
            {
                Caption = 'Select Empty Translations';
                Image = SelectEntries;
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    SetRange(Target, '');
                end;
            }
            action("Deselect All")
            {
                ApplicationArea = All;
                Caption = 'Deselect All';
                Image = Cancel;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    WarningTxt: Label 'Remove mark from all lines and disable translation?';
                    TransTarget: Record "BAC Translation Target";
                begin
                    CurrPage.SetSelectionFilter(TransTarget);
                    if TransTarget.Count = 1 then
                        TransTarget.Reset();
                    if Confirm(WarningTxt) then
                        TransTarget.ModifyAll(Translate, false);
                    CurrPage.Update(false);
                end;
            }
            action("Clear All translations")
            {
                ApplicationArea = All;
                Caption = 'Clear All translations within filter';
                Image = RemoveLine;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    WarningTxt: Label 'Remove all translations?';
                    TransTarget: Record "BAC Translation Target";
                begin
                    CurrPage.SetSelectionFilter(TransTarget);
                    //if TransTarget.Count = 1 then
                    //    TransTarget.Reset();
                    if Confirm(WarningTxt) then
                        TransTarget.ModifyAll(Target, '');
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
                RunObject = page "BAC Translation terms";
                RunPageLink = "Project Code" = field("Project Code"),
                            "Target Language" = field("Target Language ISO code");
            }
            action("Export Translation File")
            {
                ApplicationArea = All;
                Caption = 'Export Translation File';
                Image = ExportFile;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    WarningTxt: Label 'Export the Translation file?';
                    ExportTranslation: XmlPort "BAC Export Translation Target";
                    ExportTranslation2018: XmlPort "BAC Export Trans Target 2018";
                    TransProject: Record "BAC Translation Project";
                begin
                    if Confirm(WarningTxt) then begin
                        TransProject.get("Project Code");
                        case TransProject."NAV Version" of
                            TransProject."NAV Version"::"Dynamics 365 Business Central":
                                begin
                                    ExportTranslation.SetProjectCode("Project Code", TransProject."Source Language ISO code", "Target Language ISO code");
                                    ExportTranslation.Run();
                                end;
                            TransProject."NAV Version"::"Dynamics NAV 2018":
                                begin
                                    ExportTranslation2018.SetProjectCode("Project Code", TransProject."Source Language ISO code", "Target Language ISO code");
                                    ExportTranslation2018.Run();
                                end;
                        end;
                    end;
                end;

            }
            action("Find Duplicates")
            {
                Caption = 'Find Duplicates';
                Image = Find;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FindDuplicatesTxt: Label 'Find Duplicates?';
                begin
                    if Confirm(FindDuplicatesTxt) then
                        FindDuplicates();
                end;
            }
            action("Update From Source")
            {
                Caption = 'Update From Source';
                Image = UpdateXML;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    FindDuplicatesTxt: Label 'Update from Source?';
                begin
                    if Confirm(FindDuplicatesTxt) then
                        UpdateFromSource();
                end;
            }

        }
    }
    var
        [InDataSet]
        ShowTranslate: Boolean;


    trigger OnOpenPage()
    var
        TransSource: Record "BAC Translation Source";
        TransTarget: Record "BAC Translation Target";
        TransSetup: Record "BAC Translation Setup";
    begin
        TransSetup.get();
        ShowTranslate := TransSetup."Use Free Google Translate" or TransSetup."Use ChatGPT";

        TransSource.SetFilter("Project Code", GetFilter("Project Code"));
        if TransSource.FindSet() then
            repeat
                TransTarget.TransferFields(TransSource);
                TransTarget."Target Language" := GetFilter("Target Language");
                TransTarget."Target Language ISO code" := GetFilter("Target Language ISO code");
                if TransTarget.Insert() then;
            until TransSource.Next() = 0;
    end;

    local procedure TranslateAll(inOnlyEmpty: Boolean)
    var
        Translater: Codeunit "BAC Translate Dispatcher";
        TransTarget: Record "BAC Translation Target";
        TransTarget2: Record "BAC Translation Target";
        Project: Record "BAC Translation Project";
        Window: Dialog;
        DialogTxt: Label 'Converting #1###### of #2######';
        Counter: Integer;
        TotalCount: Integer;
        EscapedSource: Text;
    begin
        Project.Get(Rec."Project Code");
        if inOnlyEmpty then
            TransTarget.SetRange(Target, '');
        TransTarget.SetRange(Translate, true);
        TransTarget.SetRange("Project Code", Project."Project Code");
        TransTarget.SetRange("Target Language ISO code", Rec."Target Language ISO code");

        TotalCount := TransTarget.Count;
        Window.Open(DialogTxt);

        // First pass: Occurrencies = 1
        TransTarget.SetRange(Occurrencies, 1);
        if TransTarget.FindSet() then begin
            repeat
                Counter += 1;
                Window.Update(1, Counter);
                Window.Update(2, TotalCount);
                TransTarget.Target := Translater.Translate(Project."Project Code", Project."Source Language ISO code",
                                          Rec."Target Language ISO code",
                                          TransTarget.Source);
                TransTarget.Target := ReplaceTermInTranslation(Rec."Target Language ISO code", TransTarget.Target);
                TransTarget.Translate := false;
                TransTarget.Modify();
                Commit();
            until TransTarget.Next() = 0;
        end;

        // Reset for second pass
        TransTarget.Reset();
        if inOnlyEmpty then
            TransTarget.SetRange(Target, '');
        TransTarget.SetRange(Translate, true);
        TransTarget.SetRange("Project Code", Project."Project Code");
        TransTarget.SetRange("Target Language ISO code", Rec."Target Language ISO code");
        TransTarget.SetCurrentKey(Source);
        TransTarget.SetFilter(Occurrencies, '>1');
        if TransTarget.FindSet() then begin
            repeat
                Counter += 1;
                Window.Update(1, Counter);
                Window.Update(2, TotalCount);
                TransTarget.Target := Translater.Translate(Project."Project Code", Project."Source Language ISO code",
                                              Rec."Target Language ISO code",
                                              TransTarget.Source);
                TransTarget.Target := ReplaceTermInTranslation(Rec."Target Language ISO code", TransTarget.Target);

                // Escape only for TransTarget2
                EscapedSource := StrSubstNo('''%1''', TransTarget.Source.Replace('''', ''''''));
                TransTarget2.SetFilter(Source, EscapedSource);
                TransTarget2.SetFilter("Target Language ISO code", Rec."Target Language ISO code");
                TransTarget2.ModifyAll(Target, TransTarget.Target);

                // Mark all as not needing translate
                TransTarget2.ModifyAll(Translate, false);

                Commit();
                SelectLatestVersion();

                // Use raw value here
                TransTarget.SetFilter(Source, '<>%1', TransTarget.Source);
            until TransTarget.FindSet() = false;
        end;

        Window.Close();
    end;


    // This does the post-translation replacement of terms
    local procedure ReplaceTermInTranslation(TargetLanguageIsoCode: Text[10]; inTarget: Text[250]) outTarget: Text[250]
    var
        TransTerm: Record "BAC Translation Term";
        StartPos: Integer;
        StartLetterIsUppercase: Boolean;
        Found: Boolean;
    begin
        TransTerm.SetRange("Project Code", Rec."Project Code");
        if TransTerm.FindSet() then
            repeat
                if TransTerm."Apply Pre-Translation" then
                    continue; // Skip terms that are marked for pre-translation only
                StartPos := strpos(LowerCase(inTarget), LowerCase(TransTerm.Term));
                if StartPos > 0 then begin
                    StartLetterIsUppercase := copystr(inTarget, StartPos, 1) = uppercase(copystr(inTarget, StartPos, 1));
                    if StartLetterIsUppercase then
                        TransTerm.Translation := UpperCase(TransTerm.Translation[1]) + CopyStr(TransTerm.Translation, 2)
                    else
                        TransTerm.Translation := LowerCase(TransTerm.Translation[1]) + CopyStr(TransTerm.Translation, 2);
                    if (StartPos > 1) then begin
                        outTarget := CopyStr(inTarget, 1, StartPos - 1) +
                                     TransTerm.Translation +
                                     CopyStr(inTarget, StartPos + strlen(TransTerm.Term));
                        Found := true;
                    end else begin
                        outTarget := TransTerm.Translation +
                                     CopyStr(inTarget, strlen(TransTerm.Term) + 1);
                        Found := true;
                    end;
                end;
                if Found then
                    inTarget := outTarget;
            until TransTerm.Next() = 0;
        if not Found then
            outTarget := inTarget;
    end;

    local procedure FindDuplicates()
    var
        TransTarget: Record "BAC Translation Target";
        TransTargetDup: Record "BAC Translation Target";
        TransTargetTrans: Record "BAC Translation Target";
        Counter: Integer;
        FinishedTxt: Label '%1 Duplicate captions found';
    begin
        TransTarget.CopyFilters(Rec);
        TransTarget.SetRange(Target, '');
        if TransTarget.FindSet() then
            repeat
                TransTargetTrans.CopyFilters(Rec);
                TransTargetTrans.SetRange(Source, TransTarget.Source);
                TransTargetTrans.SetFilter(Target, '<>%1', '');
                if TransTargetTrans.FindFirst() then begin
                    TransTargetDup.CopyFilters(Rec);
                    TransTargetDup.SetRange(Source, TransTarget.Source);
                    TransTargetDup.SetRange(Target, '');
                    TransTargetDup.ModifyAll(Target, TransTargetTrans.Target);
                    Counter += 1;
                end;
            until TransTarget.Next() = 0;
        message(FinishedTxt, Counter);
    end;

    local procedure UpdateFromSource()
    var
        TransTarget: Record "BAC Translation Target";
        TransSource: Record "BAC Translation Source";
        Counter: Integer;
        DeletedCounter: Integer;
        FinishedTxt: Label '%1 source captions updated. %2 obsolete targets deleted.';
    begin
        TransTarget.Modifyall(Translate, false);
        if TransSource.FindSet() then
            repeat
                TransTarget.SetRange("Project Code", TransSource."Project Code");
                TransTarget.SetRange("Trans-Unit Id", TransSource."Trans-Unit Id");
                if TransTarget.FindSet() then
                    repeat
                        if TransTarget.Source <> TransSource.Source then begin
                            TransTarget.Source := TransSource.Source;
                            TransTarget.Translate := true;
                            TransTarget.Modify();
                            Counter += 1;
                        end;
                    until TransTarget.Next() = 0;
            until TransSource.Next() = 0;


        // Check for targets that no longer exist in source
        TransTarget.Reset();
        if TransTarget.FindSet() then
            repeat
                TransSource.SetRange("Project Code", TransTarget."Project Code");
                TransSource.SetRange("Trans-Unit Id", TransTarget."Trans-Unit Id");
                if not TransSource.FindFirst() then begin
                    TransTarget.Delete();
                    DeletedCounter += 1;
                end;
            until TransTarget.Next() = 0;
        Message(FinishedTxt, Counter, DeletedCounter);

    end;


}