public class OrderPDFController {
    
    @auraEnabled
    public Static void saveOrderPDF(string recordId)
    {
        //system.debug(recordId);
        PageReference pdfPage = new PageReference('/apex/OrderVerticalPerforma');
        pdfPage.getParameters().put('Id',recordId);
        String orderName  = [SELECT Id, OrderNumber,Order_Number__c FROM order WHERE Id =: recordId].Order_Number__c;
        ContentVersion cont = new ContentVersion();
        cont.Title = orderName +'-Sales Order/Pro-Forma Invoice';
        cont.PathOnClient = 'file.pdf';
        blob pdfBody;
        if(Test.isRunningTest()) { 
            pdfBody = blob.valueOf('Unit.Test');
        } else {
            pdfBody = pdfPage.getContentAsPDF();
        }
        //cont.VersionData = pdfPage.getContentAsPdf();
        cont.VersionData = pdfBody;
        cont.Origin = 'H';
        insert cont; 
        
        ContentVersion contentVersionn = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cont.Id LIMIT 1];
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = recordId;
        contentlink.contentdocumentid = contentVersionn.contentdocumentid;
        contentlink.ShareType = 'V';
        system.debug(contentlink);
        insert contentlink;
    }
    
}