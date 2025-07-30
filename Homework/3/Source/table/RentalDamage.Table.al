table 66038 "ALLURentalDamage"
{
    Caption = 'Auto Rent Damage';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "ALLURentalHeader";
            ToolTip = 'Specifies the document number.';
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
            ToolTip = 'Specifies the damage date.';

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
            ToolTip = 'Specifies the damage description.';

            trigger OnValidate()
            begin
                TestField(Description);
            end;
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        RentalHeader: Record "ALLURentalHeader";
    begin
        TestField("Document No.");

        if Date = 0D then
            Date := WorkDate();

        if RentalHeader.Get("Document No.") then
            RentalHeader.TestField(Status, RentalHeader.Status::Released);
    end;
}
