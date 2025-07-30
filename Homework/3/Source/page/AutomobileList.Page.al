page 66033 "ALLUAutomobileList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ALLUAutomobile";
    Caption = 'Auto';
    CardPageId = "ALLUAutomobileCard";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the automobile number';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the automobile name';
                }
                field("Mark Code"; Rec."Mark Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the automobile mark';
                }
                field("Model Code"; Rec."Model Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the automobile model';
                }
                field("Manufacturing Year"; Rec."Manufacturing Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the manufacturing year';
                }
                field("Rental Price"; Rec."Rental Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rental price';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group(Auto)
            {
                Caption = 'Auto';

                action(Reservations)
                {
                    Caption = 'Reservations';
                    ApplicationArea = All;
                    Image = Reserve;
                    RunObject = Page "ALLUAutoReservationList";
                    RunPageLink = "Auto No." = FIELD("No.");
                    ToolTip = 'View the reservations for this automobile';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                }
                action(Damages)
                {
                    Caption = 'Damages';
                    ApplicationArea = All;
                    Image = Warning;
                    RunObject = Page "ALLUAutoDamageList";
                    RunPageLink = "Auto No." = FIELD("No.");
                    ToolTip = 'View the damages for this automobile';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                }
            }
        }
        area(Reporting)
        {
            action(RentalHistory)
            {
                Caption = 'Rental History';
                ApplicationArea = All;
                Image = Report;
                ToolTip = 'Print the rental history for this automobile';
                Promoted = true;
                PromotedCategory = Report;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Auto: Record "ALLUAutomobile";
                begin
                    CurrPage.SetSelectionFilter(Auto);
                    Report.Run(66031, true, true, Auto); // Use report number directly
                end;
            }
        }
        area(Creation)
        {
            action(New)
            {
                Caption = 'New';
                ApplicationArea = All;
                Image = New;
                RunObject = Page "ALLUAutomobileCard";
                RunPageMode = Create;
                ToolTip = 'Create a new automobile';
                Promoted = true;
                PromotedCategory = New;
                PromotedOnly = true;
            }
        }
    }
}
