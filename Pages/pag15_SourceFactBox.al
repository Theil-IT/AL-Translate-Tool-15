page 78615 "BAC Trans Source Factbox"
{
    PageType = CardPart;
    SourceTable = "BAC Translation Source";
    Caption = 'Source Factbox';
    Editable = false;

    layout
    {
        area(Content)
        {
            group(Totals)
            {
                field(TotalCaptions; TotalCaptions)
                {
                    Caption = 'Total Captions';
                    ApplicationArea = all;
                }
                field(TotalMissingTranslations; TotalMissingTranslations)
                {
                    Caption = 'Total Missing Translations';
                    ApplicationArea = all;
                }
                field(TotalMissingCaptions; TotalMissingCaptions)
                {
                    Caption = 'Total Missing Captions';
                    ApplicationArea = all;
                }
            }
        }
    }

    var
        TotalCaptions: Integer;
        TotalMissingCaptions: Integer;
        TotalMissingTranslations: Integer;

    trigger OnAfterGetRecord()
    var
        Source: Record "BAC Translation Source";
    begin
        Source.SetRange("Project Code", "Project Code");
        TotalCaptions := Source.Count;
        Source.SetRange(Source, '');
        TotalMissingCaptions := Source.Count;
        Source.SetFilter(Source, '<>%1', '');
        Source.SetRange(Source, '');
        TotalMissingTranslations := Source.Count;
    end;
}