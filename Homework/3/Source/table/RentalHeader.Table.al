table 66036 "ALLURentalHeader"
{
    Caption = 'Auto Rent Header';
    DataClassification = CustomerContent;
    LookupPageId = "ALLURentalList";
    DrillDownPageId = "ALLURentalList";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the document number.';

            trigger OnValidate()
            var
                NoSeries: Codeunit "No. Series";
            begin
                if "No." <> xRec."No." then begin
                    GetAutoSetup();
                    NoSeries.TestManual(AutoSetup."Rental Card No. Series");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
            ToolTip = 'Specifies the customer number.';

            trigger OnValidate()
            var
                AutoMgt: Codeunit "ALLUAutoManagement";
            begin
                if "Customer No." = '' then
                    exit;

                if Status = Status::Released then
                    TestField(Status, Status::Open);

                AutoMgt.CheckCustomerDebts("Customer No.");
            end;
        }
        field(3; "Driver License"; Media)
        {
            Caption = 'Driver License';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the driver license image.';
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the document date.';
        }
        field(5; "Auto No."; Code[20])
        {
            Caption = 'Auto No.';
            DataClassification = CustomerContent;
            TableRelation = "ALLUAutomobile";
            ToolTip = 'Specifies the automobile number.';

            trigger OnValidate()
            var
                AutoMgt: Codeunit "ALLUAutoManagement";
            begin
                if "Auto No." = '' then
                    exit;

                if Status = Status::Released then
                    TestField(Status, Status::Open);

                AutoMgt.CreateInitialRentalLine("No.", "Auto No.");
            end;
        }
        field(6; "Reserved From"; Date)
        {
            Caption = 'Reserved From Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the rental start date.';

            trigger OnValidate()
            begin
                if Status = Status::Released then
                    TestField(Status, Status::Open);

                if "Reserved From" <> 0D then begin
                    if "Reserved From" < WorkDate() then
                        Error(PastDateErr);

                    if ("Reserved To" <> 0D) and ("Reserved From" > "Reserved To") then
                        Error(DateOrderErr);

                    CheckReservation();
                end;
            end;
        }
        field(7; "Reserved To"; Date)
        {
            Caption = 'Reserved To Date';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the rental end date.';

            trigger OnValidate()
            begin
                if Status = Status::Released then
                    TestField(Status, Status::Open);

                if "Reserved To" <> 0D then begin
                    if ("Reserved From" <> 0D) and ("Reserved To" < "Reserved From") then
                        Error(DateOrderErr);

                    CheckReservation();
                end;
            end;
        }
        field(8; Amount; Decimal)
        {
            Caption = 'Amount';
            FieldClass = FlowField;
            CalcFormula = Sum("ALLURentalLine".Amount WHERE("Document No." = FIELD("No.")));
            Editable = false;
            ToolTip = 'Specifies the total rental amount.';
        }
        field(9; Status; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionMembers = Open,Released;
            OptionCaption = 'Open,Released';
            Editable = false;
            ToolTip = 'Specifies the document status.';
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
    }

    var
        AutoSetup: Record "ALLUAutoSetup";
        ReservationMismatchErr: Label 'Reservation dates do not match with auto reservation';
        PastDateErr: Label 'Cannot create rental for past dates.';
        DateOrderErr: Label 'Reserved From must be before or equal to Reserved To.';

    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
    begin
        if "No." = '' then begin
            GetAutoSetup();
            AutoSetup.TestField("Rental Card No. Series");

            "No. Series" := AutoSetup."Rental Card No. Series";

            if NoSeries.AreRelated(AutoSetup."Rental Card No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";

            "No." := NoSeries.GetNextNo("No. Series");
        end;

        Status := Status::Open;
        Date := WorkDate();
    end;

    local procedure GetAutoSetup()
    begin
        AutoSetup.GetRecordOnce();
    end;

    local procedure CheckReservation()
    var
        AutoReservation: Record "ALLUAutoReservation";
    begin
        if ("Auto No." = '') or ("Reserved From" = 0D) or ("Reserved To" = 0D) or ("Customer No." = '') then
            exit;

        AutoReservation.SetRange("Auto No.", "Auto No.");
        AutoReservation.SetRange("Customer No.", "Customer No.");
        AutoReservation.SetFilter("Reserved From", '%1..%2',
            CreateDateTime("Reserved From", 000000T),
            CreateDateTime("Reserved From", 235959T));
        AutoReservation.SetFilter("Reserved To", '%1..%2',
            CreateDateTime("Reserved To", 000000T),
            CreateDateTime("Reserved To", 235959T));
        if AutoReservation.IsEmpty() then
            Error(ReservationMismatchErr);
    end;

    procedure ChangeStatusToReleased()
    begin
        TestField(Status, Status::Open);
        TestField("Customer No.");
        TestField("Auto No.");
        TestField("Reserved From");
        TestField("Reserved To");

        Status := Status::Released;
        Modify(true);
    end;

    procedure ReturnAuto()
    var
        AutoMgt: Codeunit "ALLUAutoManagement";
    begin
        TestField(Status, Status::Released);
        AutoMgt.ProcessAutoReturn(Rec);
    end;

    procedure AssistEdit(OldRentalHeader: Record "ALLURentalHeader"): Boolean
    var
        NoSeries: Codeunit "No. Series";
    begin
        GetAutoSetup();
        AutoSetup.TestField("Rental Card No. Series");

        if NoSeries.LookupRelatedNoSeries(AutoSetup."Rental Card No. Series", OldRentalHeader."No. Series", "No. Series") then begin
            "No." := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
    end;
}
