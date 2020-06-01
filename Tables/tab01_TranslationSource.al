table 78601 "BAC Translation Source"
{
    DataClassification = AccountData;
    Caption = 'Translation Source';

    fields
    {
        field(5; "Line No."; Integer)
        {
            DataClassification = SystemMetadata;
            Caption = 'Line No.';
            AutoIncrement = true;
        }
        field(10; "Project Code"; code[10])
        {
            DataClassification = AccountData;
            Caption = 'Project Code';
        }
        field(20; "Trans-Unit Id"; Text[250])
        {
            DataClassification = AccountData;
            Caption = 'Trans-Unit Id';
        }
        field(50; "Source"; Text[2048])
        {
            DataClassification = AccountData;
            Caption = 'Source';
        }
        field(80; "size-unit"; Text[10])
        {
            DataClassification = AccountData;
            Caption = 'size-unit';
        }
        field(90; "TranslateAttr"; Text[10])
        {
            DataClassification = AccountData;
            Caption = 'TranslateAttr';
        }
        field(100; "xml:space"; Text[10])
        {
            DataClassification = AccountData;
            Caption = 'xml:space';
        }
        field(110; "Max Width"; Text[10])
        {
            DataClassification = AccountData;
            Caption = 'Max Width';
        }
        field(120; "al-object-target"; Text[100])
        {
            DataClassification = AccountData;
            Caption = 'al-object-target';
        }
        field(140; "Field Name"; Text[250])
        {
            Caption = 'Field Name';
            FieldClass = FlowField;
            CalcFormula = lookup ("BAC Translation Notes".Note where("Project Code" = field("Project Code"),
                                                             "Trans-Unit Id" = field("Trans-Unit Id"),
                                                             From = const('Xliff Generator')));

        }
    }

    keys
    {
        key(PK; "Project Code", "Trans-Unit Id")
        {
            Clustered = true;
        }
    }
}