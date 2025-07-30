page 66040 "ALLURentalCard"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "ALLURentalHeader";
    Caption = 'Auto Rent Card';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = Rec.Status = Rec.Status::Open;

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer number';
                    ShowMandatory = true;
                }
                field(CustomerName; GetCustomerName())
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                    Editable = false;
                    ToolTip = 'Specifies the customer name';
                }
                field("Date"; Rec.Date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document date';
                }
                field("Auto No."; Rec."Auto No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the automobile number';
                    ShowMandatory = true;
                }
                field(AutoName; GetAutoName())
                {
                    ApplicationArea = All;
                    Caption = 'Auto Name';
                    Editable = false;
                    ToolTip = 'Specifies the automobile name';
                }
                field("Reserved From"; Rec."Reserved From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rental start date';
                    ShowMandatory = true;
                }
                field("Reserved To"; Rec."Reserved To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the rental end date';
                    ShowMandatory = true;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document status';
                    Editable = false;
                    StyleExpr = StatusStyleExpr;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total rental amount';
                }
            }
            group("Driver Information")
            {
                Caption = 'Driver Information';

                field("Driver License"; Rec."Driver License")
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    ToolTip = 'Specifies the driver license image';
                }
            }
            part(Lines; "ALLURentalLines")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
                Editable = Rec.Status = Rec.Status::Open;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Functions)
            {
                Caption = 'Functions';

                action(UploadDriverLicense)
                {
                    Caption = 'Upload Driver License';
                    ApplicationArea = All;
                    Image = Picture;
                    Enabled = Rec.Status = Rec.Status::Open;
                    ToolTip = 'Upload the driver license image';

                    trigger OnAction()
                    var
                        InStr: InStream;
                        FileName: Text;
                    begin
                        if UploadIntoStream(SelectDriverLicenseMsg, '', 'Image Files (*.jpg;*.jpeg;*.png)|*.jpg;*.jpeg;*.png', FileName, InStr) then begin
                            Rec."Driver License".ImportStream(InStr, FileName);
                            Rec.Modify(true);
                        end;
                    end;
                }
                action(DeleteDriverLicense)
                {
                    Caption = 'Delete Driver License';
                    ApplicationArea = All;
                    Image = Delete;
                    Enabled = Rec.Status = Rec.Status::Open;
                    ToolTip = 'Delete the driver license image';

                    trigger OnAction()
                    begin
                        if not Rec."Driver License".HasValue() then
                            exit;

                        if Confirm(DeleteLicenseQst) then begin
                            Clear(Rec."Driver License");
                            Rec.Modify(true);
                        end;
                    end;
                }
                action(Release)
                {
                    Caption = 'Change Status to Released';
                    ApplicationArea = All;
                    Image = ReleaseDoc;
                    Enabled = Rec.Status = Rec.Status::Open;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Release the rental document';

                    trigger OnAction()
                    begin
                        Rec.ChangeStatusToReleased();
                        CurrPage.Update(false);
                    end;
                }
                action(ReturnAuto)
                {
                    Caption = 'Return Auto';
                    ApplicationArea = All;
                    Image = Return;
                    Enabled = Rec.Status = Rec.Status::Released;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Process the automobile return';

                    trigger OnAction()
                    begin
                        if Confirm(ReturnAutoQst) then begin
                            Rec.ReturnAuto();
                            CurrPage.Close();
                        end;
                    end;
                }
            }
        }
        area(Reporting)
        {
            action(Print)
            {
                Caption = 'Print';
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
                PromotedOnly = true;
                ToolTip = 'Print the rental contract';

                trigger OnAction()
                var
                    RentalHeader: Record "ALLURentalHeader";
                begin
                    RentalHeader := Rec;
                    RentalHeader.SetRecFilter();
                    Report.Run(66030, true, true, RentalHeader);
                end;
            }
        }
        area(Navigation)
        {
            action(Damages)
            {
                Caption = 'Damages';
                ApplicationArea = All;
                Image = Warning;
                RunObject = Page "ALLURentalDamageList";
                RunPageLink = "Document No." = FIELD("No.");
                ToolTip = 'View the damages for this rental';
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetStatusStyle();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetStatusStyle();
    end;

    var
        DeleteLicenseQst: Label 'Do you want to delete the driver license image?';
        ReturnAutoQst: Label 'Do you want to process the automobile return?';
        SelectDriverLicenseMsg: Label 'Select Driver License';
        StatusStyleExpr: Text;

    local procedure GetCustomerName(): Text[100]
    var
        Customer: Record Customer;
    begin
        if Customer.Get(Rec."Customer No.") then
            exit(Customer.Name);
    end;

    local procedure GetAutoName(): Text[100]
    var
        Auto: Record "ALLUAutomobile";
    begin
        if Auto.Get(Rec."Auto No.") then
            exit(Auto.Name);
    end;

    local procedure SetStatusStyle()
    begin
        StatusStyleExpr := '';
        case Rec.Status of
            Rec.Status::Released:
                StatusStyleExpr := 'Favorable';
        end;
    end;
}
