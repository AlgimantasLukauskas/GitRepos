table 66001 MyNewTable
{

    DataClassification = ToBeClassified;
    ObsoleteState = Pending;
    ObsoleteReason = 'Table no longer needed';
    fields
    {
        field(1; Myfield; Integer)
        {
            Caption = 'MyField';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; Myfield)
        {
            Clustered = true;
        }
    }
}
