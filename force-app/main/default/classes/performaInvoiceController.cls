public with sharing class performaInvoiceController {
    public performaInvoiceController() {}

    @AuraEnabled
    public static void savePdf(string recordId)
    {
        PageReference pdfPage = new PageReference('/apex/PerformaInvoice');
        pdfPage.getParameters().put('Id',recordId);
        String orderName  = [SELECT Id, Order_Number__c FROM Order WHERE Id =: recordId].Order_Number__c;
        ContentVersion cont = new ContentVersion();
        cont.Title = 'Performa invoice of '+orderName +'/'+ date.today();
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