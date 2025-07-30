table 66037 "ALLURentalLine"
{
    Caption = 'Auto Rent Line';
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
        field(3; Type; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionMembers = " ",Item,Resource;
            OptionCaption = ' ,Item,Resource';
            ToolTip = 'Specifies the line type.';

            trigger OnValidate()
            begin
                if Type <> xRec.Type then begin
                    Clear("No.");
                    Clear(Description);
                    Clear(Quantity);
                    Clear("Unit Price");
                    Clear(Amount);
                end;
            end;
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            TableRelation = IF (Type = CONST(Item)) Item
            ELSE IF (Type = CONST(Resource)) Resource;
            ToolTip = 'Specifies the item or resource number.';

            trigger OnValidate()
            var
                Item: Record Item;
                Resource: Record Resource;
            begin
                if "No." = '' then begin
                    Clear(Description);
                    Clear("Unit Price");
                    Clear(Amount);
                    exit;
                end;

                TestField(Type);

                case Type of
                    Type::Item:
                        begin
                            Item.Get("No.");
                            Description := Item.Description;
                            "Unit Price" := Item."Unit Price";
                        end;
                    Type::Resource:
                        begin
                            Resource.Get("No.");
                            Description := Resource.Name;
                            "Unit Price" := Resource."Unit Price";
                        end;
                end;
                UpdateAmount();
            end;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the line description.';
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            ToolTip = 'Specifies the quantity.';

            trigger OnValidate()
            begin
                UpdateAmount();
            end;
        }
        field(7; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
            ToolTip = 'Specifies the unit price.';

            trigger OnValidate()
            begin
                UpdateAmount();
            end;
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

    var
        CannotDeleteFirstLineErr: Label 'Cannot delete the first line with rental service';

    trigger OnInsert()
    begin
        TestField("Document No.");
        CheckHeaderStatus();
    end;

    trigger OnModify()
    begin
        CheckHeaderStatus();
    end;

    trigger OnDelete()
    begin
        CheckHeaderStatus();
        CheckFirstLineDelete();
    end;

    local procedure UpdateAmount()
    begin
        Amount := Round(Quantity * "Unit Price", 0.01);
    end;

    local procedure CheckFirstLineDelete()
    var
        RentalHeader: Record "ALLURentalHeader";
        Auto: Record "ALLUAutomobile";
    begin
        if "Line No." <> 10000 then
            exit;

        if not RentalHeader.Get("Document No.") then
            exit;

        if RentalHeader."Auto No." = '' then
            exit;

        if not Auto.Get(RentalHeader."Auto No.") then
            exit;

        if (Type = Type::Resource) and ("No." = Auto."Rental Service") then
            Error(CannotDeleteFirstLineErr);
    end;

    local procedure CheckHeaderStatus()
    var
        RentalHeader: Record "ALLURentalHeader";
    begin
        if RentalHeader.Get("Document No.") then
            RentalHeader.TestField(Status, RentalHeader.Status::Open);
    end;
}
