table 78607 "BAC Gen. Translation Term"
{
    Caption = 'General Translation Term';
    DataClassification = AccountData;

    fields
    {
        field(20; "Target Language"; code[10])
        {
            DataClassification = AccountData;
            Caption = 'Target Language';
            Editable = false;
        }
        field(30; "Line No."; Integer)
        {
            DataClassification = AccountData;
            Caption = 'Line No.';
        }
        field(40; Term; Text[250])
        {
            DataClassification = AccountData;
            Caption = 'Term';
        }
        field(50; Translation; Text[250])
        {
            DataClassification = AccountData;
            Caption = 'Translation';
        }
    }

    keys
    {
        key(PK; "Target Language", "Line No.")
        {
            Clustered = true;
        }
    }
    
    trigger OnInsert()
    begin
        TestField("Target Language");
        TestField(Term);
    end;
}