report 66031 "ALLUAutoRentalHistory"
{
    Caption = 'Auto Rental History';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './AutoRentalHistory.rdlc';

    dataset
    {
        dataitem("Automobile"; "ALLUAutomobile")
        {
            RequestFilterFields = "No.";
            column(AutoNo; "No.")
            {
            }
            column(AutoName; Name)
            {
            }
            column(AutoMark; "Mark Code")
            {
            }
            column(AutoModel; "Model Code")
            {
            }
            column(DateFrom; FilterDateFrom)
            {
            }
            column(DateTo; FilterDateTo)
            {
            }
            column(TotalRentalAmount; TotalAmount)
            {
            }

            dataitem("FinishedRentalHeader"; "ALLUFinishedRentalHeader")
            {
                DataItemLink = "Auto No." = FIELD("No.");
                DataItemTableView = SORTING("Auto No.", "Reserved From");

                column(RentNo; "No.")
                {
                }
                column(RentDateFrom; "Reserved From")
                {
                }
                column(RentDateTo; "Reserved To")
                {
                }
                column(CustomerNo; "Customer No.")
                {
                }
                column(CustomerName; Customer.Name)
                {
                }
                column(RentAmount; Amount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not Customer.Get("Customer No.") then
                        Customer.Init();

                    CalcFields(Amount);
                    TotalAmount += Amount;
                end;

                trigger OnPreDataItem()
                begin
                    if FilterDateFrom <> 0D then
                        SetFilter("Reserved From", '>=%1', FilterDateFrom);
                    if FilterDateTo <> 0D then
                        SetFilter("Reserved To", '<=%1', FilterDateTo);
                end;
            }

            trigger OnPreDataItem()
            begin
                TotalAmount := 0;
                CompanyInfo.Get();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(DateFrom; FilterDateFrom)
                    {
                        Caption = 'Date From';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the start date for the report';
                    }
                    field(DateTo; FilterDateTo)
                    {
                        Caption = 'Date To';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the end date for the report';
                    }
                }
            }
        }
    }

    labels
    {
        ReportTitleLbl = 'Auto Rental History';
        PageLbl = 'Page';
        AutoLbl = 'Automobile';
        PeriodLbl = 'Period';
        RentalHistoryLbl = 'Rental History';
        DateFromLbl = 'Date From';
        DateToLbl = 'Date To';
        CustomerLbl = 'Customer';
        AmountLbl = 'Amount';
        TotalAmountLbl = 'Total Rental Amount';
    }

    var
        Customer: Record Customer;
        CompanyInfo: Record "Company Information";
        FilterDateFrom: Date;
        FilterDateTo: Date;
        TotalAmount: Decimal;
}
