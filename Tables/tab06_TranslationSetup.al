table 78606 "BAC Translation Setup"
{
    DataClassification = SystemMetadata;
    Caption = 'Translation Setup';

    fields
    {
        field(10; "Primary Key"; code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Primary Key';
        }
        field(20; "Project Nos."; code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Project Nos.';
            TableRelation = "No. Series";
        }
        field(30; "Default Source Language code"; code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Default Source Language code';
            TableRelation = Language;
        }
        field(40; "Use Free Google Translate"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Use Free Google Translate';
            InitValue = true;
            // To prepare for other translation API's
        }
        field(50; Logo; MediaSet)
        {
            DataClassification = SystemMetadata;
            Caption = 'Logo';
        }

        field(60; "Use ChatGPT"; Boolean)
        {
            Caption = 'Use ChatGPT';
            DataClassification = SystemMetadata;
        }

        field(70; "ChatGPT API Key"; Text[512])
        {
            Caption = 'OpenAI API Key';
            DataClassification = SystemMetadata;
        }

        field(80; "ChatGPT Model"; Option)
        {
            Caption = 'ChatGPT Model';
            OptionMembers = "gpt-3.5-turbo","gpt-4o";

            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}