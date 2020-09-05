table 78600 "BAC Translation Project"
{
    Caption = 'Translation Project Name';
    DataClassification = SystemMetadata;

    fields
    {
        field(10; "Project Code"; code[20])
        {
            Caption = 'Project Code';
            DataClassification = SystemMetadata;
            trigger OnValidate();
            var
                TransSetup: Record "BAC Translation Setup";
                NoSeriesMgt: Codeunit NoSeriesManagement;
            begin
                if "Project Code" <> xRec."Project Code" then begin
                    TransSetup.GET();
                    NoSeriesMgt.TestManual(TransSetup."Project Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(20; "Project Name"; Text[100])
        {
            Caption = 'Project Name';
            DataClassification = AccountData;
        }
        field(30; "Source Language"; Code[10])
        {
            Caption = 'Source Language';
            DataClassification = AccountData;
            TableRelation = Language;
            trigger OnValidate()
            var
                Language: Record Language;
            begin
                if Language.Get("Source Language") then begin
                    Language.TestField("BAC ISO code");
                    "Source Language ISO code" := Language."BAC ISO code"
                end else
                    clear("Source Language ISO code");
            end;
        }
        field(32; "Target Language"; Text[10])
        {
            Caption = 'Target Language';
            DataClassification = AccountData;
        }

        field(35; "Source Language ISO code"; Text[10])
        {
            Caption = 'Source Language';
            DataClassification = AccountData;
            Editable = false;
        }
        field(40; "Creation Date"; Date)
        {
            DataClassification = AccountData;
            Caption = 'Creation Date';
            Editable = false;
        }
        field(50; "Created By"; Text[100])
        {
            DataClassification = AccountData;
            Caption = 'Created By';
            Editable = false;
        }
        field(60; "Xml Version"; Text[250])
        {
            Caption = 'Xml Version';
            DataClassification = AccountData;
        }
        field(70; "Xliff Version"; Text[250])
        {
            DataClassification = AccountData;
            Caption = 'Xliff Version';

        }
        field(80; "File Datatype"; Text[250])
        {
            DataClassification = AccountData;
            Caption = 'File Datatype';

        }
        field(90; "File Name"; Text[250])
        {
            DataClassification = SystemMetadata;
            Caption = 'File Name';
        }
        field(100; "No. Series"; Code[10])
        {
            Editable = false;
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = SystemMetadata;
        }
        field(110; OrginalAttr; Text[100])
        {
            Editable = false;
            Caption = 'OrginalAttr';
            DataClassification = SystemMetadata;
        }
        field(120; "NAV Version"; Option)
        {
            DataClassification = SystemMetadata;
            Caption = 'NAV Version';
            OptionMembers = "Dynamics NAV 2018","Dynamics 365 Business Central";
            OptionCaption = 'Dynamics NAV 2018,Dynamics 365 Business Central';
            InitValue = 1;
        }
        field(130; Status; Option)
        {
            Caption = 'Status';
            DataClassification = SystemMetadata;
            OptionMembers = Open,Released,Closed;
            OptionCaption = 'Open,Released,Closed';
        }
        field(140;"Base Translation Imported";Boolean)
        {
            Caption='Base Translation Imported';
            Editable=false;
        }
    }

    keys
    {
        key(PK; "Project Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup("DropDown"; "Project Code", "Project Name")
        {

        }
    }

    var
        TransProject: Record "BAC Translation Project";

    trigger OnInsert()
    var
        TransSetup: Record "BAC Translation Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        "Created By" := copystr(UserId(), 1, MaxStrLen(("Created By")));
        "Creation Date" := Today;
        if "Project Code" = '' then begin
            TransSetup.get();
            TransSetup.TestField("Project Nos.");
            NoSeriesMgt.InitSeries(TransSetup."Project Nos.", xRec."No. Series", 0D, "Project Code", "No. Series");
            TransSetup.TestField("Default Source Language code");
            if "Source Language" = '' then
                validate("Source Language", TransSetup."Default Source Language code");
        end;
    end;

    trigger OnDelete()
    var
        TransSource: Record "BAC Translation Source";
        TransTarget: Record "BAC Translation Target";
        TargetLanguage: Record "BAC Target Language";
        TranNote: Record "BAC Translation Notes";
        TransTerm: Record "BAC Translation Term";
    begin
        TransSource.SetRange("Project Code", "Project Code");
        TransSource.DeleteAll();
        TransTarget.SetRange("Project Code", "Project Code");
        TransTarget.DeleteAll();
        TargetLanguage.SetRange("Project Code", "Project Code");
        TargetLanguage.DeleteAll();
        TranNote.SetRange("Project Code", "Project Code");
        TranNote.DeleteAll();
        TransTerm.SetRange("Project Code", "Project Code");
        TransTerm.DeleteAll();
    end;

    procedure AssistEdit(): Boolean;
    var
        TransSetup: Record "BAC Translation Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        with TransProject do begin
            TransProject := Rec;
            TransSetup.get;
            TransSetup.TestField("Project Nos.");
            if NoSeriesMgt.SelectSeries(TransSetup."Project Nos.", xRec."No. Series", "No. Series") then begin
                NoSeriesMgt.SetSeries("Project Code");
                Rec := TransProject;
                exit(true);
            end;
        end;
    end;
}