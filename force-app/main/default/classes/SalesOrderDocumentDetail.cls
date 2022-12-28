Public Class SalesOrderDocumentDetail{
    
    String recordId;
    public Contact con {get;set;}
    public List<OrderItem> OLIlist {get;set;}
    public Opportunity Opps {get;set;}
    public Bank_Details__mdt bankdetails {get;set;}
    public Decimal totalAmountwithPackingcharge {get;set;}
    public Decimal sgst {get;set;}
    public Decimal cgst {get;set;}
    public Decimal igst {get;set;}
    public Boolean flag {get;set;}
    public Decimal totalAmountwithSGST {get;set;}
    public Decimal totalAmountwithCGST {get;set;}
    public Decimal totalAmountwithIGST {get;set;}
    public String amtInWords{get;set;}
    public String amtInwordsIGST {get;set;}
    public SalesOrderDocumentDetail(ApexPages.StandardController stdController){
        
        recordId = stdController.getId();
        system.debug('===>recordId ' +recordId );
        Order ord = [select AccountId,Quote.Bank__c,Quote.Entity_Name1__c,OpportunityId,TotalAmount,id,Quote.Packing_Charges__c,Quote.GST_Number_Buyer__c from Order where id = : recordId];
        totalAmountwithPackingcharge = 0;
        totalAmountwithSGST = 0;
        totalAmountwithCGST = 0;
        totalAmountwithIGST = 0;
        
        if(ord.Quote.Packing_Charges__c != null)
        {
            totalAmountwithPackingcharge = ord.TotalAmount + ord.Quote.Packing_Charges__c;
        }
        else{
            totalAmountwithPackingcharge = ord.TotalAmount;
        }
        
        if(ord.Quote.GST_Number_Buyer__c != null)
        {
            if(ord.Quote.GST_Number_Buyer__c.startsWith('24'))
            {
                flag = true;
                
            }
            else{
                flag = false;
            }
        }
        con = [select id,Name,Email,MobilePhone,MailingStreet,MailingCity,MailingState,MailingPostalCode from contact where AccountId =: ord.AccountId order by CreatedDate Limit 1];
        
        if(ord.OpportunityId != null)
        {
            Opps = [select id,CloseDate,Due_Date__c from Opportunity where id = : ord.OpportunityId];
        }
        OLIlist = [select id,Quantity,Product2Id, Product2.Name,Product2.ProductCode,Product2.UOM__c,UnitPrice,TotalPrice,SGST__c,CGST__c,IGST__c from OrderItem where OrderId = : ord.id];
        if(OLIlist.size() > 0)
        {
            for(OrderItem oi : OLIlist)
            {
                
                
                if(oi.SGST__c <> null){
                    sgst = oi.SGST__c;
                    totalAmountwithSGST = sgst + totalAmountwithPackingcharge;
                    
                }
                if(oi.CGST__c <> null){
                    cgst = oi.CGST__c;
                    totalAmountwithCGST = cgst + sgst + totalAmountwithPackingcharge;
                }
                
                if(oi.IGST__c <> null)
                {
                    igst = oi.IGST__c;
                    totalAmountwithIGST = igst + totalAmountwithPackingcharge;
                }
            }
        }
        amtInWords = NumberTOWordConvertion.getNumberTOWordConvertion(totalAmountwithCGST);
        amtInwordsIGST = NumberTOWordConvertion.getNumberTOWordConvertion(totalAmountwithIGST);
        system.debug('====> OLIlist ' + OLIlist);
        String a = '%'+ord.Quote.Bank__c+'%';
        String EntityName = ord.Quote.Entity_Name1__c;
        if(!test.isRunningTest()){
            bankdetails = [select Account_Number__c,Branch__c,IFSC_Code__c,Beneficiary_Account__c,Beneficiary_Bank__c,Beneficiary_Name__c,Swift_code__c,Entity_Name__c from Bank_Details__mdt where Bank_API__c  like :a AND Entity_Name__c =:EntityName Limit 1];
        }
        // Bank Details
        // bankdetails = [select id,Bank_API__c,Beneficiary_Account__c,Beneficiary_Bank__c,Beneficiary_Name__c,Swift_code__c from Bank_Details__mdt
        //                                          where Bank_API__c =: 'Bank of Baroda'];
        
    } 
    
}