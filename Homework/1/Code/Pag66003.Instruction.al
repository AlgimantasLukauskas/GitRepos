// ========================================
// PAGE objektas demonstravimui
// ========================================

page 66003 "Instruction"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'Praktikantų užduočių demonstracija';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            group(Instructions)
            {
                Caption = 'Instrukcijos';
                field(InstructionText; InstructionTxt)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    Style = Attention;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(TaskActions)
            {
                Caption = 'Užduotys';

                action(RunTask1)
                {
                    ApplicationArea = All;
                    Caption = 'Užduotis 1: Teksto apvertimas';
                    Image = Process;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Paleisti pirmą užduotį - teksto apvertimas';

                    trigger OnAction()
                    var
                        HomeworkTasks: Codeunit "Homework";
                    begin
                        HomeworkTasks.RunTask1Demo();
                    end;
                }

                action(RunTask2)
                {
                    ApplicationArea = All;
                    Caption = 'Užduotis 2: Min/Max paieška';
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Paleisti antrą užduotį - mažiausio ir didžiausio skaičiaus paieška';

                    trigger OnAction()
                    var
                        HomeworkTasks: Codeunit "Homework";
                    begin
                        HomeworkTasks.RunTask2Demo();
                    end;
                }

                action(RunTask3)
                {
                    ApplicationArea = All;
                    Caption = 'Užduotis 3: Dublikatų paieška';
                    Image = Find;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Paleisti trečią užduotį - besidubliuojančių skaičių paieška';

                    trigger OnAction()
                    var
                        HomeworkTasks: Codeunit "Homework";
                    begin
                        HomeworkTasks.RunTask3Demo();
                    end;
                }

                action(RunTask4)
                {
                    ApplicationArea = All;
                    Caption = 'Užduotis 4: Balsės ir priebalsės';
                    Image = Text;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Paleisti ketvirtą užduotį - balsių ir priebalsių skaičiavimas';

                    trigger OnAction()
                    var
                        HomeworkTasks: Codeunit "Homework";
                    begin
                        HomeworkTasks.RunTask4Demo();
                    end;
                }
            }

            group(BatchActions)
            {
                Caption = 'Grupės veiksmai';

                action(RunAllTasks)
                {
                    ApplicationArea = All;
                    Caption = 'Paleisti visas užduotis';
                    Image = ExecuteBatch;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Paleisti visas keturias užduotis iš eilės';

                    trigger OnAction()
                    var
                        HomeworkTasks: Codeunit "Homework";
                    begin
                        HomeworkTasks.RunAllDemos();
                    end;
                }
            }
        }
    }

    var
        InstructionTxt: Label 'Paspauskite mygtukus viršuje, kad atliktumėte užduoties demonstraciją.';
}