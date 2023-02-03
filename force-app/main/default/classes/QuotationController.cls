public class QuotationController {
    private Quote qts;
    // @TestVisible List<Bank_Details__mdt> metaDataList = new List<Bank_Details__mdt>();
    List<Contact> contact = new List<Contact>();
    List<Quote> qtsRecords = new list<Quote>();
    
Public QuotationController(ApexPages.StandardController controller)
    {  
        this.qts = (Quote)controller.getRecord();
        qtsRecords = [select Quote_Number__c,PDF_Count__c,Bank__c,Entity_Name1__c from Quote where id =: qts.id];
        String a = '%'+qtsRecords[0].Bank__c+'%';
        String EntityName = qtsRecords[0].Entity_Name1__c;
        String myGeneratedFileName = qtsRecords[0].Quote_Number__c;
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+myGeneratedFilename+'.pdf'); 
        system.debug(EntityName);
        // metaDataList = [select Beneficiary_Account__c,Current_A_C_No__c,Entity_Name__c,IFSC_Code__c,Beneficiary_Bank__c,Beneficiary_Name__c,Swift_code__c from Bank_Details__mdt where Bank_API__c like :a AND Entity_Name__c =:EntityName  Limit 1];
        // system.debug(metaDataList);
    }
    
    public void controllermethod()
    {
        if(qtsRecords[0].PDF_Count__c <> null)
        {
            qtsRecords[0].PDF_Count__c = qtsRecords[0].PDF_Count__c + 1;
            update qtsRecords[0];
        }
    }
    
    public String getAmtInWordsForFOB() {
        List<Quote> qtsQry = [select Total_FOB__c from Quote where id =: qts.Id];
        system.debug(qtsQry[0]);
        Decimal Amnt = qtsQry[0].Total_FOB__c;
        string amtInWordsForFOB = NumberTOWordConvertion.getNumberTOWordConvertion(Amnt);
        return amtInWordsForFOB;
    }
    public String getAmtInWordsForCK() {
        List<Quote> qtsQry = [select Total_C_K__c from Quote where id =: qts.Id];
        system.debug(qtsQry[0]);
        Decimal Amnt = qtsQry[0].Total_C_K__c;
        string amtInWordsForCK = NumberTOWordConvertion.getNumberTOWordConvertion(Amnt);
        return amtInWordsForCK;
    }
    
    public String getAmtInWordsForCIF() {
        List<Quote> qtsQry = [select Total_CIF__c from Quote where id =: qts.Id];
        system.debug(qtsQry[0]);
        Decimal Amnt = qtsQry[0].Total_CIF__c;
        string amtInWordsForCIF = NumberTOWordConvertion.getNumberTOWordConvertion(Amnt);
        return amtInWordsForCIF;
    }
     public String getroundoffValue() {
        List<Quote> qtsQry = [select id,RecordType.Name,Bank__c,Total_OF_All__c,Total_FOB__c,Entity_Name1__c,Round_Off__c from Quote where id =: qts.Id];
        //Decimal Amnt = qtsQry[0].Round_Off__c;
         String s = String.valueOf(qtsQry[0].Total_FOB__c);
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
    // public string getCurrentAccountNo(){
    //     return metaDataList[0].Current_A_C_No__c;
    // }
    // public string getIFSCCode(){
    //     return metaDataList[0].IFSC_Code__c;
    // }
    
    

     
}