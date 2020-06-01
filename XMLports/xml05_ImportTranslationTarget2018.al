xmlport 78605 "BAC Import Trans Target 2018"
{
    Caption = 'Import Translation Target 2018';
    DefaultNamespace = 'urn:oasis:names:tc:xliff:document:1.2';
    Direction = Import;
    Encoding = UTF16;
    XmlVersionNo = V10;
    Format = Xml;
    PreserveWhiteSpace = true;
    UseDefaultNamespace = true;
    UseRequestPage = false;

    schema
    {
        textelement(xliff)
        {
            textattribute(version)
            {
                trigger OnAfterAssignVariable()
                begin
                    TransProject."Xliff Version" := version;
                end;
            }
            textelement(infile)
            {
                XmlName = 'file';
                textattribute(datatype)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        TransProject."File Datatype" := datatype;
                    end;

                }
                textattribute("source-language")
                {
                    trigger OnAfterAssignVariable()
                    var
                        WrongSourceLangTxt: Label '%1 must be %2 in file - The file %1 is %3';
                    begin
                        if TransProject."Source Language ISO code" <> "source-language" then
                            error(WrongSourceLangTxt, TransProject.FieldCaption("Source Language"), TransProject."Source Language ISO code", "source-language");
                    end;

                }
                textattribute("target-language")
                {
                }
                textattribute(original)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        TransProject.OrginalAttr := original;
                    end;
                }
                textelement(body)
                {
                    textelement(group)
                    {

                        textattribute(id1)
                        {
                            XmlName = 'id';
                        }
                        tableelement(Target; "BAC Translation Target")
                        {
                            XmlName = 'trans-unit';
                            AutoReplace = true;

                            fieldattribute(id; Target."Trans-Unit Id")
                            {
                            }
                            fieldattribute("maxWidth"; Target."Max Width")
                            {
                            }

                            textattribute("size-unit")
                            {
                                trigger OnAfterAssignVariable()
                                begin
                                    Target."size-unit" := "size-unit";
                                end;
                            }
                            textattribute(translate)
                            {
                                trigger OnAfterAssignVariable()
                                begin
                                    Target.TranslateAttr := translate;
                                end;
                            }
                            textattribute("al-object-target")
                            {
                                Occurrence = Optional;
                                trigger OnAfterAssignVariable()
                                begin
                                    target."al-object-target" := "al-object-target";
                                end;
                            }

                            fieldelement(source; Target.Source)
                            {
                            }

                            textelement(note)
                            {
                                XmlName = 'note';
                                textattribute(from)
                                {
                                    trigger OnAfterAssignVariable()
                                    begin
                                        TransNotes.From := from;
                                    end;
                                }
                                textattribute(annotates)
                                {
                                    trigger OnAfterAssignVariable()
                                    begin
                                        TransNotes.Annotates := annotates;
                                    end;
                                }
                                textattribute(priority)
                                {
                                    trigger OnAfterAssignVariable()
                                    begin
                                        TransNotes.Priority := priority;
                                    end;
                                }
                                textattribute(note2)
                                {
                                    XmlName = 'note';
                                    trigger OnAfterAssignVariable()
                                    begin
                                        TransNotes.Note := note2;
                                        CreateTranNote();
                                    end;
                                }
                            }
                            fieldelement(target; Target.Target)
                            {
                            }

                            trigger OnBeforeInsertRecord()
                            begin
                                if ProjectCode = '' then
                                    error(MissingProjNameTxt);
                                Target."Project Code" := ProjectCode;
                                Target."Target Language ISO code" := TargetLangISOCode;
                                Target."Target Language" := TargetLangCode;
                            end;

                            trigger OnAfterInsertRecord()
                            begin
                                if not XMLImported then
                                    XMLImported := true;
                            end;
                        }
                    }
                }
            }
        }
    }

    var
        ProjectCode: Code[10];
        TargetLangCode: Code[10];
        TargetLangISOCode: Text[10];
        SourceLangISOCode: Text[10];
        MissingProjNameTxt: Label 'Project Name is Missing';
        TransNotes: Record "BAC Translation Notes";
        TargetLanguage: Record "BAC Target Language";
        TransTarget: Record "BAC Translation Target";
        TransProject: Record "BAC Translation Project";
        XMLImported: Boolean;

    procedure SetProjectCode(inProjectCode: Code[10]; inSourceLangISOCode: text[10]; inTargetLangISOCode: Text[10])
    begin
        ProjectCode := inProjectCode;
        TransProject.Get(ProjectCode);
        TargetLangISOCode := inTargetLangISOCode;
        SourceLangISOCode := inSourceLangISOCode;
        TargetLanguage.Setrange("Project Code", ProjectCode);
        TargetLanguage.Setrange("Target Language ISO code", TargetLangISOCode);
        TargetLanguage.findfirst;
        TargetLangCode := TargetLanguage."Target Language";
    end;

    local procedure CreateTranNote()
    begin
        if (TransNotes.From <> '') and
           (TransNotes.Annotates <> '') and
           (TransNotes.Priority <> '') then begin
            TransNotes."Project Code" := ProjectCode;
            TransNotes."Trans-Unit Id" := Target."Trans-Unit Id";
            if TransNotes.Insert() then;
            clear(TransNotes);
        end;
    end;

    procedure GetFileName(): Text;
    begin
        exit(currXMLport.Filename);
    end;

    procedure FileImported(): Boolean
    begin
        exit(XMLImported);
    end;
}

