// Permission set for Personal Code Validation
permissionset 66009 "ALLUPersonalCodePerm"
{
    Assignable = true;
    Caption = 'Personal Code Validation';
    Permissions =
        tabledata "ALLUPersonalCodeVal" = RIMD,
        tabledata "ALLUPersonalCodeResult" = RIMD,
        table "ALLUPersonalCodeVal" = X,
        table "ALLUPersonalCodeResult" = X,
        page "ALLUPersonalCodeCard" = X,
        page "ALLUPersonalCodeList" = X,
        codeunit "ALLUPersonalCodeMgt" = X,
        codeunit "ALLUPersonalCodeInstall" = X;
}
