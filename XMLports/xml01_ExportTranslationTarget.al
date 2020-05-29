xmlport 78601 "BAC Export Translation Target"
{
    Caption = 'Export Translation Target';
    DefaultNamespace = 'urn:oasis:names:tc:xliff:document:1.2';
    Direction = Export;
    Encoding = UTF8;
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
                trigger OnBeforePassVariable()
                begin
                    version := '1.2';
                end;

            }
            textelement(infile)
            {
                XmlName = 'file';
                textattribute(datatype)
                {
                    trigger OnBeforePassVariable()
                    begin
                        datatype := 'xml';
                    end;
                }
                textattribute("Source-language")
                {
                    trigger OnBeforePassVariable()
                    begin
                        "Source-language" := SourceTransCode;
                    end;
                }
                textattribute("target-language")
                {
                    trigger OnBeforePassVariable()
                    begin
                        "target-language" := TargetTransCode;
                    end;
                }
                textattribute(original)
                {
                    trigger OnBeforePassVariable()
                    begin
                        original := TransProject.OrginalAttr;
                    end;
                }
                textelement(body)
                {
                    textelement(group)
                    {
                        textattribute(id1)
                        {
                            XmlName = 'id';
                            trigger OnBeforePassVariable()
                            begin
                                id1 := 'body';
                            end;
                        }
                        tableelement(Target; "BAC Translation Target")
                        {
                            XmlName = 'trans-unit';

                            fieldattribute(id; Target."Trans-Unit Id")
                            {
                            }
                            textattribute("size-unit")
                            {
                                trigger OnBeforePassVariable()
                                begin
                                    "size-unit" := Target."size-unit";
                                end;
                            }
                            textattribute(translate)
                            {
                                trigger OnBeforePassVariable()
                                begin
                                    translate := Target.TranslateAttr;
                                end;
                            }
                            fieldelement(Source; Target.Source)
                            {
                                XmlName = 'source';
                            }

                            tableelement(note; "BAC Translation Notes")
                            {
                                LinkTable = Target;
                                LinkFields = "Project Code" = field("Project Code"), "Trans-Unit Id" = field("Trans-Unit Id");

                                fieldattribute(from; note.From)
                                {
                                }
                                fieldattribute(annotates; note.Annotates)
                                {
                                }
                                fieldattribute(priority; note.Priority)
                                {
                                }
                                fieldattribute(note; note.Note)
                                {

                                }
                            }

                            /*textelement(note)
                            {
                                trigger OnAfterAssignVariable()
                                begin
                                    
                                end;
                                   textattribute(from)
                                    {
                                        trigger OnBeforePassVariable()
                                        begin
                                            from := note.From;
                                        end;
                                    }
                                    textattribute(annotates)
                                    {
                                        trigger OnBeforePassVariable()
                                        begin
                                            annotates := note.Annotates;
                                        end;
                                    }
                                    textattribute(priority)
                                    {
                                        trigger OnBeforePassVariable()
                                        begin
                                            priority := note.Priority;
                                        end;

                                    }
                                    trigger OnBeforePassField()
                                    var
                                        myInt: Integer;
                                    begin
                                        note.Note := 'HEllo World';
                                    end;
                            }*/

                            fieldelement(Target; Target.Target)
                            {
                                XmlName = 'target';
                            }
                        }
                    }
                }
            }
        }
    }

    var
        TransNotes: Record "BAC Translation Notes";
        TransProject: Record "BAC Translation Project";
        ProjectCode: Code[10];
        SourceTransCode: Text[10];
        TargetTransCode: Text[10];
        MissingProjNameTxt: Label 'Project Name is Missing';

    trigger OnPreXmlPort()
    var
        TempFile: Text;
    begin
        TransProject.Get(target.getfilter("Project Code"));
        TempFile := TransProject."File Name";
        if StrPos(lowercase(TempFile), '.xlf') > 0 then
            currXMLport.Filename := CopyStr(TempFile, 1, StrPos(lowercase(TempFile), '.xlf')) +
                                     Target.GetFilter("Target Language ISO code") + '.xlf';
        if StrPos(lowercase(TempFile), '.xlif') > 0 then
            currXMLport.Filename := CopyStr(TempFile, 1, StrPos(lowercase(TempFile), '.xlif')) +
                                     Target.GetFilter("Target Language ISO code") + '.xlif';
    end;

    procedure SetProjectCode(inProjectCode: Code[10]; InSourceLang: Text[10]; InTargetLang: Text[10])
    begin
        Target.SetRange("Project Code", inProjectCode);
        Target.SetRange("Target Language ISO code", InTargetLang);
        ProjectCode := inProjectCode;
        SourceTransCode := InSourceLang;
        TargetTransCode := InTargetLang;
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
}

