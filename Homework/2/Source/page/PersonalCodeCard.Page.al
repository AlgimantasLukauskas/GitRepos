// Page for personal code validation
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
                    trigger OnValidate()
                    begin
                        // Auto-format input to remove spaces and non-digits
                        PersonalCodeInput := DelChr(PersonalCodeInput, '=', DelChr(PersonalCodeInput, '=', '0123456789'));
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
                    Editable = false;
                    StyleExpr = ValidationResultStyle;
                }
                field(ErrorMessageField; ErrorMessageText)
                {
                    ApplicationArea = All;
                    Caption = 'Error Message';
                    Editable = false;
                    Visible = not LastValidationResult;
                    StyleExpr = 'Unfavorable';
                }
                group(DetailsGroup)
                {
                    Caption = 'Personal Code Details';
                    Visible = LastValidationResult;
                    field(GenderField; GenderText)
                    {
                        ApplicationArea = All;
                        Caption = 'Gender';
                        Editable = false;
                    }
                    field(BirthDateField; BirthDateText)
                    {
                        ApplicationArea = All;
                        Caption = 'Birth Date';
                        Editable = false;
                    }
                    field(CenturyField; CenturyText)
                    {
                        ApplicationArea = All;
                        Caption = 'Century';
                        Editable = false;
                    }
                    field(SerialNumberField; SerialNumberText)
                    {
                        ApplicationArea = All;
                        Caption = 'Serial Number';
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
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Validate the entered personal code';

                trigger OnAction()
                begin
                    ValidatePersonalCode();
                end;
            }
            action(ViewHistory)
            {
                ApplicationArea = All;
                Caption = 'View Validation History';
                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'View the history of personal code validations';

                trigger OnAction()
                begin
                    PAGE.RunModal(PAGE::"ALLUPersonalCodeList");
                end;
            }
            action(ClearHistory)
            {
                ApplicationArea = All;
                Caption = 'Clear History';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Clear all validation history';

                trigger OnAction()
                var
                    PersonalCodeVal: Record "ALLUPersonalCodeVal";
                begin
                    if Confirm('Are you sure you want to clear all validation history?') then begin
                        PersonalCodeVal.DeleteAll();
                        Message('Validation history has been cleared.');
                    end;
                end;
            }
        }
    }

    var
        PersonalCodeInput: Text[11];
        ValidationResultText: Text[50];
        ErrorMessageText: Text[250];
        GenderText: Text[10];
        BirthDateText: Text[20];
        CenturyText: Text[20];
        SerialNumberText: Text[10];
        ValidationResultStyle: Text;
        ShowResult: Boolean;
        LastValidationResult: Boolean;

    local procedure ValidatePersonalCode()
    var
        PersonalCodeVal: Record "ALLUPersonalCodeVal";
        PersonalCodeMgt: Codeunit "ALLUPersonalCodeMgt";
        ValidationResult: Record "ALLUPersonalCodeResult" temporary;
    begin
        if PersonalCodeInput = '' then begin
            Message('Please enter a personal code to validate.');
            exit;
        end;

        // Validate the personal code
        PersonalCodeMgt.ValidatePersonalCode(PersonalCodeInput, ValidationResult);

        // Store in history
        PersonalCodeVal.Init();
        PersonalCodeVal."Personal Code" := PersonalCodeInput;
        PersonalCodeVal."Validation Date" := CurrentDateTime;
        PersonalCodeVal."Is Valid" := ValidationResult."Is Valid";
        PersonalCodeVal."Error Message" := ValidationResult."Error Message";
        PersonalCodeVal."Gender" := ValidationResult.Gender;
        PersonalCodeVal."Birth Date" := ValidationResult."Birth Date";
        PersonalCodeVal."Serial Number" := ValidationResult."Serial Number";
        PersonalCodeVal."Century" := ValidationResult.Century;
        PersonalCodeVal."User ID" := UserId;
        PersonalCodeVal.Insert();

        // Update UI
        ShowResult := true;
        LastValidationResult := ValidationResult."Is Valid";

        if ValidationResult."Is Valid" then begin
            ValidationResultText := 'Valid Personal Code';
            ValidationResultStyle := 'Favorable';
            GenderText := ValidationResult.Gender;
            BirthDateText := Format(ValidationResult."Birth Date");
            CenturyText := ValidationResult.Century;
            SerialNumberText := Format(ValidationResult."Serial Number");
        end else begin
            ValidationResultText := 'Invalid Personal Code';
            ValidationResultStyle := 'Unfavorable';
            ErrorMessageText := ValidationResult."Error Message";
        end;

        CurrPage.Update();
    end;
}
