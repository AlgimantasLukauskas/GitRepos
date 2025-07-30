table 66033 "ALLUAutomobile"
{
    Caption = 'Auto';
    DataClassification = CustomerContent;
    LookupPageId = "ALLUAutomobileList";
    DrillDownPageId = "ALLUAutomobileList";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the automobile number.';

            trigger OnValidate()
            var
                NoSeries: Codeunit "No. Series";
            begin
                if "No." <> xRec."No." then begin
                    GetAutoSetup();
                    NoSeries.TestManual(AutoSetup."Automobile No. Series");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the automobile name.';
        }
        field(3; "Mark Code"; Code[20])
        {
            Caption = 'Mark';
            DataClassification = CustomerContent;
            TableRelation = "ALLUAutoMark";
            ToolTip = 'Specifies the automobile mark from marks classifier.';

            trigger OnValidate()
            begin
                if "Mark Code" <> xRec."Mark Code" then
                    Validate("Model Code", ''); // Clear model when mark changes
            end;
        }
        field(4; "Model Code"; Code[20])
        {
            Caption = 'Model';
            DataClassification = CustomerContent;
            TableRelation = "ALLUAutoModel".Code WHERE("Mark Code" = FIELD("Mark Code"));
            ToolTip = 'Specifies the automobile model. Model must be shown only for that mark.';

            trigger OnValidate()
            var
                AutoModel: Record "ALLUAutoModel";
            begin
                if "Model Code" <> '' then begin
                    TestField("Mark Code"); // Mark must be selected first
                    AutoModel.Get("Mark Code", "Model Code"); // Validate model exists
                end;
            end;
        }
        field(5; "Manufacturing Year"; Integer)
        {
            Caption = 'Manufacturing Year';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the manufacturing year.';

            trigger OnValidate()
            begin
                if "Manufacturing Year" <> 0 then
                    if ("Manufacturing Year" < 1900) or ("Manufacturing Year" > Date2DMY(WorkDate(), 3) + 1) then
                        Error(InvalidYearErr, 1900, Date2DMY(WorkDate(), 3) + 1);
            end;
        }
        field(6; "Civil Insurance Valid Until"; Date)
        {
            Caption = 'Civil Insurance Valid Until';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the civil insurance validity date.';

            trigger OnValidate()
            begin
                if ("Civil Insurance Valid Until" <> 0D) and ("Civil Insurance Valid Until" < WorkDate()) then
                    Message(InsuranceExpiredMsg);
            end;
        }
        field(7; "TI Valid Until"; Date)
        {
            Caption = 'TI Valid Until';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the technical inspection validity date.';

            trigger OnValidate()
            begin
                if ("TI Valid Until" <> 0D) and ("TI Valid Until" < WorkDate()) then
                    Message(TechnicalInspectionExpiredMsg);
            end;
        }
        field(8; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location;
            ToolTip = 'Specifies the location code.';
        }
        field(9; "Rental Service"; Code[20])
        {
            Caption = 'Rental Service';
            DataClassification = CustomerContent;
            TableRelation = Resource;
            ToolTip = 'Specifies the rental service resource.';

            trigger OnValidate()
            begin
                CalcFields("Rental Price"); // Update the rental price
            end;
        }
        field(10; "Rental Price"; Decimal)
        {
            Caption = 'Rental Price';
            FieldClass = FlowField;
            CalcFormula = Lookup(Resource."Unit Price" WHERE("No." = FIELD("Rental Service")));
            Editable = false;
            ToolTip = 'Specifies the rental price from resource.';
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
        InvalidYearErr: Label 'Manufacturing year must be between %1 and %2.', Comment = '%1 = Min Year, %2 = Max Year';
        InsuranceExpiredMsg: Label 'Civil insurance has expired.';
        TechnicalInspectionExpiredMsg: Label 'Technical inspection has expired.';

    trigger OnInsert()
    var
        NoSeries: Codeunit "No. Series";
    begin
        if "No." = '' then begin
            GetAutoSetup();
            AutoSetup.TestField("Automobile No. Series");

            // New pattern: Set default series
            "No. Series" := AutoSetup."Automobile No. Series";

            // Check if xRec series is related and use it if so
            if NoSeries.AreRelated(AutoSetup."Automobile No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";

            // Get the next number
            "No." := NoSeries.GetNextNo("No. Series");
        end;
    end;

    local procedure GetAutoSetup()
    begin
        AutoSetup.GetRecordOnce();
    end;

    procedure AssistEdit(OldAuto: Record "ALLUAutomobile"): Boolean
    var
        NoSeries: Codeunit "No. Series";
    begin
        GetAutoSetup();
        AutoSetup.TestField("Automobile No. Series");

        // Use the new LookupRelatedNoSeries method
        if NoSeries.LookupRelatedNoSeries(AutoSetup."Automobile No. Series", OldAuto."No. Series", "No. Series") then begin
            "No." := NoSeries.GetNextNo("No. Series");
            exit(true);
        end;
    end;
}
