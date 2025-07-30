page 66030 "ALLUAutoSetup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ALLUAutoSetup";
    Caption = 'Auto Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Automobile No. Series"; Rec."Automobile No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for automobiles';
                }
                field("Rental Card No. Series"; Rec."Rental Card No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for rental cards';
                }
                field("Accessories Location Code"; Rec."Accessories Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code for accessories';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetRecordOnce();
    end;
}
