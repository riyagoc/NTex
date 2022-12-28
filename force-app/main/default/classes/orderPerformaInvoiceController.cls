public class orderPerformaInvoiceController {
    Private order ord;
    @TestVisible List<Bank_Details__mdt> metaDataList = new List<Bank_Details__mdt>();
    List<Order> qtsRecords = new list<Order>();
    List<Advance_Payment__c> advPaymentRecords {get; set;} 
    
    public orderPerformaInvoiceController(ApexPages.StandardController controller)
    {
        this.ord = (Order)controller.getRecord();
        qtsRecords = [select id,Quote.RecordType.Name,Quote.Bank__c,PI_Number__c,Is_Performa_Generate__c,Total_Amount_Performa_Invoice__c,Quote.Entity_Name1__c from Order where id =: ord.id];
        String a = '%'+qtsRecords[0].Quote.Bank__c+'%';
        String EntityName = qtsRecords[0].Quote.Entity_Name1__c;
        metaDataList = [select Account_Number__c,Branch__c,IFSC_Code__c,Beneficiary_Account__c,Beneficiary_Bank__c,Beneficiary_Name__c,Swift_code__c from Bank_Details__mdt where Bank_API__c like :a AND Entity_Name__c =:EntityName Limit 1];
        // system.debug('Line number 10 -----'+ qtsRecords[0].Total_Amount_Performa_Invoice__c);
    
    } 
    public List<Advance_Payment__c> getadvPaymentRecords(){
          //for get advance payment Records
          advPaymentRecords= new List<Advance_Payment__c>();
            advPaymentRecords = [select id,Advance_Amount__c,Advance_Payment_Date__c,Payment_Mode__c,Order__c from Advance_Payment__c where Order__c =: ord.Id];
            System.debug('advPaymentRecords :'+advPaymentRecords);
        return advPaymentRecords;
    }
    
    public decimal getPackingLineTotal(){
        List<Order> odr=[Select id,Packing_Charges__c, Packing_GST_Amount__c from Order where id =: ord.id];
        Decimal Amount=odr[0].Packing_Charges__c+odr[0].Packing_GST_Amount__c;
        return Amount;
    }
    public decimal getInsuranceLineTotal(){
        List<Order> odr=[Select id,Final_Value__c,Insurance_GST_Amount__c from Order where id =: ord.id];
        Decimal finalval=odr[0].Final_Value__c != null?odr[0].Final_Value__c:0.0 ;
        Decimal Insurance=odr[0].Insurance_GST_Amount__c !=null?odr[0].Insurance_GST_Amount__c:0.0;
        Decimal Amount = finalval+Insurance;
        return Amount;
    }
    public decimal getTransportLineTotal(){
        List<Order> odr=[Select id,Transport_Charges__c,Transport_GST_Amount__c  from Order where id =: ord.id];
        Decimal Amount=odr[0].Transport_Charges__c+odr[0].Transport_GST_Amount__c ;
        return Amount;
    }
    public decimal getTotal_After_Discount(){
        List<Order> odr=[Select id,Packing_Charges__c,Final_Value__c,Transport_Charges__c,Total_After_Discount_Hidden__c from Order where id =: ord.id];
        Decimal Amount=odr[0].Packing_Charges__c+odr[0].Transport_Charges__c+odr[0].Final_Value__c+odr[0].Total_After_Discount_Hidden__c;
        return Amount;
    }
    public decimal getTotal_GST_Amount(){
        List<Order> odr=[Select id,Quote.Total_GST__c,Final_Value__c,Transport_Charges__c,Total_Gst_Amount_Hidden__c from Order where id =: ord.id];
        Decimal Amount=odr[0].Quote.Total_GST__c+odr[0].Total_Gst_Amount_Hidden__c;
        return Amount;
    }
    public String getAmtInWords() {
        List<order> qtsQry = [select Total_Amount_Performa_Invoice__c from order where id =: ord.Id];
        Decimal Amnt = qtsQry[0].Total_Amount_Performa_Invoice__c;
        string amtInWords = NumberTOWordConvertion.getNumberTOWordConvertion(Amnt);
        return amtInWords;
    }
     public decimal getLine_Item_Total_Amount(){
         List<order> quo=[Select id,Total_Gst_Amount_Hidden__c,Total_After_Discount_Hidden__c from order where id =: ord.id];
        Decimal Amount=quo[0].Total_Gst_Amount_Hidden__c+quo[0].Total_After_Discount_Hidden__c;
        return Amount;
     }
    
    public String getroundoffValue() {
        List<Order> qtsQry = [select id,Quote.RecordType.Name,Bank__c,Quote.Total_OF_All__c,Quote.Entity_Name1__c,Round_Off__c from Order where id =: ord.Id];
        //Decimal Amnt = qtsQry[0].Round_Off__c;
        String s = String.valueOf(qtsQry[0].Quote.Total_OF_All__c);
        String roundOffValue =s.substringAfter('.');
        if(roundOffValue >='50'){
            Integer roundOffValue2= 100- Integer.valueof(roundOffValue);
            String roundoffValue3='.'+String.valueOf(roundOffValue2);
            System.debug('roundoffValue3'+roundoffValue3);
            return roundoffValue3;
        }else{
            String roundoffValue3='.'+String.valueOf(roundOffValue);
              System.debug('roundoffValue3'+roundoffValue3);
            return roundoffValue3;
        }
    }
    
    public void updatingSeries()
    {
        Count__c ct = Count__c.getOrgDefaults();
        
        if(qtsRecords[0].Is_Performa_Generate__c == true)
        {
            string versionNumber = String.valueOf(ct.Performa_Invoice_version_Count__c+1).removeEnd('.0');
            qtsRecords[0].PI_Number__c = 'O'+String.valueOf(ct.Performa_Invoice_Count__c).removeEnd('.0')+'-'+versionNumber;
            System.debug(qtsRecords[0].PI_Number__c);
            ct.Performa_Invoice_version_Count__c = ct.Performa_Invoice_version_Count__c+1; 
        }
        if(qtsRecords[0].Is_Performa_Generate__c == false)
        {
            string qnumber = String.valueOf(ct.Performa_Invoice_Count__c +1);
            qtsRecords[0].PI_Number__c = 'O'+qnumber.removeEnd('.0')+'-'+String.valueOf(ct.Performa_Invoice_version_Count__c).removeEnd('.0');
            System.debug(qtsRecords[0].PI_Number__c);
            ct.Performa_Invoice_Count__c = ct.Performa_Invoice_Count__c+1;
            qtsRecords[0].Is_Performa_Generate__c = true; 
            
        }
        
        update qtsRecords[0];
        update ct;
    }
    
    public string getBeneficiaryName(){
        return metaDataList[0].Beneficiary_Name__c;
    }
    public decimal getBeneficiaryAccount(){
        return metaDataList[0].Beneficiary_Account__c;
    }
    public string getBeneficiaryBank(){
        return metaDataList[0].Beneficiary_Bank__c;
    }
    public string getBeneficiarySwiftcode(){
        return metaDataList[0].Swift_code__c;
    }
    public string getIFSCCode(){
        return metaDataList[0].IFSC_Code__c;
    }
    public string getbranch(){
        return metaDataList[0].Branch__c;
    }
    public string getPiNumber(){
        qtsRecords = [select id,Quote.Bank__c,PI_Number__c,Is_Performa_Generate__c,Total_Amount_Performa_Invoice__c from Order where id =: ord.id];
        return String.valueOf(qtsRecords[0].PI_Number__c);
    }
    
}