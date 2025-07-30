table 66031 "ALLUAutoMark"
{
    Caption = 'Auto Mark';
    DataClassification = CustomerContent;
    LookupPageId = "ALLUAutoMarkList";
    DrillDownPageId = "ALLUAutoMarkList";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the automobile mark code.';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the automobile mark description.';
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
