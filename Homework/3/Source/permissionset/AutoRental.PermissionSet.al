permissionset 66030 "ALLUAutoRental"
{
    Assignable = true;
    Caption = 'Auto Rental Management';

    Permissions =
        // Tables
        table "ALLUAutoSetup" = X,
        table "ALLUAutoMark" = X,
        table "ALLUAutoModel" = X,
        table "ALLUAutomobile" = X,
        table "ALLUAutoReservation" = X,
        table "ALLUAutoDamage" = X,
        table "ALLURentalHeader" = X,
        table "ALLURentalLine" = X,
        table "ALLURentalDamage" = X,
        table "ALLUFinishedRentalHeader" = X,
        table "ALLUFinishedRentalLine" = X,

        // Table Data
        tabledata "ALLUAutoSetup" = RIMD,
        tabledata "ALLUAutoMark" = RIMD,
        tabledata "ALLUAutoModel" = RIMD,
        tabledata "ALLUAutomobile" = RIMD,
        tabledata "ALLUAutoReservation" = RIMD,
        tabledata "ALLUAutoDamage" = RIMD,
        tabledata "ALLURentalHeader" = RIMD,
        tabledata "ALLURentalLine" = RIMD,
        tabledata "ALLURentalDamage" = RIMD,
        tabledata "ALLUFinishedRentalHeader" = RIMD,
        tabledata "ALLUFinishedRentalLine" = RIMD,

        // Pages
        page "ALLUAutoSetup" = X,
        page "ALLUAutoMarkList" = X,
        page "ALLUAutoModelList" = X,
        page "ALLUAutomobileList" = X,
        page "ALLUAutomobileCard" = X,
        page "ALLUAutoReservationList" = X,
        page "ALLUValidReservations" = X,
        page "ALLUAutoDamageList" = X,
        page "ALLURentalList" = X,
        page "ALLUReleasedRentalContracts" = X,
        page "ALLURentalCard" = X,
        page "ALLURentalLines" = X,
        page "ALLURentalDamageList" = X,
        page "ALLUFinishedRentalList" = X,
        page "ALLUFinishedRentalCard" = X,
        page "ALLUFinishedRentalLines" = X,

        // Reports
        report "ALLURentalContract" = X,
        report "ALLUAutoRentalHistory" = X,

        // Codeunits
        codeunit "ALLUAutoManagement" = X;
}
