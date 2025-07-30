table 66039 "ALLUFinishedRentalHeader"
{
    Caption = 'Finished Auto Rent Header';
    DataClassification = CustomerContent;
    LookupPageId = "ALLUFinishedRentalList";
    DrillDownPageId = "ALLUFinishedRentalList";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the document number.';
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Editable = false;
            ToolTip = 'Specifies the customer number.';
        }
        field(3; "Driver License"; Media)
        {
            Caption = 'Driver License';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the driver license image.';
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the document date.';
        }
        field(5; "Auto No."; Code[20])
        {
            Caption = 'Auto No.';
            DataClassification = CustomerContent;
            TableRelation = "ALLUAutomobile";
            Editable = false;
            ToolTip = 'Specifies the automobile number.';
        }
        field(6; "Reserved From"; Date)
        {
            Caption = 'Reserved From Date';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the rental start date.';
        }
        field(7; "Reserved To"; Date)
        {
            Caption = 'Reserved To Date';
            DataClassification = CustomerContent;
            Editable = false;
            ToolTip = 'Specifies the rental end date.';
        }
        field(8; Amount; Decimal)
        {
            Caption = 'Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("ALLUFinishedRentalLine".Amount WHERE("Document No." = FIELD("No.")));
            Editable = false;
            ToolTip = 'Specifies the total rental amount.';
        }
        field(50; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Editable = false;
            ToolTip = 'Specifies the number series.';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Auto No.", "Reserved From")
        {
        }
    }
}
