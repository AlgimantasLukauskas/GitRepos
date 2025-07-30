page 66039 "ALLUReleasedRentalContracts"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ALLURentalHeader";
    Caption = 'Released Auto Contracts';
    CardPageId = "ALLURentalCard";
    SourceTableView = where(Status = const(Released));
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
                field(AutoName; GetAutoName())
                {
                    ApplicationArea = All;
                    Caption = 'Auto Name';
                    ToolTip = 'Specifies the automobile name';
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
        area(Processing)
        {
            action(ReturnAuto)
            {
                Caption = 'Return Auto';
                ApplicationArea = All;
                Image = Return;
                ToolTip = 'Process the automobile return';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    if Confirm(ReturnAutoQst) then begin
                        Rec.ReturnAuto();
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    var
        ReturnAutoQst: Label 'Do you want to process the automobile return?';

    local procedure GetCustomerName(): Text[100]
    var
        Customer: Record Customer;
    begin
        if Customer.Get(Rec."Customer No.") then
            exit(Customer.Name);
    end;

    local procedure GetAutoName(): Text[100]
    var
        Auto: Record "ALLUAutomobile";
    begin
        if Auto.Get(Rec."Auto No.") then
            exit(Auto.Name);
    end;
}
