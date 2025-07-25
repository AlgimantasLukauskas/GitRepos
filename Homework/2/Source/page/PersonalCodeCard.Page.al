// Clean personal code validation page with history button
page 66007 "ALLUPersonalCodeCard"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    Caption = 'Personal Code Validator';
    SourceTable = "ALLUPersonalCodeVal";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(InputGroup)
            {
                Caption = 'Personal Code Validation';

                field(PersonalCodeInput; PersonalCodeInput)
                {
                    ApplicationArea = All;
                    Caption = 'Personal Code';
                    ToolTip = 'Enter the Lithuanian personal code to validate (11 digits)';
                    ShowMandatory = true;

                    trigger OnValidate()
                    var
                        CleanedCode: Text[11];
                    begin
                        CleanedCode := CopyStr(DelChr(PersonalCodeInput, '=', DelChr(PersonalCodeInput, '=', '0123456789')), 1, 11);
                        PersonalCodeInput := CleanedCode;

                        if StrLen(PersonalCodeInput) = 11 then
                            ValidatePersonalCode();
                    end;
                }


            }

            group(ResultGroup)
            {
                Caption = 'Validation Result';
                Visible = ShowResult;

                field(ValidationResult; ValidationResultText)
                {
                    ApplicationArea = All;
                    Caption = 'Result';
                    ToolTip = 'Shows whether the personal code is valid or invalid';
                    Editable = false;
                    StyleExpr = ValidationResultStyle;
                }

                field(ErrorMessageField; ErrorMessageText)
                {
                    ApplicationArea = All;
                    Caption = 'Error Details';
                    ToolTip = 'Displays the detailed error message when validation fails';
                    Editable = false;
                    Visible = not LastValidationResult;
                    StyleExpr = 'Unfavorable';
                    MultiLine = true;
                }

                group(DetailsGroup)
                {
                    Caption = 'Extracted Information';
                    Visible = LastValidationResult;

                    field(GenderField; GenderText)
                    {
                        ApplicationArea = All;
                        Caption = 'Gender';
                        ToolTip = 'Gender extracted from the personal code';
                        Editable = false;
                    }

                    field(BirthDateField; BirthDateText)
                    {
                        ApplicationArea = All;
                        Caption = 'Birth Date';
                        ToolTip = 'Birth date extracted from the personal code';
                        Editable = false;
                    }

                    field(AgeField; AgeText)
                    {
                        ApplicationArea = All;
                        Caption = 'Current Age';
                        ToolTip = 'Calculated age based on the birth date';
                        Editable = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ValidateCode)
            {
                ApplicationArea = All;
                Caption = 'Validate Personal Code';
                ToolTip = 'Validate the entered personal code';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Enabled = PersonalCodeInput <> '';

                trigger OnAction()
                begin
                    ValidatePersonalCode();
                end;
            }

            action(ViewHistory)
            {
                ApplicationArea = All;
                Caption = 'View Validation History';
                ToolTip = 'View the history of all validated personal codes';
                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PersonalCodeHistoryPage: Page "ALLUPersonalCodeList";
                begin
                    PersonalCodeHistoryPage.Run();
                end;
            }

            action(ClearInput)
            {
                ApplicationArea = All;
                Caption = 'Clear Input';
                ToolTip = 'Clear the personal code input field';
                Image = ClearLog;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    ClearInputData();
                end;
            }
        }
    }

    var
        PersonalCodeInput: Text[11];
        ValidationResultText: Text[250]; //Review: kam šis ilgio apribojimas?
        ErrorMessageText: Text[250];
        GenderText: Text[10];
        BirthDateText: Text[20];
        AgeText: Text[20];
        ValidationResultStyle: Text;
        ShowResult: Boolean;
        LastValidationResult: Boolean;

    trigger OnOpenPage()
    begin
        // Page initialization
    end;



    local procedure ValidatePersonalCode() //Review: puslapye sudėta procesinė logika, reikėtų iškleti į kodinį
    var
        PersonalCodeVal: Record "ALLUPersonalCodeVal";
        TempValidationResult: Record "ALLUPersonalCodeResult" temporary;
        PersonalCodeMgt: Codeunit "ALLUPersonalCodeMgt";
        PersonalCodeText: Text;
        BirthDate: Date;
        Age: Integer;
    begin
        if PersonalCodeInput = '' then begin
            Message('Please enter a personal code to validate.'); //Review: Text constants -> labels
            exit;
        end;

        PersonalCodeText := PersonalCodeInput;
        PersonalCodeMgt.ValidatePersonalCode(PersonalCodeText, TempValidationResult);

        // Store in history //Review: istorija galėtų būti kaupiama kodinyje po patikros
        PersonalCodeVal.Init();
        PersonalCodeVal."Personal Code" := CopyStr(PersonalCodeInput, 1, 11);
        PersonalCodeVal."Validation Date" := CurrentDateTime;
        PersonalCodeVal."Is Valid" := TempValidationResult."Is Valid";
        PersonalCodeVal."Error Message" := CopyStr(TempValidationResult."Error Message", 1, 250);
        PersonalCodeVal."Gender" := TempValidationResult.Gender;
        PersonalCodeVal."Birth Date" := TempValidationResult."Birth Date";
        PersonalCodeVal."Serial Number" := TempValidationResult."Serial Number";
        PersonalCodeVal."Century" := TempValidationResult.Century;
        PersonalCodeVal."User ID" := CopyStr(UserId, 1, 50);
        PersonalCodeVal.Insert();

        ShowResult := true;
        LastValidationResult := TempValidationResult."Is Valid";

        if TempValidationResult."Is Valid" then begin
            ValidationResultText := CopyStr('✓ Valid Personal Code', 1, 250);
            ValidationResultStyle := 'Favorable';
            GenderText := TempValidationResult.Gender;
            BirthDateText := Format(TempValidationResult."Birth Date", 0, '<Day,2>.<Month,2>.<Year4>'); // Review: Why not use date?

            // Calculate age
            BirthDate := TempValidationResult."Birth Date";
            Age := Date2DMY(Today, 3) - Date2DMY(BirthDate, 3);
            if (Date2DMY(Today, 2) < Date2DMY(BirthDate, 2)) or
               ((Date2DMY(Today, 2) = Date2DMY(BirthDate, 2)) and (Date2DMY(Today, 1) < Date2DMY(BirthDate, 1))) then
                Age := Age - 1;
            AgeText := Format(Age) + ' years old';

            ErrorMessageText := '';
        end else begin
            ValidationResultText := CopyStr('✗ Invalid Personal Code', 1, 250);
            ValidationResultStyle := 'Unfavorable';
            ErrorMessageText := CopyStr(TempValidationResult."Error Message", 1, 250);

            GenderText := '';
            BirthDateText := '';
            AgeText := '';
        end;

        CurrPage.Update();
    end;

    local procedure ClearInputData()
    begin
        PersonalCodeInput := '';
        ShowResult := false;
        ValidationResultText := '';
        ErrorMessageText := '';
        GenderText := '';
        BirthDateText := '';
        AgeText := '';
        CurrPage.Update();
    end;
}
