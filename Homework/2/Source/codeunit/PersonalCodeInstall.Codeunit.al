
codeunit 66011 "ALLUPersonalCodeInstall"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        // This automatically runs every time you deploy/run the extension
        Message('Personal Code Validator extension installed successfully!\n\nTo open the validator:\n1. Press Alt+Q (Tell Me)\n2. Search for "Personal Code Validator"\n3. Click to open');
    end;
}
