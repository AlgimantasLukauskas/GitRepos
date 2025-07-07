// Temporary table for validation results
table 66005 "ALLUPersonalCodeResult"
{
    TableType = Temporary;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Is Valid"; Boolean)
        {
            Caption = 'Is Valid';
        }
        field(3; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
        }
        field(4; Gender; Text[10])
        {
            Caption = 'Gender';
        }
        field(5; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
        }
        field(6; "Serial Number"; Integer)
        {
            Caption = 'Serial Number';
        }
        field(7; Century; Text[20])
        {
            Caption = 'Century';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
