page 66037 "ALLUAutoDamageList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ALLUAutoDamage";
    Caption = 'Auto damage';//lowercase 'd' in FDD
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
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line number';
                    Visible = false;
                }
                field("Date"; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the damage date';
                    StyleExpr = StatusStyleExpr;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the damage description';
                    StyleExpr = StatusStyleExpr;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the damage status';
                    StyleExpr = StatusStyleExpr;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(MarkAsRemoved)
            {
                Caption = 'Mark as Removed';
                ApplicationArea = All;
                Image = Delete;
                Enabled = Rec.Status = Rec.Status::Active;
                ToolTip = 'Mark the damage as removed';

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Removed;
                    Rec.Modify(true);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetStatusStyle();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetStatusStyle();
    end;

    var
        StatusStyleExpr: Text;

    local procedure SetStatusStyle()
    begin
        StatusStyleExpr := '';
        if Rec.Status = Rec.Status::Removed then
            StatusStyleExpr := 'Subordinate';
    end;
}
