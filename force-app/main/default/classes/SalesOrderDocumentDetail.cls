Public Class SalesOrderDocumentDetail{
    
    String recordId;
    public List<OrderItem> OLIlist {get;set;}
    Public Order ord {get;set;}
    
    public SalesOrderDocumentDetail(ApexPages.StandardController stdController){
        System.debug('VF PAge load');
        
        recordId = stdController.getId();
        system.debug('===>recordId ' +recordId );
        ord = [select AccountId,Name,Order_Number__c,RecordType.Name,Quote.Entity_Name1__c,OpportunityId,id from Order where id = : recordId];
        OLIlist = [select id,Quantity,Product2Id,Product2.Product_Model_Number__c, Product2.Name,Product2.ProductCode,Product2.UOM__c from OrderItem where OrderId = : ord.id];
        System.debug('OLIlist::'+OLIlist);
        String OrderNumberSave = ord.Order_Number__c;
       
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+OrderNumberSave+'.pdf'); 

        
    } 
    
}