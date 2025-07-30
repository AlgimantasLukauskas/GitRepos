page 66031 "ALLUAutoMarkList"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ALLUAutoMark";
    Caption = 'Auto Mark';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the mark code';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the automobile mark description';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Models)
            {
                Caption = 'Models';
                ApplicationArea = All;
                Image = List;
                RunObject = Page "ALLUAutoModelList";
                RunPageLink = "Mark Code" = FIELD("Code");
                ToolTip = 'View the models for this mark';
            }
        }
    }
}
