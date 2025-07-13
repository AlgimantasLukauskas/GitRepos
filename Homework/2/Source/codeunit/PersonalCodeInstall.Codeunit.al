codeunit 66011 "ALLUPersonalCodeInstall"
{
    Subtype = Install;
    Access = Internal;

    trigger OnInstallAppPerCompany()
    var
        AppInfo: ModuleInfo;
        NotificationMsg: Text;
    begin
        // Get extension information
        NavApp.GetCurrentModuleInfo(AppInfo);

        // Initialize any required setup data
        InitializeSetupData();

        // Create installation notification
        NotificationMsg := 'Personal Code Validator extension installed successfully!\n\n' +
                          'To access the validator:\n' +
                          '• Press Alt+Q (Tell Me) and search for "Personal Code Validator"\n' +
                          '• Or navigate to the extension from the search\n\n' +
                          'Version: ' + Format(AppInfo.AppVersion) + '\n' +
                          'Company: ' + CompanyName;

        Message(NotificationMsg);
    end;

    local procedure InitializeSetupData()
    begin
        // No initialization required for this extension
        // Tables are created automatically by the platform
        // This procedure is kept for future extensibility
    end;
}
