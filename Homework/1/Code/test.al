table 66003 MyNewTable
{
    DataClassification = ToBeClassified;

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