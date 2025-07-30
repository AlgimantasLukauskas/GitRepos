page 66035 "ALLUAutoReservationList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ALLUAutoReservation";
    Caption = 'Auto Reservation';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Auto No."; Rec."Auto No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the automobile number';
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number';
                    Visible = false; // Hide auto-generated numbers
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer number';
                }
                field(CustomerName; GetCustomerName())
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                    Editable = false;
                    ToolTip = 'Specifies the customer name';
                }
                field("Reserved From"; Rec."Reserved From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reservation start date and time';
                    StyleExpr = ReservationStyle;
                }
                field("Reserved To"; Rec."Reserved To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reservation end date and time';
                    StyleExpr = ReservationStyle;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ShowAuto)
            {
                Caption = 'Show Auto';
                ApplicationArea = All;
                Image = View;
                ToolTip = 'View the automobile card';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Auto: Record "ALLUAutomobile";
                begin
                    if Auto.Get(Rec."Auto No.") then
                        PAGE.Run(PAGE::"ALLUAutomobileCard", Auto);
                end;
            }
            action(ShowCustomer)
            {
                Caption = 'Show Customer';
                ApplicationArea = All;
                Image = Customer;
                ToolTip = 'View the customer card';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Customer: Record Customer;
                begin
                    if Customer.Get(Rec."Customer No.") then
                        PAGE.Run(PAGE::"Customer Card", Customer);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetReservationStyle();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetReservationStyle();
    end;

    var
        ReservationStyle: Text;

    local procedure GetCustomerName(): Text[100]
    var
        Customer: Record Customer;
    begin
        if Customer.Get(Rec."Customer No.") then
            exit(Customer.Name);
    end;

    local procedure SetReservationStyle()
    begin
        ReservationStyle := '';
        if Rec."Reserved From" < CurrentDateTime then
            ReservationStyle := 'Subordinate'; // Gray out past reservations
    end;
}
