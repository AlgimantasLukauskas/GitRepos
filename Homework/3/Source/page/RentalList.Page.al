page 66038 "ALLURentalList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ALLURentalHeader";
    Caption = 'Auto Rent Header';
    CardPageId = "ALLURentalCard";

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
                field(AutoName; GetAutoName())
                {
                    ApplicationArea = All;
                    Caption = 'Auto Name';
                    Editable = false;
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document status';
                    StyleExpr = StatusStyleExpr;
                }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action(New)
            {
                Caption = 'New';
                ApplicationArea = All;
                Image = New;
                RunObject = Page "ALLURentalCard";
                RunPageMode = Create;
                ToolTip = 'Create a new rental document';
                Promoted = true;
                PromotedCategory = New;
                PromotedOnly = true;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetStatusStyle();
    end;

    var
        StatusStyleExpr: Text;

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

    local procedure SetStatusStyle()
    begin
        StatusStyleExpr := '';
        case Rec.Status of
            Rec.Status::Released:
                StatusStyleExpr := 'Favorable';
        end;
    end;
}
