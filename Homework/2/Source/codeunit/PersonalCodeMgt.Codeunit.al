// Codeunit with validation logic
codeunit 66006 "ALLUPersonalCodeMgt"
{
    procedure ValidatePersonalCode(PersonalCode: Text[11]; var ValidationResult: Record "ALLUPersonalCodeResult" temporary)
    var
        CleanCode: Text[11];
        Digits: array[11] of Integer;
        i: Integer;
        Gender: Integer;
        Year: Integer;
        Month: Integer;
        Day: Integer;
        Century: Integer;
        CenturyYear: Integer;
        SerialNumber: Integer;
        Checksum: Integer;
        CalculatedChecksum: Integer;
    begin
        ValidationResult.Init();
        ValidationResult."Entry No." := 1;

        // Clean the input (remove non-digits)
        CleanCode := DelChr(PersonalCode, '=', DelChr(PersonalCode, '=', '0123456789'));

        // Check length
        if StrLen(CleanCode) <> 11 then begin
            ValidationResult."Is Valid" := false;
            ValidationResult."Error Message" := 'Personal code must contain exactly 11 digits';
            ValidationResult.Insert();
            exit;
        end;

        // Convert to digit array
        for i := 1 to 11 do begin
            if not Evaluate(Digits[i], CleanCode[i]) then begin
                ValidationResult."Is Valid" := false;
                ValidationResult."Error Message" := 'Personal code must contain only digits';
                ValidationResult.Insert();
                exit;
            end;
        end;

        // Validate gender/century digit
        Gender := Digits[1];
        if (Gender < 1) or (Gender > 6) then begin
            ValidationResult."Is Valid" := false;
            ValidationResult."Error Message" := 'First digit (gender/century) must be between 1 and 6';
            ValidationResult.Insert();
            exit;
        end;

        // Calculate century and year
        Century := (Gender - 1) div 2;
        case Century of
            0:
                CenturyYear := 1800;
            1:
                CenturyYear := 1900;
            2:
                CenturyYear := 2000;
        end;

        Year := CenturyYear + Digits[2] * 10 + Digits[3];
        Month := Digits[4] * 10 + Digits[5];
        Day := Digits[6] * 10 + Digits[7];

        // Validate month
        if (Month < 1) or (Month > 12) then begin
            ValidationResult."Is Valid" := false;
            ValidationResult."Error Message" := 'Invalid month (must be between 01 and 12)';
            ValidationResult.Insert();
            exit;
        end;

        // Validate day
        if not ValidateDay(Day, Month, Year) then begin
            ValidationResult."Is Valid" := false;
            ValidationResult."Error Message" := 'Invalid day for the specified month';
            ValidationResult.Insert();
            exit;
        end;

        // Check if date is not in the future
        if DMY2Date(Day, Month, Year) > Today then begin
            ValidationResult."Is Valid" := false;
            ValidationResult."Error Message" := 'Birth date cannot be in the future';
            ValidationResult.Insert();
            exit;
        end;

        // Validate checksum
        Checksum := Digits[11];
        CalculatedChecksum := CalculateChecksum(Digits);

        if CalculatedChecksum <> Checksum then begin
            ValidationResult."Is Valid" := false;
            ValidationResult."Error Message" := 'Invalid checksum digit';
            ValidationResult.Insert();
            exit;
        end;

        // If all validations pass, populate the result
        ValidationResult."Is Valid" := true;
        if Gender mod 2 = 1 then
            ValidationResult.Gender := 'Male'
        else
            ValidationResult.Gender := 'Female';

        ValidationResult."Birth Date" := DMY2Date(Day, Month, Year);
        ValidationResult.Century := Format(CenturyYear + 1) + '-' + Format(CenturyYear + 100);
        SerialNumber := Digits[8] * 100 + Digits[9] * 10 + Digits[10];
        ValidationResult."Serial Number" := SerialNumber;
        ValidationResult.Insert();
    end;

    local procedure ValidateDay(Day: Integer; Month: Integer; Year: Integer): Boolean
    var
        DaysInMonth: array[12] of Integer;
        IsLeapYear: Boolean;
    begin
        // Days in each month
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

        // Check for leap year
        IsLeapYear := ((Year mod 4 = 0) and (Year mod 100 <> 0)) or (Year mod 400 = 0);
        if IsLeapYear and (Month = 2) then
            DaysInMonth[2] := 29;

        exit((Day >= 1) and (Day <= DaysInMonth[Month]));
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
        // First set of weights
        Weights1[1] := 1;
        Weights1[2] := 2;
        Weights1[3] := 3;
        Weights1[4] := 4;
        Weights1[5] := 5;
        Weights1[6] := 6;
        Weights1[7] := 7;
        Weights1[8] := 8;
        Weights1[9] := 9;
        Weights1[10] := 1;

        // Second set of weights
        Weights2[1] := 3;
        Weights2[2] := 4;
        Weights2[3] := 5;
        Weights2[4] := 6;
        Weights2[5] := 7;
        Weights2[6] := 8;
        Weights2[7] := 9;
        Weights2[8] := 1;
        Weights2[9] := 2;
        Weights2[10] := 3;

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
}
