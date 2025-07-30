page 66034 "ALLUAutomobileCard"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "ALLUAutomobile";
    Caption = 'Auto Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the automobile number';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the automobile name';
                }
                field("Mark Code"; Rec."Mark Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the automobile mark from marks classifier';
                }
                field("Model Code"; Rec."Model Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the automobile model. Model must be shown only for that mark';
                }
                field("Manufacturing Year"; Rec."Manufacturing Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the manufacturing year';
                }
            }
            group(Insurance)
            {
                Caption = 'Insurance';

                field("Civil Insurance Valid Until"; Rec."Civil Insurance Valid Until")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the civil insurance validity date';
                }
                field("TI Valid Until"; Rec."TI Valid Until")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the technical inspection validity date';
                }
            }
            group(Rental)
            {
                Caption = 'Rental';

                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code';
                }
                field("Rental Service"; Rec."Rental Service")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rental service resource';
                }
                field("Rental Price"; Rec."Rental Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rental price from resource';
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
                    Auto := Rec;
                    Auto.SetRecFilter();
                    Report.Run(66031, true, true, Auto); // Use report number directly
                end;
            }
        }
    }
}
