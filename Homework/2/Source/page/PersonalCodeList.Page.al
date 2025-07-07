// History page
page 66008 "ALLUPersonalCodeList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "ALLUPersonalCodeVal";
    Caption = 'Personal Code Validation History';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(HistoryRepeater)
            {
                field("Personal Code"; Rec."Personal Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'The personal code that was validated';
                }
                field("Validation Date"; Rec."Validation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date and time when the validation was performed';
                }
                field("Is Valid"; Rec."Is Valid")
                {
                    ApplicationArea = All;
                    ToolTip = 'Whether the personal code is valid';
                    StyleExpr = ValidationStyleExpr;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Error message if validation failed';
                    Visible = not Rec."Is Valid";
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    ToolTip = 'Gender extracted from the personal code';
                    Visible = Rec."Is Valid";
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Birth date extracted from the personal code';
                    Visible = Rec."Is Valid";
                }
                field(Century; Rec.Century)
                {
                    ApplicationArea = All;
                    ToolTip = 'Century extracted from the personal code';
                    Visible = Rec."Is Valid";
                }
                field("Serial Number"; Rec."Serial Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Serial number extracted from the personal code';
                    Visible = Rec."Is Valid";
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'User who performed the validation';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ClearAll)
            {
                ApplicationArea = All;
                Caption = 'Clear All History';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Clear all validation history';

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to clear all validation history?') then begin
                        Rec.DeleteAll();
                        Message('All validation history has been cleared.');
                    end;
                end;
            }
        }
    }

    var
        ValidationStyleExpr: Text;

    trigger OnAfterGetRecord()
    begin
        if Rec."Is Valid" then
            ValidationStyleExpr := 'Favorable'
        else
            ValidationStyleExpr := 'Unfavorable';
    end;
}
