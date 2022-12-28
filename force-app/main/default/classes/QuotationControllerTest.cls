@isTest
public class QuotationControllerTest {
    
    // Code Coverage for mention below Apex classes in QuotationControllerDoinit And QuotationControllerDoinit2 TestMethod 
    // QuotationController and QuotePDFController and QuoteInvoiceController (Appex Classes)
    // AccountTrigger (Apex Trigger) and AccountTriggerHandler (Apex Class )
    // PopulateVoucherNo (Apex Trigger)
    
    Static testMethod void QuotationControllerDoinit(){
        test.startTest();
        Id oppRecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        Id quoteRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        system.debug('quoteRecordTypeId==='+quoteRecordTypeId);
        system.debug('oppRecordtypeId==='+oppRecordtypeId);
        List<Bank_Details__mdt> bankMetaData = [select Beneficiary_Account__c,Bank_API__c,Current_A_C_No__c,Entity_Name__c,IFSC_Code__c,Beneficiary_Bank__c,Beneficiary_Name__c,Swift_code__c from Bank_Details__mdt];
        
        Count__c countSetting = New Count__c();
        countSetting.Indian_Customer_Code__c = 10;
        countSetting.N_TEX_Engineering_LastOrderNumber__c = 20.00;
        insert countSetting;
        
        
        VoucherNumberDetail__c vochNum = New VoucherNumberDetail__c();
        vochNum.Name = 'Name';
        vochNum.Financial_Year__c = '2020-21';
        insert vochNum;
        
        Account acc = New Account();
        acc.Name = 'Manras Test';
        acc.Business_domain__c = 'Domestic';
        Insert acc;
        
        
        
        Address__c address = New Address__c();
        address.Name = acc.Name;
        address.Account__c = acc.Id;
        Insert address;
        
        Contact con = New Contact();
        con.LastName = 'Testing Manras';
        con.FirstName = 'Testing Manras';
        con.AccountId = acc.Id;
        insert con;
        
        Opportunity opp = New Opportunity();
        opp.Name = 'HPPL';
        opp.CloseDate = system.today();
        opp.StageName = 'Qualification';
        opp.Entity_Name__c = 'N-TEX Engineering Works';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordtypeId;
        Insert opp;
        system.debug('opp==='+opp);
        
        Quote qut = New Quote();
        qut.Entity_Name__c = 'N-TEX Engineering Works';
        qut.Name = 'Testing';
        qut.Subject__c = 'Test Picklist values is pending For Test';
        qut.Delievery_Time__c = '8 To 10 Weeks';
        //qut.Bank__c = 'Bank of Baroda';
        qut.Payment_Term__c = '50% Advance, Balance Against Pro-Forma Invoice, before dispatch of Goods';
        qut.Payment_Mode__c = 'RTGS / NEFT';
        qut.RecordTypeId = quoteRecordTypeId;
        qut.OpportunityId = opp.id;
        qut.PDF_Count__c = 6;
        qut.Packing_Charges__c = 100000000.20;
        qut.status = 'Draft';
        Insert qut;
        
        
        
        system.debug('Test qut debug======'+qut);
        
        Quote qutUpdate = [Select Id,PDF_Count__c,Entity_Name__c,status FROM Quote WHERE Id =:qut.Id];
        qutUpdate.status = 'Accepted';
        update qutUpdate;
        
        system.debug('Test qutUpdate debug======'+qutUpdate);
        
        Order ord = [Select Id,Billing_Address__c,Shipping_Address__c,QuoteId,Entity_Name__c FROM Order WHERE QuoteId =:qutUpdate.Id];
        
        system.debug('Test Order debug======'+ord);
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(qut);
        QuotationController testQuote = new QuotationController(sc);
        
        PageReference pageRef = Page.Quotation_Document;
        pageRef.getParameters().put('Id', String.valueOf(qut.Id));
        Test.setCurrentPage(pageRef); 
        testQuote.controllermethod();
        
        testQuote.getAmtInWords();
        testQuote.getroundoffValue();
        testQuote.metaDataList = bankMetaData;
        testQuote.getBeneficiaryName();
        testQuote.getBeneficiaryAccount();
        testQuote.getBeneficiaryBank();
        testQuote.getBeneficiarySwiftcode();
        testQuote.getCurrentAccountNo();
        testQuote.getIFSCCode();
        
        // QuotePDFController Test class code Start
        
        PageReference quotePdfPageref = Page.Quotation_Document;
        pageRef.getParameters().put('Id', String.valueOf(ord.Id));
        Test.setCurrentPage(quotePdfPageref); 
        //QuotePDFController quotePDFClass = New QuotePDFController();
        QuotePDFController.savePdf(qut.Id);
        
        // QuoteInvoiceController Test class code Start
        
        PageReference quoteInvoicePageref = Page.Quotation_Document;
        pageRef.getParameters().put('Id', String.valueOf(ord.Id));
        Test.setCurrentPage(quoteInvoicePageref); 
        QuoteInvoiceController.savePdf(qut.Id);
        
        
        // system.assert Method for QuotationController Class 
        system.assertNotEquals(0,testQuote.metaDataList.size());
        
        //system.assert Method for AccountTriggerHandler Class 
        
        
        Count__c countUpdateStting = [Select Indian_Customer_Code__c,N_TEX_Engineering_LastOrderNumber__c FROM Count__c WHERE Id =:countSetting.Id];
        Account accUpdate = [Select Id,Customer_Code__c FROM Account WHERE Id =:acc.Id];
        List<Address__c> addressList = [Select Id,Account__c FROM Address__c WHERE Account__c =:acc.Id];
        system.assertEquals('DC - 10', accUpdate.Customer_Code__c,false);
        system.assertEquals(11,countUpdateStting.Indian_Customer_Code__c);
        system.assert(addressList.size()!=0);
        
        test.stopTest();
    }
    
