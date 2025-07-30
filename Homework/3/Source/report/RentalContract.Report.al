report 66030 "ALLURentalContract"
{
    Caption = 'Auto Rent Contract';
    UsageCategory = Documents;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './RentalContract.rdlc';

    dataset
    {
        dataitem("RentalHeader"; "ALLURentalHeader")
        {
            column(No_; "No.")
            {
            }
            column(CustomerNo; "Customer No.")
            {
            }
            column(CustomerName; Customer.Name)
            {
            }
            column("Date"; Date)
            {
            }
            column(AutoNo; "Auto No.")
            {
            }
            column(AutoMark; Auto."Mark Code")
            {
            }
            column(AutoModel; Auto."Model Code")
            {
            }
            column(ReservedFrom; "Reserved From")
            {
            }
            column(ReservedTo; "Reserved To")
            {
            }
            column(RentalAmount; RentalAmount)
            {
            }
            column(ServiceAmount; ServiceAmount)
            {
            }
            column(TotalAmount; Amount)
            {
            }

            dataitem("RentalLine"; "ALLURentalLine")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");

                column(LineType; Format(Type))
                {
                }
                column(LineNo; "No.")
                {
                }
                column(LineDescription; Description)
                {
                }
                column(LineQuantity; Quantity)
                {
                }
                column(LineUnitPrice; "Unit Price")
                {
                }
                column(LineAmount; Amount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Line No." = 10000 then
                        RentalAmount := Amount
                    else
                        ServiceAmount += Amount;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Customer.Get("Customer No.");
                Auto.Get("Auto No.");

                RentalAmount := 0;
                ServiceAmount := 0;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
            end;
        }
    }

    labels
    {
        ReportTitleLbl = 'Auto Rent Contract';
        PageLbl = 'Page';
        CustomerLbl = 'Customer';
        DateLbl = 'Date';
        AutoLbl = 'Automobile';
        PeriodLbl = 'Rental Period';
        ServicesLbl = 'Services and Accessories';
        TypeLbl = 'Type';
        NoLbl = 'No.';
        DescriptionLbl = 'Description';
        QtyLbl = 'Quantity';
        PriceLbl = 'Unit Price';
        AmountLbl = 'Amount';
        RentalAmountLbl = 'Rental Amount';
        ServiceAmountLbl = 'Services Amount';
        TotalAmountLbl = 'Total Amount';
    }

    var
        Customer: Record Customer;
        Auto: Record "ALLUAutomobile";
        CompanyInfo: Record "Company Information";
        RentalAmount: Decimal;
        ServiceAmount: Decimal;
}
