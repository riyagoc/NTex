public class quotePerformaInvoiceController {
Private Quote ord;
    
    List<Quote> qtsRecords = new list<Quote>();
    
    public quotePerformaInvoiceController(ApexPages.StandardController controller)
    {
        system.debug('quotePerformaInvoiceController');
        this.ord = (Quote)controller.getRecord();
        qtsRecords = [select id,Name,Quote_Number__c,PDF_Count__c,RecordType.Name,Bank__c,Total_Amount_Performa_Invoice__c,Entity_Name1__c from Quote where id =: ord.id];
        String a = '%'+qtsRecords[0].Bank__c+'%';
        String EntityName = qtsRecords[0].Entity_Name1__c;
        String myGeneratedFileName = qtsRecords[0].Quote_Number__c ;
        String quoteNumber = qtsRecords[0].Name;
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+myGeneratedFilename+'.pdf'); 
        system.debug(EntityName);
        
    }
    public void controllermethod()
    {
        if(qtsRecords[0].PDF_Count__c <> null)
        {
            qtsRecords[0].PDF_Count__c = qtsRecords[0].PDF_Count__c + 1;
            update qtsRecords[0];
        }
    }
    public Decimal getPacking_Tranport_InsuranceAMT(){
        List<Quote> quo=[Select id,Packing_Charges__c,Final_Value__c,Transport_Charges__c from Quote where id =: ord.id];
        Decimal Amount=quo[0].Packing_Charges__c+quo[0].Transport_Charges__c+quo[0].Final_Value__c;
        return Amount;
    }
    public decimal getLineTotal(){
        List<Quote> quo=[Select id,Packing_Charges__c,Final_Value__c,Transport_Charges__c,Total_GST__c,Insurance_GST__c, Packing_GST_Amount__c, Insurance_GST_Amount__c from Quote where id =: ord.id];
        Decimal Amount=quo[0].Packing_Charges__c+quo[0].Transport_Charges__c+quo[0].Final_Value__c+quo[0].Total_GST__c;
        return Amount;
    }
    public decimal getPackingLineTotal(){
        List<Quote> quo=[Select id,Packing_Charges__c, Packing_GST_Amount__c from Quote where id =: ord.id];
        Decimal Amount;
        if(quo[0].Packing_Charges__c !=null && quo[0].Packing_GST_Amount__c !=null){
            Amount=quo[0].Packing_Charges__c+quo[0].Packing_GST_Amount__c;
        }
        System.debug('packingLineTotal--'+Amount);
        return Amount;
    }
    public decimal getTotal_After_Discount(){
        List<Quote> quo=[Select id,Packing_Charges__c,Final_Value__c,Transport_Charges__c,Total_After_Discount_Hidden__c from Quote where id =: ord.id];
        Decimal Amount=quo[0].Packing_Charges__c+quo[0].Transport_Charges__c+quo[0].Final_Value__c+quo[0].Total_After_Discount_Hidden__c;
        return Amount;
    }
    public decimal getTotal_GST_Amount(){
        List<Quote> quo=[Select id,Total_GST__c,Final_Value__c,Transport_Charges__c,Total_Gst_Amount_Hidden__c from Quote where id =: ord.id];
        Decimal Amount=quo[0].Total_GST__c+quo[0].Total_Gst_Amount_Hidden__c;
        return Amount;
    }
     
    public String getAmtInWords() {
        List<Quote> qtsQry = [select id,RecordType.Name,Bank__c,Total_OF_All__c,Entity_Name1__c,Round_Off__c from Quote where id =: ord.Id];
        Decimal Amnt = qtsQry[0].Round_Off__c;
        string amtInWords = NumberTOWordConvertion.getNumberTOWordConvertion(Amnt);
        return amtInWords;
    }
    public decimal getLine_Item_Total_Amount(){
         List<Quote> quo=[Select id,Total_Gst_Amount_Hidden__c,Total_After_Discount_Hidden__c from Quote where id =: ord.id];
        Decimal Amount=quo[0].Total_Gst_Amount_Hidden__c+quo[0].Total_After_Discount_Hidden__c;
        return Amount;
     }
     public decimal getInsuranceLineTotal(){

        Decimal Amount;
         List<Quote> quo=[Select id,Final_Value__c,Insurance1__c ,Calculated_values__c,Total_After_Discount_Hidden__c,Insurance_GST_Amount__c from Quote where id =: ord.id];
        
         if(quo[0].Calculated_values__c != null && quo[0].Insurance_GST_Amount__c !=null){
            Amount=quo[0].Calculated_values__c+quo[0].Insurance_GST_Amount__c;

        }else if(quo[0].Final_Value__c != null && quo[0].Insurance_GST_Amount__c !=null){
            Amount=quo[0].Final_Value__c+quo[0].Insurance_GST_Amount__c;
        }
        return Amount;
     }
     public decimal getTransportLineTotal(){
         List<Quote> quo=[Select id,Transport_Charges__c,Transport_GST_Amount__c from Quote where id =: ord.id];
         Decimal Amount;
         if(quo[0].Transport_Charges__c != null && quo[0].Transport_GST_Amount__c!=null){
            Amount=quo[0].Transport_Charges__c+quo[0].Transport_GST_Amount__c;
         }
        
        return Amount;
     }
     
     
     public String getroundoffValue() {
        List<Quote> qtsQry = [select id,RecordType.Name,Bank__c,Total_OF_All__c,Entity_Name1__c,Round_Off__c from Quote where id =: ord.Id];
        //Decimal Amnt = qtsQry[0].Round_Off__c;
         String s = String.valueOf(qtsQry[0].Total_OF_All__c);
         String roundOffValue =s.substringAfter('.');
         if(roundOffValue >='50'){
         Integer roundOffValue2= 100- Integer.valueof(roundOffValue);
         String roundoffValue3='.'+String.valueOf(roundOffValue2);
        return roundoffValue3;
         }else{
             String roundoffValue3='.'+String.valueOf(roundOffValue);
             return roundoffValue3;
         }
    }

  
    
    // public string getBeneficiaryName(){
    //     return metaDataList[0].Beneficiary_Name__c;
    // }
    // public decimal getBeneficiaryAccount(){
    //     return metaDataList[0].Beneficiary_Account__c;
    // }
    // public string getBeneficiaryBank(){
    //     return metaDataList[0].Beneficiary_Bank__c;
    // }
    // public string getBeneficiarySwiftcode(){
    //     return metaDataList[0].Swift_code__c;
    // }
    // public string getIFSCCode(){
    //     return metaDataList[0].IFSC_Code__c;
    // }
    // public string getbranch(){
    //     return metaDataList[0].Branch__c;
    // }
    //public string getPiNumber(){
      ///  qtsRecords = [select id,Quote.Bank__c,PI_Number__c,Is_Performa_Generate__c,Total_Amount_Performa_Invoice__c from Order where id =: ord.id];
        //return String.valueOf(qtsRecords[0].PI_Number__c);
    //}
}