    Static testMethod void QuotationControllerDoinit2(){
        test.startTest();
        Id oppRecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        Id quoteRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        
        Count__c countSetting = New Count__c();
        countSetting.Indian_Customer_Code__c = 10;
        countSetting.N_TEX_Engineering_LastOrderNumber__c = 20;
        insert countSetting; 
        
        VoucherNumberDetail__c vochNum = New VoucherNumberDetail__c();
        vochNum.Name = 'Name';
        vochNum.Financial_Year__c = '2020-21';
        insert vochNum;
        
        Account acc = New Account();
        acc.Name = 'Manras Test';
        acc.Business_domain__c = 'Export';
        Insert acc;
        
        Address__c address = New Address__c();
        address.Name = acc.Name;
        address.Account__c = acc.Id;
        Insert address;
        
        Contact con = New Contact();
        con.LastName = 'Testing Manras';
        con.FirstName = 'Testing Manras';
        con.AccountId = acc.Id;
        insert con;
        
        Opportunity opp = New Opportunity();
        opp.Name = 'HPPL';
        opp.CloseDate = system.today();
        opp.StageName = 'Closed Won';
        //opp.Opportunity_Currency__c = 'INR - Indian Rupee';
        opp.Entity_Name__c = 'N-TEX Engineering Works';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordtypeId;
        Insert opp;
        
        Quote qut = New Quote();
        qut.Entity_Name__c = 'N-TEX Engineering Works';
        qut.Name = 'Testing';
        qut.Subject__c = 'Test Picklist values is pending For Test';
        qut.Delievery_Time__c = '8 To 10 Weeks';
        //qut.Bank__c = 'Bank of Baroda';
        qut.Payment_Term__c = '50% Advance, Balance Against Pro-Forma Invoice, before dispatch of Goods';
        qut.Payment_Mode__c = 'RTGS / NEFT';
        qut.RecordTypeId = quoteRecordTypeId;
        qut.OpportunityId = opp.id;
        qut.PDF_Count__c = 6;
        qut.Packing_Charges__c = 12345.20;
        qut.status = 'Draft';
        Insert qut;
        
        
        Quote qutUpdate = [Select Id,status FROM Quote WHERE Id =:qut.Id];
        qutUpdate.status = 'Accepted';
        update qutUpdate;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(qut);
        QuotationController testQuote = new QuotationController(sc);
        
        PageReference pageRef = Page.Quotation_Document;
        pageRef.getParameters().put('Id', String.valueOf(qut.Id));
        Test.setCurrentPage(pageRef); 
        testQuote.controllermethod();
        testQuote.getAmtInWords();
        test.stopTest();
    }
    
