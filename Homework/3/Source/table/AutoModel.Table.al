table 66032 "ALLUAutoModel"
{
    Caption = 'Auto Model';
    DataClassification = CustomerContent;
    LookupPageId = "ALLUAutoModelList";
    DrillDownPageId = "ALLUAutoModelList";

    fields
    {
        field(1; "Mark Code"; Code[20])
        {
            Caption = 'Mark Code';
            DataClassification = CustomerContent;
            TableRelation = "ALLUAutoMark";
            NotBlank = true;
            ToolTip = 'Specifies the automobile mark code.';
        }
        field(2; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
            ToolTip = 'Specifies the model code.';
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the automobile model description.';
        }
    }

    keys
    {
        key(PK; "Mark Code", "Code")
        {
            Clustered = true;
        }
    }
}
