public with sharing class OrderVerticalController {

    private Order order;
   
    List<Contact> contact = new List<Contact>();
    List<Order> ordRecords = new list<Order>();

    public OrderVerticalController(ApexPages.StandardController controller) {
        this.order = (Order)controller.getRecord();
        ordRecords = [select Order_Number__c,Bank__c,Entity_Name1__c from Order where id =: order.id];
        String a = '%'+ordRecords[0].Bank__c+'%';
        String EntityName = ordRecords[0].Entity_Name1__c;
        String myGeneratedFileName = ordRecords[0].Order_Number__c;
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+myGeneratedFilename+'.pdf'); 
        system.debug(EntityName);
    }
    public List<Advance_Payment__c> getadvPaymentRecords(){
        //for get advance payment Records
        List<Advance_Payment__c> advPaymentRecords= new List<Advance_Payment__c>();
          advPaymentRecords = [select id,Advance_Amount__c,Advance_Payment_Date__c,Payment_Mode__c,Order__c from Advance_Payment__c where Order__c =: order.Id];
          System.debug('advPaymentRecords :'+advPaymentRecords);
      return advPaymentRecords;
  }
    public String getAmtInWordsForFOB() {
        List<Order> ordQry = [select Total_FOB__c from Order where id =: order.Id];
        system.debug(ordQry[0]);
        Decimal Amnt = ordQry[0].Total_FOB__c;
        string amtInWordsForFOB = NumberTOWordConvertion.getNumberTOWordConvertion(Amnt);
        return amtInWordsForFOB;
    }
    public String getAmtInWordsForCK() {
        List<Order> ordQry = [select Total_C_K__c from Order where id =: order.Id];
        system.debug(ordQry[0]);
        Decimal Amnt = ordQry[0].Total_C_K__c;
        string amtInWordsForCK = NumberTOWordConvertion.getNumberTOWordConvertion(Amnt);
        return amtInWordsForCK;
    }
    
    public String getAmtInWordsForCIF() {
        List<Order> ordQry = [select Total_CIF__c from Order where id =: order.Id];
        system.debug(ordQry[0]);
        Decimal Amnt = ordQry[0].Total_CIF__c;
        string amtInWordsForCIF = NumberTOWordConvertion.getNumberTOWordConvertion(Amnt);
        return amtInWordsForCIF;
    }
    public String getroundoffValue() {
        List<Order> ordQry = [select id,RecordType.Name,Bank__c,Total_FOB__c,Entity_Name1__c,Round_Off__c from Order where id =: order.Id];
        //Decimal Amnt = qtsQry[0].Round_Off__c;
         String s = String.valueOf(ordQry[0].Total_FOB__c);
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

}
