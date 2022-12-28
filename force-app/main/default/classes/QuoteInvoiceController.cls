public class QuoteInvoiceController {
 
    @auraEnabled
    public static void savePdf(string recordId)
    {
        //system.debug(recordId);
        PageReference pdfPage = new PageReference('/apex/quotePerformaInvoice');
        pdfPage.getParameters().put('Id',recordId);
        String quotationNumber  = [SELECT Id, Name,Quote_Number__c FROM Quote WHERE Id =: recordId].Quote_Number__c;
          String quotationName  = [SELECT Id, Name,Quote_Number__c FROM Quote WHERE Id =: recordId].Name;
        ContentVersion cont = new ContentVersion();
        cont.Title = quotationNumber+' - '+quotationName;
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