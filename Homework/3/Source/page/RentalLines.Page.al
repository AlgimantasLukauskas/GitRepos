page 66041 "ALLURentalLines"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "ALLURentalLine";
    Caption = 'Auto Rent Lines';
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line type';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item or resource number';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line description';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit price';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line amount';
                }
            }
        }
    }
}
