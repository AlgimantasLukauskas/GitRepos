page 66042 "ALLURentalDamageList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ALLURentalDamage";
    Caption = 'Auto Rent Damage List';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number';
                    Visible = false; // Usually hidden when called from document
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number';
                    Visible = false; // Hide auto-generated line numbers
                }
                field("Date"; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the damage date';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the damage description';
                }
            }
        }
    }
}
