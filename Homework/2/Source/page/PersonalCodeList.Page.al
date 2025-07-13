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
                    Width = 15;
                }
                field("Validation Date"; Rec."Validation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date and time when the validation was performed';
                    Width = 18;
                }
                field("Is Valid"; Rec."Is Valid")
                {
                    ApplicationArea = All;
                    ToolTip = 'Whether the personal code is valid';
                    StyleExpr = ValidationStyleExpr;
                    Width = 10;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Error message if validation failed';
                    Visible = not Rec."Is Valid";
                    Width = 30;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    ToolTip = 'Gender extracted from the personal code';
                    Visible = Rec."Is Valid";
                    Width = 10;
                }
                field("Birth Date"; Rec."Birth Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Birth date extracted from the personal code';
                    Visible = Rec."Is Valid";
                    Width = 12;
                }
                field(Century; Rec.Century)
                {
                    ApplicationArea = All;
                    ToolTip = 'Century extracted from the personal code';
                    Visible = Rec."Is Valid";
                    Width = 10;
                }
                field("Serial Number"; Rec."Serial Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Serial number extracted from the personal code';
                    Visible = Rec."Is Valid";
                    Width = 12;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'User who performed the validation';
                    Width = 15;
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
                PromotedOnly = true;
                ToolTip = 'Clear all validation history';

                trigger OnAction()
                var
                    ConfirmMsg: Label 'Are you sure you want to clear all validation history?';
                    SuccessMsg: Label 'All validation history has been cleared.';
                begin
                    if Confirm(ConfirmMsg) then begin
                        Rec.DeleteAll();
                        Message(SuccessMsg);
                        CurrPage.Update(false);
                    end;
                end;
            }

            action(RefreshData)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Refresh the validation history data';

                trigger OnAction()
                begin
                    CurrPage.Update(false);
                end;
            }
        }
        area(Navigation)
        {
            action(FilterByUser)
            {
                ApplicationArea = All;
                Caption = 'Filter by User';
                Image = FilterLines;
                ToolTip = 'Filter records by specific user';

                trigger OnAction()
                var
                    UserID: Code[50];
                begin
                    UserID := UserId;
                    if UserID <> '' then begin
                        Rec.SetFilter("User ID", UserID);
                        CurrPage.Update(false);
                    end;
                end;
            }
            action(FilterByDate)
            {
                ApplicationArea = All;
                Caption = 'Filter by Date Range';
                Image = DateRange;
                ToolTip = 'Filter records by date range';

                trigger OnAction()
                var
                    FromDate: DateTime;
                    ToDate: DateTime;
                begin
                    FromDate := CreateDateTime(Today - 30, 0T); // Default to last 30 days
                    ToDate := CreateDateTime(Today, 235959T);

                    if (FromDate <> 0DT) and (ToDate <> 0DT) then begin
                        Rec.SetFilter("Validation Date", '%1..%2', FromDate, ToDate);
                        CurrPage.Update(false);
                    end;
                end;
            }
            action(ClearFilters)
            {
                ApplicationArea = All;
                Caption = 'Clear Filters';
                Image = ClearFilter;
                ToolTip = 'Clear all applied filters';

                trigger OnAction()
                begin
                    Rec.SetRange("User ID");
                    Rec.SetRange("Validation Date");
                    Rec.SetRange("Is Valid");
                    CurrPage.Update(false);
                end;
            }
        }
    }

    views
    {
        view(ValidOnly)
        {
            Caption = 'Valid Codes Only';
            Filters = where("Is Valid" = const(true));
            OrderBy = descending("Validation Date");
        }
        view(InvalidOnly)
        {
            Caption = 'Invalid Codes Only';
            Filters = where("Is Valid" = const(false));
            OrderBy = descending("Validation Date");
        }
        view(Recent)
        {
            Caption = 'Recent (Last 7 Days)';
            SharedLayout = false;
            OrderBy = descending("Validation Date");
        }
    }

    var
        ValidationStyleExpr: Text;

    trigger OnAfterGetRecord()
    begin
        SetValidationStyle();
    end;

    trigger OnOpenPage()
    begin
        // Set default sorting by validation date descending
        Rec.SetCurrentKey("Validation Date");
        Rec.Ascending(false);
    end;



    local procedure SetValidationStyle()
    begin
        if Rec."Is Valid" then
            ValidationStyleExpr := 'Favorable'
        else
            ValidationStyleExpr := 'Unfavorable';
    end;
}
