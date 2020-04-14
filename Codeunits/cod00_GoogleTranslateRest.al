codeunit 78600 "BAC Google Translate Rest"
{
    procedure Translate(inSourceLang: Text[10]; inTargetLang: Text[10]; inText: Text[2048]) outTransText: text[2048]
    var
        EndPoint: Text;
        TokenName: Text[50];
        Headers: HttpHeaders;
    begin
        HttpClient.DefaultRequestHeaders.Add('User-Agent', 'Dynamics 365');
        EndPoint := 'https://translate.googleapis.com/translate_a/single?client=gtx&sl=%1&tl=%2&dt=t&q=%3';
        EndPoint := StrSubstNo(EndPoint, inSourceLang, inTargetLang, inText);
        if not HttpClient.Get(EndPoint, ResponseMessage) then
            Error('The call to the web service failed.');
        if not ResponseMessage.IsSuccessStatusCode then
            error('The web service returned an error message:\\' + 'Status code: %1\' + 'Description: %2', ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);
        ResponseMessage.Content.ReadAs(TransText);
        outTransText := GetLines(TransText);
    end;

    local procedure GetLines(inTxt: Text) outTxt: Text;

    begin
        if copystr(inTxt, 1, 1) <> '[' then
            exit;
        while copystr(inTxt, 1, 1) = '[' do
            inTxt := DelChr(inTxt, '<', '[');
        inTxt := DelChr(inTxt, '<', '"');
        outTxt := CopyStr(inTxt, 1, strpos(inTxt, '"') - 1);
        if StrPos(inTxt, '],[') > 0 then begin
            inTxt := CopyStr(inTxt, StrPos(inTxt, '],[') + 3);
            inTxt := DelChr(inTxt, '<', '"');
            outTxt += CopyStr(inTxt, 1, strpos(inTxt, '"') - 1);
        end;
    end;

    var
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        TransText: text;
        CurrencyRate: Record "Currency Exchange Rate" temporary;
        Currency: Record Currency;
        InvExchRate: Decimal;
}