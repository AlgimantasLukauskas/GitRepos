// AL (Application Language) sprendimai praktikantų užduotims
// Sukurtas kaip Codeunit Business Central sistemoje

codeunit 66003 "Homework"
{
    // ========================================
    // 1. UŽDUOTIS: Teksto apvertimas
    // ========================================

    local procedure ReverseString(InputText: Text): Text
    var
        ReversedText: Text;
        i: Integer;
        TextLength: Integer;
    begin
        TextLength := StrLen(InputText);
        ReversedText := '';

        // Einame per tekstą nuo galo iki pradžios
        for i := TextLength downto 1 do begin
            ReversedText := ReversedText + CopyStr(InputText, i, 1);
        end;

        exit(ReversedText);
    end;

    // ========================================
    // 2. UŽDUOTIS: Mažiausio ir didžiausio skaičiaus paieška
    // ========================================

    local procedure FindMinMax(var NumberArray: array[100] of Integer; var MinValue: Integer; var MaxValue: Integer)
    var
        i: Integer;
    begin
        // Priskiriame pirmą elementą kaip pradinius min ir max
        MinValue := NumberArray[1];
        MaxValue := NumberArray[1];

        // Einame per visus masyvo elementus
        for i := 2 to 100 do begin
            if NumberArray[i] < MinValue then
                MinValue := NumberArray[i];
            if NumberArray[i] > MaxValue then
                MaxValue := NumberArray[i];
        end;
    end;

    local procedure GenerateRandomArray(var NumberArray: array[100] of Integer; MinValue: Integer; MaxValue: Integer)
    var
        i: Integer;
        RandomValue: Integer;
    begin
        // Generuojame atsitiktinį masyvą
        for i := 1 to 100 do begin
            RandomValue := Random(MaxValue - MinValue + 1) + MinValue;
            NumberArray[i] := RandomValue;
        end;
    end;

    // ========================================
    // 3. UŽDUOTIS: Besidubliuojančių skaičių paieška
    // ========================================

    local procedure FindDuplicates(var NumberArray: array[100] of Integer; var DuplicateArray: array[100] of Integer; var DuplicateCount: Integer)
    var
        i, j, k : Integer;
        IsDuplicate: Boolean;
        AlreadyInDuplicates: Boolean;
    begin
        DuplicateCount := 0;

        // Išvalome dublikatų masyvą
        for k := 1 to 100 do
            DuplicateArray[k] := 0;

        // Einame per kiekvieną masyvo elementą
        for i := 1 to 100 do begin
            IsDuplicate := false;
            AlreadyInDuplicates := false;

            // Tikriname, ar šis elementas jau yra dublikatų masyve
            for k := 1 to DuplicateCount do begin
                if DuplicateArray[k] = NumberArray[i] then begin
                    AlreadyInDuplicates := true;
                    break;
                end;
            end;

            // Jei jau yra dublikatų masyve, praleisime
            if not AlreadyInDuplicates then begin
                // Ieškome, ar tas pats elementas pasikartoja kitur masyve
                for j := i + 1 to 100 do begin
                    if NumberArray[j] = NumberArray[i] then begin
                        IsDuplicate := true;
                        break;
                    end;
                end;

                // Jei rado dublikatą, pridedame į dublikatų masyvą
                if IsDuplicate then begin
                    DuplicateCount := DuplicateCount + 1;
                    DuplicateArray[DuplicateCount] := NumberArray[i];
                end;
            end;
        end;
    end;

    // ========================================
    // 4. UŽDUOTIS: Balsių ir priebalsių skaičiavimas
    // ========================================

    local procedure CountVowelsAndConsonants(InputText: Text; var VowelCount: Integer; var ConsonantCount: Integer)
    var
        i: Integer;
        CurrentChar: Text[1];
        IsVowel: Boolean;
        IsLetter: Boolean;
        Vowels: Text;
    begin
        VowelCount := 0;
        ConsonantCount := 0;
        Vowels := 'aeiouąęėįųūAEIOUĄĘĖĮŲŪ';

        // Einame per kiekvieną teksto simbolį
        for i := 1 to StrLen(InputText) do begin
            CurrentChar := CopyStr(InputText, i, 1);

            // Tikriname, ar simbolis yra raidė (supaprastinta versija)
            IsLetter := IsLetterChar(CurrentChar);

            if IsLetter then begin
                // Tikriname, ar raidė yra balsė
                IsVowel := StrPos(Vowels, CurrentChar) > 0;

                if IsVowel then
                    VowelCount := VowelCount + 1
                else
                    ConsonantCount := ConsonantCount + 1;
            end;
        end;
    end;

    local procedure IsLetterChar(Character: Text[1]): Boolean
    var
        CharCode: Integer;
    begin
        // Gauti simbolio ASCII kodą
        if StrLen(Character) = 0 then
            exit(false);

        // Supaprastinta tikrinimo logika
        // Tikrina ar simbolis yra raidė (A-Z, a-z)
        CharCode := Character[1];
        exit(((CharCode >= 65) and (CharCode <= 90)) or ((CharCode >= 97) and (CharCode <= 122)) or
            (CharCode >= 260)); // Lietuviškos raidės paprastai prasideda nuo 260+
    end;

    // ========================================
    // DEMONSTRAVIMO PROCEDŪROS
    // ========================================

    procedure RunTask1Demo()
    var
        InputText: Text;
        Result: Text;
    begin
        InputText := 'Programuotojas';
        Result := ReverseString(InputText);
        Message('Užduotis 1:\Įvestas tekstas: %1\Apverstas tekstas: %2', InputText, Result);
    end;

    procedure RunTask2Demo()
    var
        NumberArray: array[100] of Integer;
        MinValue, MaxValue : Integer;
        i: Integer;
        SampleText: Text;
    begin
        // Generuojame atsitiktinį masyvą
        GenerateRandomArray(NumberArray, 1, 1000);

        // Randame min ir max
        FindMinMax(NumberArray, MinValue, MaxValue);

        // Parodome pirmus 10 elementų
        SampleText := '';
        for i := 1 to 10 do begin
            if i > 1 then
                SampleText := SampleText + ', ';
            SampleText := SampleText + Format(NumberArray[i]);
        end;

        Message('Užduotis 2:\Masyvo ilgis: 100\Mažiausias: %1\Didžiausias: %2\Pirmi 10: %3...',
                MinValue, MaxValue, SampleText);
    end;

    procedure RunTask3Demo()
    var
        NumberArray: array[100] of Integer;
        DuplicateArray: array[100] of Integer;
        DuplicateCount: Integer;
        i: Integer;
        DuplicateText: Text;
    begin
        // Generuojame masyvą su mažesniu diapazonu dublikatams
        GenerateRandomArray(NumberArray, 1, 50);

        // Randame dublikatus
        FindDuplicates(NumberArray, DuplicateArray, DuplicateCount);

        // Formuojame dublikatų tekstą
        DuplicateText := '';
        for i := 1 to DuplicateCount do begin
            if i > 1 then
                DuplicateText := DuplicateText + ', ';
            DuplicateText := DuplicateText + Format(DuplicateArray[i]);
        end;

        Message('Užduotis 3:\Masyvo ilgis: 100\Dublikatų kiekis: %1\Dublikatai: %2',
                DuplicateCount, DuplicateText);
    end;

    procedure RunTask4Demo()
    var
        TestText: Text;
        VowelCount, ConsonantCount : Integer;
    begin
        TestText := 'Programuotojo ar tiesiog bet kokio IT specialisto profesija taps vis labiau įprasta.';

        CountVowelsAndConsonants(TestText, VowelCount, ConsonantCount);

        Message('Užduotis 4:\Tekstas: %1\Balsių: %2\Priebalsių: %3\Iš viso raidžių: %4',
                TestText, VowelCount, ConsonantCount, VowelCount + ConsonantCount);
    end;

    procedure RunAllDemos()
    begin
        RunTask1Demo();
        RunTask2Demo();
        RunTask3Demo();
        RunTask4Demo();
    end;
}

