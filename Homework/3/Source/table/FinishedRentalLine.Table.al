table 66040 "ALLUFinishedRentalLine"
{
    Caption = 'Finished Auto Rent Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "ALLUFinishedRentalHeader";
            Editable = false;
            ToolTip = 'Specifies the document number.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the line number.';
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionMembers = " ",Item,Resource;
            OptionCaption = ' ,Item,Resource';
            Editable = false;
            ToolTip = 'Specifies the line type.';
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            TableRelation = IF (Type = CONST(Item)) Item
            ELSE IF (Type = CONST(Resource)) Resource;
            Editable = false;
            ToolTip = 'Specifies the item or resource number.';
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the line description.';
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Editable = false;
            ToolTip = 'Specifies the quantity.';
        }
        field(7; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
            Editable = false;
            ToolTip = 'Specifies the unit price.';
        }
        field(8; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 2;
            Editable = false;
            ToolTip = 'Specifies the line amount.';
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(AmountKey; "Document No.")
        {
            SumIndexFields = Amount;
        }
    }
}
