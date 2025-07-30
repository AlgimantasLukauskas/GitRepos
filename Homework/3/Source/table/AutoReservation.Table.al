table 66034 "ALLUAutoReservation"
{
    Caption = 'Auto Reservation';
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
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
            ToolTip = 'Specifies the customer number.';

            trigger OnValidate()
            var
                AutoMgt: Codeunit "ALLUAutoManagement";
            begin
                if "Customer No." <> '' then
                    AutoMgt.CheckCustomerDebts("Customer No.");
            end;
        }
        field(4; "Reserved From"; DateTime)
        {
            Caption = 'Reserved From Date Time';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the reservation start date and time.';

            trigger OnValidate()
            begin
                if "Reserved From" <> 0DT then begin
                    if "Reserved From" < CurrentDateTime then
                        Error(PastReservationErr);
                    CheckReservationOverlap();
                end;
            end;
        }
        field(5; "Reserved To"; DateTime)
        {
            Caption = 'Reserved To Date Time';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the reservation end date and time.';

            trigger OnValidate()
            begin
                if "Reserved To" <> 0DT then
                    CheckReservationOverlap();
            end;
        }
    }

    keys
    {
        key(PK; "Auto No.", "Line No.")
        {
            Clustered = true;
        }
        key(DateKey; "Reserved From")
        {
        }
    }

    var
        ReservationOverlapErr: Label 'Reservation overlaps with existing reservation for this period.';
        ReservedFromBeforeToErr: Label 'Reserved From must be before Reserved To.';
        PastReservationErr: Label 'Cannot create reservations in the past.';

    trigger OnInsert()
    begin
        TestField("Auto No.");
        TestField("Customer No.");
        TestField("Reserved From");
        TestField("Reserved To");
    end;

    local procedure CheckReservationOverlap()
    var
        AutoReservation: Record "ALLUAutoReservation";
    begin
        if ("Reserved From" = 0DT) or ("Reserved To" = 0DT) then
            exit;

        if "Reserved From" >= "Reserved To" then
            Error(ReservedFromBeforeToErr);

        AutoReservation.SetRange("Auto No.", "Auto No.");
        AutoReservation.SetFilter("Line No.", '<>%1', "Line No.");
        if AutoReservation.FindSet() then
            repeat
                if (("Reserved From" >= AutoReservation."Reserved From") and ("Reserved From" <= AutoReservation."Reserved To")) or
                   (("Reserved To" >= AutoReservation."Reserved From") and ("Reserved To" <= AutoReservation."Reserved To")) or
                   (("Reserved From" <= AutoReservation."Reserved From") and ("Reserved To" >= AutoReservation."Reserved To"))
                then
                    Error(ReservationOverlapErr);
            until AutoReservation.Next() = 0;
    end;
}
