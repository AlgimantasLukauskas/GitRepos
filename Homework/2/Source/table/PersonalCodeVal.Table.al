// Table to store validation history
table 66004 "ALLUPersonalCodeVal"
{
    DataClassification = CustomerContent;
    Caption = 'Personal Code Validation';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Personal Code"; Code[11])
        {
            Caption = 'Personal Code';
            DataClassification = CustomerContent;
        }
        field(3; "Validation Date"; DateTime)
        {
            Caption = 'Validation Date';
            DataClassification = CustomerContent;
        }
        field(4; "Is Valid"; Boolean)
        {
            Caption = 'Is Valid';
            DataClassification = CustomerContent;
        }
        field(5; "Error Message"; Text[250])
        {
            Caption = 'Error Message';
            DataClassification = CustomerContent;
        }
        field(6; Gender; Text[10])
        {
            Caption = 'Gender';
            DataClassification = CustomerContent;
        }
        field(7; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
            DataClassification = CustomerContent;
        }
        field(8; "Serial Number"; Integer)
        {
            Caption = 'Serial Number';
            DataClassification = CustomerContent;
        }
        field(9; Century; Text[20])
        {
            Caption = 'Century';
            DataClassification = CustomerContent;
        }
        field(10; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(ValidationDate; "Validation Date")
        {
        }
    }
}
