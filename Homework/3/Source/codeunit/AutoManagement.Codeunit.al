codeunit 66030 "ALLUAutoManagement"
{
    var
        CustomerDebtsErr: Label 'Customer %1 has outstanding debts', Comment = '%1 = Customer No.';
        CustomerBlockedErr: Label 'Customer %1 is blocked', Comment = '%1 = Customer No.';
        CustomerNotFoundErr: Label 'Customer %1 does not exist', Comment = '%1 = Customer No.';
        FutureReservationExistsErr: Label 'Cannot return auto with future reservations';
        InvalidLineNumberErr: Label 'Failed to generate line number for auto damage';

    procedure CheckCustomerDebts(CustomerNo: Code[20])
    var
        Customer: Record Customer;
    begin
        if CustomerNo = '' then
            exit;

        if not Customer.Get(CustomerNo) then
            Error(CustomerNotFoundErr, CustomerNo);

        if Customer.Blocked <> Customer.Blocked::" " then
            Error(CustomerBlockedErr, CustomerNo);

        Customer.CalcFields("Balance (LCY)");
        if Customer."Balance (LCY)" > 0 then
            Error(CustomerDebtsErr, CustomerNo);
    end;

    procedure CreateInitialRentalLine(DocumentNo: Code[20]; AutoNo: Code[20])
    var
        Auto: Record "ALLUAutomobile";
        RentalLine: Record "ALLURentalLine";
        Resource: Record Resource;
        RentalHeader: Record "ALLURentalHeader";
        RentalDays: Integer;
    begin
        if (DocumentNo = '') or (AutoNo = '') then
            exit;

        if not Auto.Get(AutoNo) then
            exit;

        if Auto."Rental Service" = '' then
            exit;

        if not Resource.Get(Auto."Rental Service") then
            exit;

        RentalLine.SetRange("Document No.", DocumentNo);
        RentalLine.SetRange("Line No.", 10000);
        if not RentalLine.IsEmpty() then
            exit;

        if RentalHeader.Get(DocumentNo) then begin
            if (RentalHeader."Reserved From" <> 0D) and (RentalHeader."Reserved To" <> 0D) then
                RentalDays := RentalHeader."Reserved To" - RentalHeader."Reserved From" + 1
            else
                RentalDays := 1;
        end else
            RentalDays := 1;

        RentalLine.Init();
        RentalLine."Document No." := DocumentNo;
        RentalLine."Line No." := 10000;
        RentalLine.Type := RentalLine.Type::Resource;
        RentalLine.Validate("No.", Auto."Rental Service");
        RentalLine.Validate(Quantity, RentalDays);
        RentalLine.Insert(true);
    end;

    procedure ProcessAutoReturn(var RentalHeader: Record "ALLURentalHeader")
    var
        FinishedRentalHeader: Record "ALLUFinishedRentalHeader";
        FinishedRentalLine: Record "ALLUFinishedRentalLine";
        RentalLine: Record "ALLURentalLine";
        RentalDamage: Record "ALLURentalDamage";
        AutoDamage: Record "ALLUAutoDamage";
        AutoReservation: Record "ALLUAutoReservation";
        LineNo: Integer;
    begin
        RentalHeader.TestField(Status, RentalHeader.Status::Released);
        RentalHeader.TestField("Auto No.");
        RentalHeader.TestField("Customer No.");

        AutoReservation.SetRange("Auto No.", RentalHeader."Auto No.");
        AutoReservation.SetFilter("Reserved From", '>%1', CreateDateTime(Today, 000000T));
        if not AutoReservation.IsEmpty() then
            Error(FutureReservationExistsErr);

        Commit();

        FinishedRentalHeader.Init();
        FinishedRentalHeader.TransferFields(RentalHeader);
        FinishedRentalHeader.Insert(true);

        RentalLine.SetRange("Document No.", RentalHeader."No.");
        if RentalLine.FindSet() then
            repeat
                FinishedRentalLine.Init();
                FinishedRentalLine.TransferFields(RentalLine);
                FinishedRentalLine.Insert(true);
            until RentalLine.Next() = 0;

        RentalDamage.SetRange("Document No.", RentalHeader."No.");
        if RentalDamage.FindSet() then begin
            LineNo := 0;
            AutoDamage.SetRange("Auto No.", RentalHeader."Auto No.");
            if AutoDamage.FindLast() then
                LineNo := AutoDamage."Line No.";

            repeat
                LineNo += 10000;
                if LineNo > 2147483647 then
                    Error(InvalidLineNumberErr);

                AutoDamage.Init();
                AutoDamage."Auto No." := RentalHeader."Auto No.";
                AutoDamage."Line No." := LineNo;
                AutoDamage.Date := RentalDamage.Date;
                AutoDamage.Description := RentalDamage.Description;
                AutoDamage.Status := AutoDamage.Status::Active;
                AutoDamage.Insert(true);
            until RentalDamage.Next() = 0;

            RentalDamage.DeleteAll(true);
        end;

        RentalLine.DeleteAll(true);
        RentalHeader.Delete(true);

        Message(AutoReturnedMsg, RentalHeader."No.", FinishedRentalHeader."No.");
    end;

    procedure ValidateFirstLineDelete(var RentalLine: Record "ALLURentalLine"): Boolean
    var
        RentalHeader: Record "ALLURentalHeader";
        Auto: Record "ALLUAutomobile";
    begin
        if RentalLine."Line No." <> 10000 then
            exit(true);

        if not RentalHeader.Get(RentalLine."Document No.") then
            exit(true);

        if RentalHeader."Auto No." = '' then
            exit(true);

        if not Auto.Get(RentalHeader."Auto No.") then
            exit(true);

        if (RentalLine.Type = RentalLine.Type::Resource) and (RentalLine."No." = Auto."Rental Service") then
            exit(false);

        exit(true);
    end;

    var
        AutoReturnedMsg: Label 'Auto rental %1 has been successfully returned and archived as %2', Comment = '%1 = Original Rental No., %2 = Finished Rental No.';
}
