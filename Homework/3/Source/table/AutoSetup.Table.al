table 66030 "ALLUAutoSetup"
{
    Caption = 'Auto Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the primary key for the setup record.';
        }
        field(2; "Automobile No. Series"; Code[20])
        {
            Caption = 'Automobile No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the number series for automobiles.';

            trigger OnValidate()
            begin
                if "Automobile No. Series" = "Rental Card No. Series" then
                    Error(SameNoSeriesErr);
            end;
        }
        field(3; "Rental Card No. Series"; Code[20])
        {
            Caption = 'Rental Card No. Series';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the number series for rental cards.';

            trigger OnValidate()
            begin
                if "Rental Card No. Series" = "Automobile No. Series" then
                    Error(SameNoSeriesErr);
            end;
        }
        field(4; "Accessories Location Code"; Code[10])
        {
            Caption = 'Accessories Location Code';
            TableRelation = Location;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the location code for accessories.';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    var
        SameNoSeriesErr: Label 'Automobile and Rental Card must use different number series.';

    trigger OnInsert()
    begin
        if "Primary Key" = '' then
            "Primary Key" := 'AUTO';
    end;

    procedure GetRecordOnce()
    begin
        if not Get() then begin
            Init();
            Insert(true);
        end;
    end;
}
