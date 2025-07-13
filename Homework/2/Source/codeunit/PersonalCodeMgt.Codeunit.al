/// <summary>
/// Codeunit for validating Lithuanian personal codes (asmens kodai).
/// Implements the official Lithuanian personal code validation algorithm.
/// </summary>
codeunit 66006 "ALLUPersonalCodeMgt"
{
    Access = Internal;

    var
        // Text constants for error messages
        EmptyCodeErr: Label 'Personal code cannot be empty';

        InvalidLengthErr: Label 'Personal code must contain exactly 11 digits, but %1 digits were provided', Comment = '%1 = actual number of digits provided';

        InvalidCharacterErr: Label 'Invalid character "%1" at position %2. Personal code must contain only digits', Comment = '%1 = invalid character, %2 = character position';

        InvalidGenderDigitErr: Label 'First digit (gender/century) must be between 1 and 6, but %1 was provided', Comment = '%1 = invalid first digit';

        InvalidMonthErr: Label 'Invalid month value: %1. Month must be between 01 and 12', Comment = '%1 = invalid month value';

        InvalidDayErr: Label 'Invalid day %1 for month %2 in year %3', Comment = '%1 = day, %2 = month, %3 = year';

        FutureDateErr: Label 'Birth date %1 cannot be in the future', Comment = '%1 = provided birth date';

        TooOldDateErr: Label 'Birth date %1 is too far in the past to be valid', Comment = '%1 = provided birth date';

        InvalidChecksumErr: Label 'Invalid checksum digit. Expected %1, but got %2', Comment = '%1 = expected checksum digit, %2 = provided checksum digit';

        CenturyFormatTxt: Label '%1-%2', Comment = '%1 = century start year, %2 = century end year';


    /// <summary>
    /// Validates a Lithuanian personal code and returns detailed validation results.
    /// </summary>
    /// <param name="PersonalCode">The personal code to validate (11 digits)</param>
    /// <param name="ValidationResult">Temporary record containing validation results</param>
    procedure ValidatePersonalCode(PersonalCode: Text; var ValidationResult: Record "ALLUPersonalCodeResult" temporary)
    var
        CleanCode: Text;
        Digits: array[11] of Integer;
        ValidationErr: Text;
    begin
        Clear(ValidationResult);
        ValidationResult.Init();
        ValidationResult."Entry No." := 1;

        // Input validation and cleanup
        if not ValidateAndCleanInput(PersonalCode, CleanCode, ValidationErr) then begin
            SetValidationError(ValidationResult, ValidationErr);
            exit;
        end;

        // Convert to digit array
        if not ConvertToDigitArray(CleanCode, Digits, ValidationErr) then begin
            SetValidationError(ValidationResult, ValidationErr);
            exit;
        end;

        // Perform comprehensive validation
        if not PerformValidation(Digits, ValidationResult) then
            exit;

        // If all validations pass, populate the successful result
        PopulateValidationResult(Digits, ValidationResult);
    end;

    local procedure ValidateAndCleanInput(PersonalCode: Text; var CleanCode: Text; var ValidationErr: Text): Boolean
    begin
        // Remove whitespace and non-digit characters
        CleanCode := DelChr(PersonalCode, '=', DelChr(PersonalCode, '=', '0123456789'));

        // Check if input is empty
        if CleanCode = '' then begin
            ValidationErr := EmptyCodeErr;
            exit(false);
        end;

        // Check length
        if StrLen(CleanCode) <> 11 then begin
            ValidationErr := StrSubstNo(InvalidLengthErr, StrLen(CleanCode));
            exit(false);
        end;

        exit(true);
    end;

    local procedure ConvertToDigitArray(CleanCode: Text; var Digits: array[11] of Integer; var ValidationErr: Text): Boolean
    var
        i: Integer;
        DigitChar: Text[1];
    begin
        for i := 1 to 11 do begin
            DigitChar := CopyStr(CleanCode, i, 1);
            if not Evaluate(Digits[i], DigitChar) then begin
                ValidationErr := StrSubstNo(InvalidCharacterErr, DigitChar, i);
                exit(false);
            end;
        end;
        exit(true);
    end;

    local procedure PerformValidation(Digits: array[11] of Integer; var ValidationResult: Record "ALLUPersonalCodeResult" temporary): Boolean
    var
        ValidationErr: Text;
        BirthDate: Date;
    begin
        // Validate gender/century digit
        if not ValidateGenderCenturyDigit(Digits[1], ValidationErr) then begin
            SetValidationError(ValidationResult, ValidationErr);
            exit(false);
        end;

        // Extract and validate birth date
        if not ExtractAndValidateBirthDate(Digits, BirthDate, ValidationErr) then begin
            SetValidationError(ValidationResult, ValidationErr);
            exit(false);
        end;

        // Validate checksum
        if not ValidateChecksum(Digits, ValidationErr) then begin
            SetValidationError(ValidationResult, ValidationErr);
            exit(false);
        end;

        exit(true);
    end;

    local procedure ValidateGenderCenturyDigit(GenderDigit: Integer; var ValidationErr: Text): Boolean
    begin
        if (GenderDigit < 1) or (GenderDigit > 6) then begin
            ValidationErr := StrSubstNo(InvalidGenderDigitErr, GenderDigit);
            exit(false);
        end;
        exit(true);
    end;

    local procedure ExtractAndValidateBirthDate(Digits: array[11] of Integer; var BirthDate: Date; var ValidationErr: Text): Boolean
    var
        Year: Integer;
        Month: Integer;
        Day: Integer;
        CenturyYear: Integer;
    begin
        // Calculate century and year
        CenturyYear := GetCenturyYear(Digits[1]);
        Year := CenturyYear + Digits[2] * 10 + Digits[3];
        Month := Digits[4] * 10 + Digits[5];
        Day := Digits[6] * 10 + Digits[7];

        // Validate month
        if (Month < 1) or (Month > 12) then begin
            ValidationErr := StrSubstNo(InvalidMonthErr, Month);
            exit(false);
        end;

        // Validate day
        if not ValidateDay(Day, Month, Year) then begin
            ValidationErr := StrSubstNo(InvalidDayErr, Day, Month, Year);
            exit(false);
        end;

        // Create birth date
        BirthDate := DMY2Date(Day, Month, Year);

        // Check if date is not in the future
        if BirthDate > Today then begin
            ValidationErr := StrSubstNo(FutureDateErr, BirthDate);
            exit(false);
        end;

        // Check if date is not too old (reasonable validation)
        if BirthDate < DMY2Date(1, 1, 1800) then begin
            ValidationErr := StrSubstNo(TooOldDateErr, BirthDate);
            exit(false);
        end;

        exit(true);
    end;

    local procedure ValidateChecksum(Digits: array[11] of Integer; var ValidationErr: Text): Boolean
    var
        ExpectedChecksum: Integer;
        ActualChecksum: Integer;
    begin
        ExpectedChecksum := Digits[11];
        ActualChecksum := CalculateChecksum(Digits);

        if ActualChecksum <> ExpectedChecksum then begin
            ValidationErr := StrSubstNo(InvalidChecksumErr, ActualChecksum, ExpectedChecksum);
            exit(false);
        end;

        exit(true);
    end;

    local procedure GetCenturyYear(GenderDigit: Integer): Integer
    var
        Century: Integer;
    begin
        Century := (GenderDigit - 1) div 2;
        case Century of
            0:
                exit(1800);
            1:
                exit(1900);
            2:
                exit(2000);
            else
                exit(1900); // Default fallback
        end;
    end;

    local procedure ValidateDay(Day: Integer; Month: Integer; Year: Integer): Boolean
    var
        DaysInMonth: Integer;
    begin
        if (Day < 1) then
            exit(false);

        DaysInMonth := GetDaysInMonth(Month, Year);
        exit(Day <= DaysInMonth);
    end;

    local procedure GetDaysInMonth(Month: Integer; Year: Integer): Integer
    var
        DaysInMonth: array[12] of Integer;
        LeapYearFlag: Boolean;
    begin
        // Initialize days in each month
        DaysInMonth[1] := 31; // January
        DaysInMonth[2] := 28; // February
        DaysInMonth[3] := 31; // March
        DaysInMonth[4] := 30; // April
        DaysInMonth[5] := 31; // May
        DaysInMonth[6] := 30; // June
        DaysInMonth[7] := 31; // July
        DaysInMonth[8] := 31; // August
        DaysInMonth[9] := 30; // September
        DaysInMonth[10] := 31; // October
        DaysInMonth[11] := 30; // November
        DaysInMonth[12] := 31; // December

        // Adjust for leap year
        LeapYearFlag := IsLeapYear(Year);
        if LeapYearFlag and (Month = 2) then
            DaysInMonth[2] := 29;

        exit(DaysInMonth[Month]);
    end;

    local procedure IsLeapYear(Year: Integer): Boolean
    begin
        exit(((Year mod 4 = 0) and (Year mod 100 <> 0)) or (Year mod 400 = 0));
    end;

    local procedure CalculateChecksum(Digits: array[11] of Integer): Integer
    var
        Weights1: array[10] of Integer;
        Weights2: array[10] of Integer;
        Sum1: Integer;
        Sum2: Integer;
        i: Integer;
        Result: Integer;
    begin
        // Initialize first set of weights
        InitializeWeights1(Weights1);

        // Initialize second set of weights
        InitializeWeights2(Weights2);

        // Calculate first sum
        Sum1 := 0;
        for i := 1 to 10 do
            Sum1 += Digits[i] * Weights1[i];

        Result := Sum1 mod 11;

        // If result is 10, use second calculation
        if Result = 10 then begin
            Sum2 := 0;
            for i := 1 to 10 do
                Sum2 += Digits[i] * Weights2[i];
            Result := Sum2 mod 11;
            if Result = 10 then
                Result := 0;
        end;

        exit(Result);
    end;

    local procedure InitializeWeights1(var Weights: array[10] of Integer)
    begin
        Weights[1] := 1;
        Weights[2] := 2;
        Weights[3] := 3;
        Weights[4] := 4;
        Weights[5] := 5;
        Weights[6] := 6;
        Weights[7] := 7;
        Weights[8] := 8;
        Weights[9] := 9;
        Weights[10] := 1;
    end;

    local procedure InitializeWeights2(var Weights: array[10] of Integer)
    begin
        Weights[1] := 3;
        Weights[2] := 4;
        Weights[3] := 5;
        Weights[4] := 6;
        Weights[5] := 7;
        Weights[6] := 8;
        Weights[7] := 9;
        Weights[8] := 1;
        Weights[9] := 2;
        Weights[10] := 3;
    end;

    local procedure PopulateValidationResult(Digits: array[11] of Integer; var ValidationResult: Record "ALLUPersonalCodeResult" temporary)
    var
        Year: Integer;
        Month: Integer;
        Day: Integer;
        CenturyYear: Integer;
        SerialNumber: Integer;
    begin
        ValidationResult."Is Valid" := true;

        // Extract gender
        if Digits[1] mod 2 = 1 then
            ValidationResult.Gender := 'Male'
        else
            ValidationResult.Gender := 'Female';

        // Extract birth date
        CenturyYear := GetCenturyYear(Digits[1]);
        Year := CenturyYear + Digits[2] * 10 + Digits[3];
        Month := Digits[4] * 10 + Digits[5];
        Day := Digits[6] * 10 + Digits[7];
        ValidationResult."Birth Date" := DMY2Date(Day, Month, Year);

        // Set century information
        ValidationResult.Century := StrSubstNo(CenturyFormatTxt, CenturyYear + 1, CenturyYear + 100);

        // Extract serial number
        SerialNumber := Digits[8] * 100 + Digits[9] * 10 + Digits[10];
        ValidationResult."Serial Number" := SerialNumber;

        ValidationResult.Insert();
    end;

    local procedure SetValidationError(var ValidationResult: Record "ALLUPersonalCodeResult" temporary; ErrorMessage: Text)
    begin
        ValidationResult."Is Valid" := false;
        ValidationResult."Error Message" := CopyStr(ErrorMessage, 1, MaxStrLen(ValidationResult."Error Message"));
        ValidationResult.Insert();
    end;

    /// <summary>
    /// Quick validation procedure that returns only boolean result for performance-critical scenarios.
    /// </summary>
    /// <param name="PersonalCode">The personal code to validate</param>
    /// <returns>True if valid, False if invalid</returns>
    procedure IsValidPersonalCode(PersonalCode: Text): Boolean
    var
        TempValidationResult: Record "ALLUPersonalCodeResult" temporary;
    begin
        ValidatePersonalCode(PersonalCode, TempValidationResult);
        exit(TempValidationResult."Is Valid");
    end;

    /// <summary>
    /// Extracts gender from a personal code without full validation.
    /// </summary>
    /// <param name="PersonalCode">The personal code</param>
    /// <returns>Gender as text (Male/Female) or empty string if invalid</returns>
    procedure GetGenderFromPersonalCode(PersonalCode: Text): Text
    var
        CleanCode: Text;
        GenderDigit: Integer;
    begin
        CleanCode := DelChr(PersonalCode, '=', DelChr(PersonalCode, '=', '0123456789'));
        if StrLen(CleanCode) <> 11 then
            exit('');

        if not Evaluate(GenderDigit, CopyStr(CleanCode, 1, 1)) then
            exit('');

        if (GenderDigit < 1) or (GenderDigit > 6) then
            exit('');

        if GenderDigit mod 2 = 1 then
            exit('Male')
        else
            exit('Female');
    end;
}
