page 66036 "ALLUValidReservations"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ALLUAutoReservation";
    Caption = 'Valid Reservations';
    SourceTableView = sorting("Reserved From");
    Editable = false;

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
                field(AutoName; GetAutoName())
                {
                    ApplicationArea = All;
                    Caption = 'Auto Name';
                    ToolTip = 'Specifies the automobile name';
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
                    ToolTip = 'Specifies the customer name';
                }
                field("Reserved From"; Rec."Reserved From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reservation start date and time';
                }
                field("Reserved To"; Rec."Reserved To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reservation end date and time';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Reserved From", '>=%1', CreateDateTime(Today(), 0T));
    end;

    local procedure GetAutoName(): Text[100]
    var
        Auto: Record "ALLUAutomobile";
    begin
        if Auto.Get(Rec."Auto No.") then
            exit(Auto.Name);
    end;

    local procedure GetCustomerName(): Text[100]
    var
        Customer: Record Customer;
    begin
        if Customer.Get(Rec."Customer No.") then
            exit(Customer.Name);
    end;
}
