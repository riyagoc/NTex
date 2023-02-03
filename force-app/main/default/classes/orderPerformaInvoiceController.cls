public class orderPerformaInvoiceController {
    Private order ord;
   
    List<Order> qtsRecords = new list<Order>();
    List<Advance_Payment__c> advPaymentRecords {get; set;} 
    
    public orderPerformaInvoiceController(ApexPages.StandardController controller)
    {
        this.ord = (Order)controller.getRecord();
        qtsRecords = [select id,Name,Order_Number__c,Quote.RecordType.Name,Quote.Bank__c,PI_Number__c,Is_Performa_Generate__c,Total_Amount_Performa_Invoice__c,Quote.Entity_Name1__c from Order where id =: ord.id];
        String a = '%'+qtsRecords[0].Quote.Bank__c+'%';
        String EntityName = qtsRecords[0].Quote.Entity_Name1__c;
        String myGeneratedFileName = qtsRecords[0].Order_Number__c ;
        
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+myGeneratedFilename+'.pdf'); 
        system.debug(EntityName);
        
    
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
        Decimal Amount;
        if(odr[0].Packing_Charges__c!=null && odr[0].Packing_GST_Amount__c!=null){
            Amount=odr[0].Packing_Charges__c+odr[0].Packing_GST_Amount__c;
        }
        return Amount;
    }
    public decimal getInsuranceLineTotal(){
        Decimal Amount;

        List<Order> odr=[Select id,Insurance1__c,Calculated_values__c,Final_Value__c,Total_After_Discount_Hidden__c,Insurance_GST_Amount__c from Order where id =: ord.id];
        
        if(odr[0].Calculated_values__c != null && odr[0].Insurance_GST_Amount__c !=null){
            Amount=odr[0].Calculated_values__c+odr[0].Insurance_GST_Amount__c;

        }else if(odr[0].Final_Value__c != null && odr[0].Insurance_GST_Amount__c !=null){
             Amount=odr[0].Final_Value__c+odr[0].Insurance_GST_Amount__c;
        }
        return Amount;
    }
    public decimal getTransportLineTotal(){
        List<Order> odr=[Select id,Transport_Charges__c,Transport_GST_Amount__c  from Order where id =: ord.id];
        Decimal Amount;
        if(odr[0].Transport_Charges__c !=null && odr[0].Transport_GST_Amount__c !=null ){
           Amount=odr[0].Transport_Charges__c+odr[0].Transport_GST_Amount__c ;
        }
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
        List<order> qtsQry = [select Round_Off__c,Total_Amount_Performa_Invoice__c from order where id =: ord.Id];
        Decimal Amnt = qtsQry[0].Round_Off__c;
        string amtInWords = NumberTOWordConvertion.getNumberTOWordConvertion(Amnt);
        return amtInWords;
    }
     public decimal getLine_Item_Total_Amount(){
         List<order> quo=[Select id,Total_Gst_Amount_Hidden__c,Total_After_Discount_Hidden__c from order where id =: ord.id];
        Decimal Amount=quo[0].Total_Gst_Amount_Hidden__c+quo[0].Total_After_Discount_Hidden__c;
        return Amount;
     }
    
    public String getroundoffValue() {
        List<Order> qtsQry = [select id,Quote.RecordType.Name,Bank__c,Total_Amount_Performa_Invoice__c,Quote.Entity_Name1__c,Round_Off__c from Order where id =: ord.Id];
        //Decimal Amnt = qtsQry[0].Round_Off__c;
        String s = String.valueOf(qtsQry[0].Total_Amount_Performa_Invoice__c);
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
    
    /*public void updatingSeries()
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
    }*/
    
    
}