table 66035 "ALLUAutoDamage"
{
    Caption = 'Auto Damage';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Auto No."; Code[20])
        {
            Caption = 'Auto No.';
            DataClassification = CustomerContent;
            TableRelation = "ALLUAutomobile";
            ToolTip = 'Specifies the automobile number.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the line number.';
        }
        field(3; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the date when the damage was recorded.';

            trigger OnValidate()
            begin
                if Date = 0D then
                    Date := WorkDate();
            end;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            ToolTip = 'Will record damage description.';
        }
        field(5; Status; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionMembers = Active,Removed;
            OptionCaption = 'Active,Removed';
            ToolTip = 'Specifies whether the damage is active or has been removed.';
        }
    }

    keys
    {
        key(PK; "Auto No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
