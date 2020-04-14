table 78603 "BAC Target Language"
{
    DataClassification = SystemMetadata;
    Caption = 'Target Language';

    fields
    {
        field(10; "Project Code"; code[10])
        {
            DataClassification = AccountData;
            Caption = 'Project Code';
            TableRelation = "BAC Translation Project Name";
            Editable = false;
        }
        field(20; "Project Name"; Text[100])
        {
            Caption = 'Project Name';
            FieldClass = FlowField;
            CalcFormula = lookup ("BAC Translation Project Name"."Project Name" where ("Project Code" = field ("Project Code")));
            Editable = false;
        }

        field(30; "Source Language"; Code[10])
        {
            DataClassification = AccountData;
            Caption = 'Source Language';
            TableRelation = Language;
            Editable = false;
        }
        field(35; "Source Language ISO code"; Text[10])
        {
            DataClassification = AccountData;
            Caption = 'Source Language ISO code';
            Editable = false;
        }
        field(40; "Target Language"; Code[10])
        {
            DataClassification = AccountData;
            Caption = 'Target Language';
            TableRelation = Language;
            trigger OnValidate()
            var
                Language: Record Language;
            begin
                if Language.Get("Target Language") then begin
                    Language.TestField("BAC ISO code");
                    "Target Language ISO code" := Language."BAC ISO code"
                end else
                    clear("Target Language ISO code");
            end;
        }
        field(45; "Target Language ISO code"; Text[10])
        {
            DataClassification = AccountData;
            Caption = 'Target Language ISO code';
            Editable = false;
        }
        field(50; "File Name"; Text[250])
        {
            DataClassification = SystemMetadata;
            Caption = 'File Name';
        }
    }

    keys
    {
        key(PK; "Project Code", "Target Language")
        {
            Clustered = true;
        }
    }
}