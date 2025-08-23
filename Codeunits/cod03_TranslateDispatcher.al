codeunit 78603 "BAC Translate Dispatcher"
{
    var
        CachedSetup: Record "BAC Translation Setup";
        SetupLoaded: Boolean;

    procedure Translate(ProjectCode: Text[20]; SourceLang: Text[10]; TargetLang: Text[10]; TextToTranslate: Text[2048]): Text[2048]
    var
        GPT: Codeunit "BAC GPT Translate Rest";
        Google: Codeunit "BAC Google Translate Rest";
    begin
        EnsureSetupLoaded();

        if CachedSetup."Use ChatGPT" then
            exit(GPT.Translate(ProjectCode, SourceLang, TargetLang, TextToTranslate))
        else
            exit(Google.Translate(ProjectCode, SourceLang, TargetLang, TextToTranslate));
    end;

    procedure UseChatGPT(): Boolean
    begin
        EnsureSetupLoaded();
        exit(CachedSetup."Use ChatGPT");
    end;

    local procedure EnsureSetupLoaded()
    begin
        if SetupLoaded then
            exit;

        if not CachedSetup.Get() then
            Error('Translation setup is missing.');

        SetupLoaded := true;
    end;
}
