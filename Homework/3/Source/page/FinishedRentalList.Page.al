page 66043 "ALLUFinishedRentalList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ALLUFinishedRentalHeader";
    Caption = 'Finished Auto Rent Header';
    CardPageId = "ALLUFinishedRentalCard";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number';
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
                field("Date"; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document date';
                }
                field("Auto No."; Rec."Auto No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the automobile number';
                }
                field("Reserved From"; Rec."Reserved From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rental start date';
                }
                field("Reserved To"; Rec."Reserved To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rental end date';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total rental amount';
                }
            }
        }
    }

    actions
    {
        area(Reporting)
        {
            action(Print)
            {
                Caption = 'Print Contract';
                ApplicationArea = All;
                Image = Print;
                ToolTip = 'Print the rental contract';
                Promoted = true;
                PromotedCategory = Report;
                PromotedOnly = true;

                trigger OnAction()
                var
                    FinishedRentalHeader: Record "ALLUFinishedRentalHeader";
                begin
                    FinishedRentalHeader := Rec;
                    FinishedRentalHeader.SetRecFilter();
                    Report.Run(66030, true, true, FinishedRentalHeader);
                end;
            }
        }
    }

    local procedure GetCustomerName(): Text[100]
    var
        Customer: Record Customer;
    begin
        if Customer.Get(Rec."Customer No.") then
            exit(Customer.Name);
    end;
}
