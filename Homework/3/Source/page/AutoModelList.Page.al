page 66032 "ALLUAutoModelList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ALLUAutoModel";
    Caption = 'Auto Model';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Mark Code"; Rec."Mark Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the mark code';
                    Editable = not IsMarkFiltered;
                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the model code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the automobile model description';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        IsMarkFiltered := Rec.GetFilter("Mark Code") <> '';
    end;

    var
        IsMarkFiltered: Boolean;
}