    // getAmtInWordsMethod to pass getAmtInWords metohd of QuotationController Apex class and NumberTOWordConvertion Apex class 
    // Also cover orderPerformaInvoiceController Apex class code coverage 
    Static testMethod void getAmtInWordsMethod(){
        test.startTest();
        Id oppRecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        Id quoteRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        
        List<Bank_Details__mdt> bankMetaData = [select Beneficiary_Account__c,Branch__c,Bank_API__c,Current_A_C_No__c,Entity_Name__c,IFSC_Code__c,Beneficiary_Bank__c,Beneficiary_Name__c,Swift_code__c from Bank_Details__mdt];
        
        Count__c countSetting = New Count__c();
        countSetting.Indian_Customer_Code__c = 10;
        countSetting.N_TEX_Engineering_LastOrderNumber__c = 20;
        insert countSetting; 
        
        VoucherNumberDetail__c vochNum = New VoucherNumberDetail__c();
        vochNum.Name = 'Name';
        vochNum.Financial_Year__c = '2020-21';
        insert vochNum;
        
        Account acc = New Account();
        acc.Name = 'Manras Test';
        acc.Business_domain__c = 'Export';
        Insert acc;
        
        Address__c address = New Address__c();
        address.Name = acc.Name;
        address.Account__c = acc.Id;
        Insert address;
        
        Contact con = New Contact();
        con.LastName = 'Testing Manras';
        con.FirstName = 'Testing Manras';
        con.AccountId = acc.Id;
        insert con;
        
        Opportunity opp = New Opportunity();
        opp.Name = 'HPPL';
        opp.CloseDate = system.today();
        opp.StageName = 'Closed Won';
        //opp.Opportunity_Currency__c = 'INR - Indian Rupee';
        opp.Entity_Name__c = 'N-TEX Engineering Works';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordtypeId;
        Insert opp;
        
        Quote qut = New Quote();
        qut.Entity_Name__c = 'N-TEX Engineering Works';
        qut.Name = 'Testing';
        qut.Subject__c = 'Test Picklist values is pending For Test';
        qut.Delievery_Time__c = '8 To 10 Weeks';
        //qut.Bank__c = 'Bank of Baroda';
        qut.Payment_Term__c = '50% Advance, Balance Against Pro-Forma Invoice, before dispatch of Goods';
        qut.Payment_Mode__c = 'RTGS / NEFT';
        qut.RecordTypeId = quoteRecordTypeId;
        qut.OpportunityId = opp.id;
        qut.PDF_Count__c = 6;
        qut.Packing_Charges__c = 12.30;
        qut.status = 'Draft';
        Insert qut;
        
        
        Quote qutUpdate = [Select Id,status FROM Quote WHERE Id =:qut.Id];
        qutUpdate.status = 'Accepted';
        update qutUpdate;
        
        Order ord = [Select Id,OrderNumber,Is_Performa_Generate__c FROM Order WHERE QuoteId = :qutUpdate.Id];
        ord.Is_Performa_Generate__c = false;
        update ord;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(qut);
        QuotationController testQuote = new QuotationController(sc);
        
        PageReference pageRef = Page.Quotation_Document;
        pageRef.getParameters().put('Id', String.valueOf(qut.Id));
        Test.setCurrentPage(pageRef); 
        testQuote.controllermethod();
        testQuote.getAmtInWords();
       
        
       
        
        
        PageReference pageRef2 = Page.SalesOrderDocumentNew;
        pageRef2.getParameters().put('Id', String.valueOf(ord.Id));
        Test.setCurrentPage(pageRef2); 
        OrderPDFController.saveOrderPDF(ord.Id);
        ApexPages.StandardController orderStand = new ApexPages.StandardController(ord);
        orderPerformaInvoiceController testOrderPerformaInvoice = new orderPerformaInvoiceController(orderStand);
        testOrderPerformaInvoice.metaDataList = bankMetaData;
        testOrderPerformaInvoice.updatingSeries();
        test.stopTest();
    }
    // OrderPDFController Test Class And orderPerformaInvoiceController Test class Start 
    Static testMethod void OrderPDFControllerTest(){
        test.startTest();
        Id oppRecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        Id quoteRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        system.Debug(quoteRecordTypeId);
        
        
        List<Bank_Details__mdt> bankMetaData = [select Beneficiary_Account__c,Branch__c,Bank_API__c,Current_A_C_No__c,Entity_Name__c,IFSC_Code__c,Beneficiary_Bank__c,Beneficiary_Name__c,Swift_code__c from Bank_Details__mdt];
        
        
        Count__c countSetting = New Count__c();
        countSetting.Indian_Customer_Code__c = 10;
        countSetting.N_TEX_Engineering_LastOrderNumber__c = 20;
        insert countSetting; 
        
        VoucherNumberDetail__c vochNum = New VoucherNumberDetail__c();
        vochNum.Name = 'Name';
        vochNum.Financial_Year__c = '2020-21';
        insert vochNum;
        
        Account acc = New Account();
        acc.Name = 'Manras Test';
        acc.Business_domain__c = 'Export';
        Insert acc;
        
        Address__c address = New Address__c();
        address.Name = acc.Name;
        address.Account__c = acc.Id;
        Insert address;
        
        Contact con = New Contact();
        con.LastName = 'Testing Manras';
        con.FirstName = 'Testing Manras';
        con.AccountId = acc.Id;
        insert con;
        
        Opportunity opp = New Opportunity();
        opp.Name = 'HPPL';
        opp.CloseDate = system.today();
        opp.StageName = 'Closed Won';
        //opp.Opportunity_Currency__c = 'INR - Indian Rupee';
        opp.Entity_Name__c = 'N-TEX Engineering Works';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordtypeId;
        Insert opp;
        
        Quote qut = New Quote();
        qut.Entity_Name__c = 'N-TEX Engineering Works';
        qut.Name = 'Testing';
        qut.Subject__c = 'Test Picklist values is pending For Test';
        qut.Delievery_Time__c = '8 To 10 Weeks';
        //qut.Bank__c = 'Bank of Baroda';
        qut.Payment_Term__c = '50% Advance, Balance Against Pro-Forma Invoice, before dispatch of Goods';
        qut.Payment_Mode__c = 'RTGS / NEFT';
        qut.RecordTypeId = quoteRecordTypeId;
        qut.OpportunityId = opp.id;
        qut.PDF_Count__c = 6;
        qut.Packing_Charges__c = 12.30;
        qut.status = 'Draft';
        Insert qut;
        
        
        Quote qutUpdate = [Select Id,status FROM Quote WHERE Id =:qut.Id];
        qutUpdate.status = 'Accepted';
        update qutUpdate;
        
        Order ord = [Select Id,OrderNumber FROM Order WHERE QuoteId = :qutUpdate.Id];
        
        PageReference pageRef = Page.SalesOrderDocumentNew;
        pageRef.getParameters().put('Id', String.valueOf(ord.Id));
        Test.setCurrentPage(pageRef); 
        OrderPDFController.saveOrderPDF(ord.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(ord);
        orderPerformaInvoiceController testOrderPerformaInvoice = new orderPerformaInvoiceController(sc);
        testOrderPerformaInvoice.metaDataList = bankMetaData;
        testOrderPerformaInvoice.getAmtInWords();
        testOrderPerformaInvoice.getBeneficiaryAccount();
        testOrderPerformaInvoice.getBeneficiaryName();
        testOrderPerformaInvoice.getBeneficiarySwiftcode();
        testOrderPerformaInvoice.getbranch();
        testOrderPerformaInvoice.getIFSCCode();
        testOrderPerformaInvoice.getPiNumber(); 
        testOrderPerformaInvoice.updatingSeries();
        testOrderPerformaInvoice.getBeneficiaryBank();
        
        
        PageReference performaInvoice = Page.PerformaInvoice;
        pageRef.getParameters().put('Id', String.valueOf(ord.Id));
        Test.setCurrentPage(performaInvoice); 
        performaInvoiceController performaInvoiceClass = New performaInvoiceController();
        performaInvoiceController.savePdf(ord.Id);
        
        test.stopTest();
        
        // OrderPDFController Test Class And orderPerformaInvoiceController Test class End 
    }
    
    
    // quotePerformaInvoiceController Test class code Start 
    Static testMethod void quotePerformaInvoiceControllerTest(){
        test.startTest();
        Id oppRecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        Id quoteRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        system.Debug(quoteRecordTypeId);
        
        
        List<Bank_Details__mdt> bankMetaData = [select Beneficiary_Account__c,Branch__c,Bank_API__c,Current_A_C_No__c,Entity_Name__c,IFSC_Code__c,Beneficiary_Bank__c,Beneficiary_Name__c,Swift_code__c from Bank_Details__mdt];
        
        
        Count__c countSetting = New Count__c();
        countSetting.Indian_Customer_Code__c = 10;
        countSetting.N_TEX_Engineering_LastOrderNumber__c = 20;
        insert countSetting; 
        
        VoucherNumberDetail__c vochNum = New VoucherNumberDetail__c();
        vochNum.Name = 'Name';
        vochNum.Financial_Year__c = '2020-21';
        insert vochNum;
        
        Account acc = New Account();
        acc.Name = 'Manras Test';
        acc.Business_domain__c = 'Export';
        Insert acc;
        
        Address__c address = New Address__c();
        address.Name = acc.Name;
        address.Account__c = acc.Id;
        Insert address;
        
        Contact con = New Contact();
        con.LastName = 'Testing Manras';
        con.FirstName = 'Testing Manras';
        con.AccountId = acc.Id;
        insert con;
        
        Opportunity opp = New Opportunity();
        opp.Name = 'HPPL';
        opp.CloseDate = system.today();
        opp.StageName = 'Closed Won';
        //opp.Opportunity_Currency__c = 'INR - Indian Rupee';
        opp.Entity_Name__c = 'N-TEX Engineering Works';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordtypeId;
        Insert opp;
        
        Quote qut = New Quote();
        qut.Entity_Name__c = 'N-TEX Engineering Works';
        qut.Name = 'Testing';
        qut.Subject__c = 'Test Picklist values is pending For Test';
        qut.Delievery_Time__c = '8 To 10 Weeks';
        //qut.Bank__c = 'Bank of Baroda';
        qut.Payment_Term__c = '50% Advance, Balance Against Pro-Forma Invoice, before dispatch of Goods';
        qut.Payment_Mode__c = 'RTGS / NEFT';
        qut.RecordTypeId = quoteRecordTypeId;
        qut.OpportunityId = opp.id;
        qut.PDF_Count__c = 6;
        qut.Packing_Charges__c = 12.30;
        qut.status = 'Draft';
        Insert qut;
        
        
        Quote qutUpdate = [Select Id,status FROM Quote WHERE Id =:qut.Id];
        qutUpdate.status = 'Accepted';
        update qutUpdate;
        
        Order ord = [Select Id,OrderNumber FROM Order WHERE QuoteId = :qutUpdate.Id];
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(qutUpdate);
        quotePerformaInvoiceController testQuotePerformaInvoice = new quotePerformaInvoiceController(sc);
        testQuotePerformaInvoice.metaDataList = bankMetaData;
        testQuotePerformaInvoice.getAmtInWords();
        testQuotePerformaInvoice.getPacking_Tranport_InsuranceAMT();
        testQuotePerformaInvoice.getLineTotal();
        testQuotePerformaInvoice.getroundoffValue();
        testQuotePerformaInvoice.getInsuranceLineTotal();
        testQuotePerformaInvoice.getTransportLineTotal();
        testQuotePerformaInvoice.getPackingLineTotal();
        testQuotePerformaInvoice.getTotal_GST_Amount();
        testQuotePerformaInvoice.getTotal_After_Discount();
        testQuotePerformaInvoice.getBeneficiaryAccount();
        testQuotePerformaInvoice.getBeneficiaryName();
        testQuotePerformaInvoice.getBeneficiarySwiftcode();
        testQuotePerformaInvoice.getbranch();
        testQuotePerformaInvoice.getIFSCCode();
        testQuotePerformaInvoice.getBeneficiaryBank();
        test.stopTest();
        
        // quotePerformaInvoiceController Test class End 
    }
    
    // SalesOrderDocumentDetail Test class code Start 
    Static testMethod void SalesOrderDocumentDetailTest(){
        test.startTest();
        Id oppRecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        Id quoteRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        
        
        
        Bank_Details__mdt bankMetaData = [select Beneficiary_Account__c,Branch__c,Bank_API__c,Current_A_C_No__c,Entity_Name__c,IFSC_Code__c,Beneficiary_Bank__c,Beneficiary_Name__c,Swift_code__c from Bank_Details__mdt LIMIT 1];
        
        Count__c countSetting = New Count__c();
        countSetting.Indian_Customer_Code__c = 10;
        countSetting.N_TEX_Engineering_LastOrderNumber__c = 20;
        insert countSetting; 
        
        VoucherNumberDetail__c vochNum = New VoucherNumberDetail__c();
        vochNum.Name = 'Name';
        vochNum.Financial_Year__c = '2020-21';
        insert vochNum;
        
        Account acc = New Account();
        acc.Name = 'Manras Test';
        acc.Business_domain__c = 'Export';
        Insert acc;
        
        Address__c address = New Address__c();
        address.Name = acc.Name;
        address.Account__c = acc.Id;
        Insert address;
        
        Contact con = New Contact();
        con.LastName = 'Testing Manras';
        con.FirstName = 'Testing Manras';
        con.AccountId = acc.Id;
        insert con;
        
        Opportunity opp = New Opportunity();
        opp.Name = 'HPPL';
        opp.CloseDate = system.today();
        opp.StageName = 'Closed Won';
        //opp.Opportunity_Currency__c = 'INR - Indian Rupee';
        opp.Entity_Name__c = 'N-TEX Engineering Works';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordtypeId;
        Insert opp;
        
        Quote qut = New Quote();
        qut.Entity_Name__c = 'N-TEX Engineering Works';
        qut.Name = 'Testing';
        qut.Subject__c = 'Test Picklist values is pending For Test';
        qut.Delievery_Time__c = '8 To 10 Weeks';
        //qut.Bank__c = 'Bank of Baroda';
        qut.Payment_Term__c = '50% Advance, Balance Against Pro-Forma Invoice, before dispatch of Goods';
        qut.Payment_Mode__c = 'RTGS / NEFT';
        qut.RecordTypeId = quoteRecordTypeId;
        qut.OpportunityId = opp.id;
        qut.PDF_Count__c = 6;
        qut.Packing_Charges__c = 12.30;
        qut.status = 'Draft';
        qut.GST_Number_Buyer__c = '24';
        Insert qut;
        
        
        Quote qutUpdate = [Select Id,status FROM Quote WHERE Id =:qut.Id];
        qutUpdate.status = 'Accepted';
        update qutUpdate;
        
        Order ord = [Select Id,OrderNumber,TotalAmount FROM Order WHERE QuoteId = :qutUpdate.Id];
        
        Product2 p = new Product2();
        p.Name = 'Test Product';
        p.Description = 'Test desc';
        p.IsActive = true;
        p.UOM__c = 'Kg';
        insert p;                                    
        
        //standard price book entry for Product p
        PricebookEntry pbe1 = new PricebookEntry();
        pbe1.Pricebook2Id = Test.getStandardPricebookId();
        pbe1.IsActive = true;
        pbe1.Product2Id = p.Id;
        pbe1.UseStandardPrice = false;
        //pbe1.CurrencyISOCode = 'SGD';
        pbe1.UnitPrice = 100; 
        insert pbe1;                      
        
        //custom pricebook
        PriceBook2 pb = new PriceBook2();
        pb.Name = 'Custom PB';
        pb.IsActive = true;            
        insert pb;           
        
        //custom pricebook entry for p1
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = pb.Id;
        pbe.IsActive = true;
        pbe.Product2Id = p.Id;
        pbe.UseStandardPrice = false;
        //pbe.CurrencyISOCode = 'SGD';
        pbe.UnitPrice = 100;                                                       
        insert pbe; 
        
        //update Pricebookentry to use Standard Price
        pbe.UseStandardPrice = true;
        update pbe;
        
        Order od = [ SELECT Id,Pricebook2Id FROM Order WHERE Id=:ord.Id];
        od.Pricebook2Id = pb.Id;
        
        update od;
        
        OrderItem orderItems = New OrderItem();
        orderItems.OrderId = ord.Id;
        orderItems.Description = 'Testing';
        orderItems.UnitPrice = 20;
        orderItems.Quantity = 30;
        orderItems.PricebookEntryId = pbe.Id;
        Insert orderItems;
        
        PageReference pageRef = Page.SalesOrderDocument;
        pageRef.getParameters().put('Id', String.valueOf(ord.Id));
        Test.setCurrentPage(pageRef); 
        
        ApexPages.StandardController salesOrderStandardController = new ApexPages.StandardController(ord);
        SalesOrderDocumentDetail testSalesOrderClass = new SalesOrderDocumentDetail(salesOrderStandardController);
        //system assert methods for SalesOrderDocumentDetail Class
        system.assertEquals(612.30, testSalesOrderClass.totalAmountwithPackingcharge);
        system.assertNotEquals(false,testSalesOrderClass.flag);
        system.assert(testSalesOrderClass.OLIlist.size()>0);
        system.assertEquals(null,testSalesOrderClass.bankdetails,true);
        test.stopTest();
        
        // SalesOrderDocumentDetail Test class code End 
    }
    
    // SalesOrderDocumentDetail Test class code Start 
    Static testMethod void SalesOrderDocumentDetailTest2(){
        test.startTest();
        Id oppRecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        Id quoteRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        
        
        
        Bank_Details__mdt bankMetaData = [select Beneficiary_Account__c,Branch__c,Bank_API__c,Current_A_C_No__c,Entity_Name__c,IFSC_Code__c,Beneficiary_Bank__c,Beneficiary_Name__c,Swift_code__c from Bank_Details__mdt LIMIT 1];
        system.Debug('bankMetaData=====Test'+bankMetaData);
        
        Count__c countSetting = New Count__c();
        countSetting.Indian_Customer_Code__c = 10;
        countSetting.N_TEX_Engineering_LastOrderNumber__c = 20;
        insert countSetting; 
        
        VoucherNumberDetail__c vochNum = New VoucherNumberDetail__c();
        vochNum.Name = 'Name';
        vochNum.Financial_Year__c = '2020-21';
        insert vochNum;
        
        Account acc = New Account();
        acc.Name = 'Manras Test';
        acc.Business_domain__c = 'Export';
        Insert acc;
        
        Address__c address = New Address__c();
        address.Name = acc.Name;
        address.Account__c = acc.Id;
        Insert address;
        
        Contact con = New Contact();
        con.LastName = 'Testing Manras';
        con.FirstName = 'Testing Manras';
        con.AccountId = acc.Id;
        insert con;
        
        Opportunity opp = New Opportunity();
        opp.Name = 'HPPL';
        opp.CloseDate = system.today();
        opp.StageName = 'Closed Won';
        //opp.Opportunity_Currency__c = 'INR - Indian Rupee';
        opp.Entity_Name__c = 'N-TEX Engineering Works';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordtypeId;
        Insert opp;
        
        Quote qut = New Quote();
        qut.Entity_Name__c = 'N-TEX Engineering Works';
        qut.Name = 'Testing';
        qut.Subject__c = 'Test Picklist values is pending For Test';
        qut.Delievery_Time__c = '8 To 10 Weeks';
        //qut.Bank__c = 'Bank of Baroda';
        qut.Payment_Term__c = '50% Advance, Balance Against Pro-Forma Invoice, before dispatch of Goods';
        qut.Payment_Mode__c = 'RTGS / NEFT';
        qut.RecordTypeId = quoteRecordTypeId;
        qut.OpportunityId = opp.id;
        qut.PDF_Count__c = 6;
        qut.Packing_Charges__c = null;
        qut.status = 'Draft';
        qut.GST_Number_Buyer__c = '20';
        system.debug('before qut======'+qut);
        Insert qut;
        
        system.debug('qut======'+qut);
        
        Quote qutUpdate = [Select Id,status FROM Quote WHERE Id =:qut.Id];
        qutUpdate.status = 'Accepted';
        update qutUpdate;
        
        Order ord = [Select Id,AccountId,TotalAmount,OrderNumber FROM Order WHERE QuoteId = :qutUpdate.Id];
        
        PageReference pageRef = Page.SalesOrderDocument;
        pageRef.getParameters().put('Id', String.valueOf(ord.Id));
        Test.setCurrentPage(pageRef); 
        
        ApexPages.StandardController salesOrderStandardController = new ApexPages.StandardController(ord);
        SalesOrderDocumentDetail testSalesOrderClass = new SalesOrderDocumentDetail(salesOrderStandardController);
        
        //system assert methods for SalesOrderDocumentDetail Class
        system.assertEquals(0, ord.TotalAmount);
        system.assertNotEquals(true,testSalesOrderClass.flag);
        system.assert(testSalesOrderClass.OLIlist.size()==0);
        test.stopTest();
        
        // SalesOrderDocumentDetail Test class code End 
    }
    Static testMethod void orderPerformaInvoiceControllerTest(){
        test.startTest();
        Id oppRecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        Id quoteRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        system.Debug(quoteRecordTypeId);
        
        
        List<Bank_Details__mdt> bankMetaData = [select Beneficiary_Account__c,Branch__c,Bank_API__c,Current_A_C_No__c,Entity_Name__c,IFSC_Code__c,Beneficiary_Bank__c,Beneficiary_Name__c,Swift_code__c from Bank_Details__mdt];
        
        
        Count__c countSetting = New Count__c();
        countSetting.Indian_Customer_Code__c = 10;
        countSetting.N_TEX_Engineering_LastOrderNumber__c = 20;
        insert countSetting; 
        
        VoucherNumberDetail__c vochNum = New VoucherNumberDetail__c();
        vochNum.Name = 'Name';
        vochNum.Financial_Year__c = '2020-21';
        insert vochNum;
        
        Account acc = New Account();
        acc.Name = 'Manras Test';
        acc.Business_domain__c = 'Export';
        Insert acc;
        
        Address__c address = New Address__c();
        address.Name = acc.Name;
        address.Account__c = acc.Id;
        Insert address;
        
        Contact con = New Contact();
        con.LastName = 'Testing Manras';
        con.FirstName = 'Testing Manras';
        con.AccountId = acc.Id;
        insert con;
        
        Opportunity opp = New Opportunity();
        opp.Name = 'HPPL';
        opp.CloseDate = system.today();
        opp.StageName = 'Closed Won';
        //opp.Opportunity_Currency__c = 'INR - Indian Rupee';
        opp.Entity_Name__c = 'N-TEX Engineering Works';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordtypeId;
        Insert opp;
        
        Quote qut = New Quote();
        qut.Entity_Name__c = 'N-TEX Engineering Works';
        qut.Name = 'Testing';
        qut.Subject__c = 'Test Picklist values is pending For Test';
        qut.Delievery_Time__c = '8 To 10 Weeks';
        //qut.Bank__c = 'Bank of Baroda';
        qut.Payment_Term__c = '50% Advance, Balance Against Pro-Forma Invoice, before dispatch of Goods';
        qut.Payment_Mode__c = 'RTGS / NEFT';
        qut.RecordTypeId = quoteRecordTypeId;
        qut.OpportunityId = opp.id;
        qut.PDF_Count__c = 6;
        qut.Packing_Charges__c = 12.30;
        qut.status = 'Draft';
        Insert qut;
        
       
        
        Quote qutUpdate = [Select Id,status FROM Quote WHERE Id =:qut.Id];
        qutUpdate.status = 'Accepted';
        update qutUpdate;
        
        Order ord = [Select Id,OrderNumber,Is_Performa_Generate__c,Packing_Charges__c,Final_Value__c,Transport_Charges__c,Total_After_Discount_Hidden__c FROM Order WHERE QuoteId = :qutUpdate.Id];
        ord.Is_Performa_Generate__c = false;
        update ord;
        
        ApexPages.StandardController orderStand = new ApexPages.StandardController(ord);
        orderPerformaInvoiceController testOrderPerformaInvoice = new orderPerformaInvoiceController(orderStand);
        testOrderPerformaInvoice.metaDataList = bankMetaData;
        testOrderPerformaInvoice.updatingSeries();
        testOrderPerformaInvoice.getAmtInWords();
        testOrderPerformaInvoice.updatingSeries();
        testOrderPerformaInvoice.getroundoffValue();
        testOrderPerformaInvoice.getInsuranceLineTotal();
        testOrderPerformaInvoice.getTransportLineTotal();
        testOrderPerformaInvoice.getPackingLineTotal();
        testOrderPerformaInvoice.getTotal_GST_Amount();
        testOrderPerformaInvoice.getBeneficiaryAccount();
        testOrderPerformaInvoice.getBeneficiaryName();
        testOrderPerformaInvoice.getBeneficiarySwiftcode();
        testOrderPerformaInvoice.getbranch();
        testOrderPerformaInvoice.getIFSCCode();
        testOrderPerformaInvoice.getBeneficiaryBank();
        
        test.stopTest();
        
        // orderPerformaInvoiceController Test class End 
    }
}