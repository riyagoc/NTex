@isTest
public class QuotationControllerTest {
    
    // Code Coverage for mention below Apex classes in TestMethod is
    // QuotationController and QuotePDFController  (Appex Classes)
    // quotePerformaInvoiceController and QuoteInvoiceController (Apex Classes)
    // OrderPDFController and OrderVerticalController (Apex Classes)
    // orderPerfromaInvoiceController and PerfomaInvoiceController (Apex Classes)
    // SalesOrderDocumentDetail and PurchaseOrderController (Apex Classes)
    // AccountTrigger (Apex Trigger) and AccountTriggerHandler (Apex Class )
    //QuoteTrigger (Apex Trigger) and QuoteTriggerHandler (Apex Class )
    
    //QuotePDFController and QuotationController test Class Strat
    Static testMethod void QuotationControllerDoinit(){
        test.startTest();
        Id oppRecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('International').getRecordTypeId();
        Id quoteRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Export').getRecordTypeId();
        system.debug('quoteRecordTypeId==='+quoteRecordTypeId);
        system.debug('oppRecordtypeId==='+oppRecordtypeId);
        //List<Bank_Details__mdt> bankMetaData = [select Beneficiary_Account__c,Bank_API__c,Current_A_C_No__c,Entity_Name__c,IFSC_Code__c,Beneficiary_Bank__c,Beneficiary_Name__c,Swift_code__c from Bank_Details__mdt];
        
        Count__c countSetting = New Count__c();
        countSetting.Indian_Customer_Code__c = 10;
        countSetting.N_TEX_Engineering_LastOrderNumber__c = 20;
        insert countSetting;
        
        // VoucherNumberDetail__c vochNum = New VoucherNumberDetail__c();
        // vochNum.Name = 'Name';
        // vochNum.Financial_Year__c = '2022-23';
        // insert vochNum;
        
        Account acc = New Account();
        acc.Name = 'GOC Test';
        acc.Business_domain__c = 'Export';
        //acc.CurrencyIsoCode ='USD - U.S. Dollar';
        Insert acc;
        
        Address__c address = New Address__c();
        address.Name = 'account address';
        address.Account__c = acc.Id;
        Insert address;
        
        Contact con = New Contact();
        con.LastName = 'Testing GOC';
        con.FirstName = 'Testing GOC';
        con.AccountId = acc.Id;
        insert con;
        
        Opportunity opp = New Opportunity();
        opp.Name = 'GOC';
        opp.CloseDate = system.today();
        opp.StageName = 'Qualification';
        opp.Entity_Name__c = 'N-TEX Engineering Works';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordtypeId;
        Insert opp;
        System.debug('opp==='+opp);
        
        Quote qut = New Quote();
        qut.Entity_Name__c = 'N-TEX Engineering Works';
        qut.Name = 'Testing';
        // qut.Subject__c = 'Test Picklist values is pending For Test';
        qut.Delievery_Time__c = '8 to 10 weeks';
       // qut.Bank__c = 'Bank of Baroda';
        qut.Packing_Type__c = 'Export Sea/Air Worthy Pallatise Packing';
        qut.Payment_Term__c = 'By LC - 100% along with Irrocavarable L.C., L.C. Tenor - At Sight';
       // qut.Payment_Mode__c = 'By Cash';
        qut.ExpirationDate = System.today();
        qut.RecordTypeId = quoteRecordTypeId;
        qut.OpportunityId = opp.id;
        qut.Packing__c = true;
        qut.Packing_Charges__c = 10000.30;
        qut.FOB__c=true;
        qut.FOB_Charges__c = 5000.20;
        qut.Transportation_Charges__c = true;
        qut.Transport_Charges__c = 10000;
        qut.Insurance__c = true;
        qut.Final_Value__c = 50000;
        qut.status = 'Draft';
        Insert qut;
        
        system.debug('Test quote debug======'+qut);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(qut);
        QuotationController testQuote = new QuotationController(sc);
        
        PageReference pageRef = Page.QuoteVerticalPerforma;
        pageRef.getParameters().put('Id', String.valueOf(qut.Id));
        Test.setCurrentPage(pageRef); 
        testQuote.controllermethod();
        
        testQuote.getAmtInWordsForCIF();
        testQuote.getAmtInWordsForCK();
        testQuote.getAmtInWordsForFOB();
        testQuote.getroundoffValue();
        
        // QuotePDFController Test class code Start
        
        PageReference quotePdfPageref = Page.QuoteVerticalPerforma;
        pageRef.getParameters().put('Id', String.valueOf(qut.Id));
        Test.setCurrentPage(quotePdfPageref); 
        QuotePDFController.savePdf(qut.Id);
        
        
        test.stopTest();
        //QuotePDFController and QuotationController Test Class End
    }
    
    //getAmtInWordsMethod to pass getAmtInWords metohd of QuotationController Apex class and NumberTOWordConvertion Apex class 
    // quotePerformaInvoiceController and QuoteInvoiceController Test class code Start 
    Static testMethod void quotePerformaInvoiceControllerTest(){
        test.startTest();
        Id oppRecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        Id quoteRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        System.Debug('quote controller recordtypeid'+quoteRecordTypeId);
        System.Debug('opp controller recordtypeid'+oppRecordtypeId);

        
        Count__c countSetting = New Count__c();
        countSetting.Indian_Customer_Code__c = 10;
        countSetting.N_TEX_Engineering_LastOrderNumber__c = 20.00;
        insert countSetting; 
        System.debug('quoteController count--'+countSetting);

        // VoucherNumberDetail__c vochNum = New VoucherNumberDetail__c();
        // vochNum.Name = 'Name';
        // vochNum.Financial_Year__c = '2022-23';
        // insert vochNum;
        
        Account acc = New Account();
        acc.Name = 'GOC Test';
        acc.Business_domain__c = 'Domestic';
        Insert acc;
        System.debug('acc--'+acc);
        
        Address__c address = New Address__c();
        address.Name = acc.Name;
        address.Account__c = acc.Id;
        Insert address;
        System.debug('address--'+address);
        
        Contact con = New Contact();
        con.LastName = 'Testing GOC';
        con.FirstName = 'Testing GOC';
        con.AccountId = acc.Id;
        insert con;
        System.debug('contact--'+con);
        
        Opportunity opp = New Opportunity();
        opp.Name = 'HPPL';
        opp.CloseDate = system.today();
        opp.StageName = 'Closed Won';
        opp.Entity_Name__c = 'N-TEX Engineering Works';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordtypeId;
        Insert opp;
        System.debug('opp--'+opp);
        
        Quote qut = New Quote();
        qut.Entity_Name__c = 'N-TEX Engineering Works';
        qut.Name = 'Testing';
        qut.Subject__c = 'Test Picklist values is pending For Test';
        qut.Delievery_Time__c = '8 to 10 weeks';
        //qut.Bank__c = 'Bank of Baroda';
        qut.Payment_Term__c = '50% Advance, Balance before dispatch of Goods';
        //qut.Payment_Mode__c = 'By RTGS / NEFT / TT / IMPS / DD / Cheque';
        qut.ExpirationDate = System.today();
        qut.RecordTypeId = quoteRecordTypeId;
        qut.OpportunityId = opp.id;
        //qut.PDF_Count__c = 6;
        qut.status = 'Draft';
        qut.Packing_Type__c = 'Crate Packing';
        qut.Packing_Charges__c = 100000;
        qut.Packing__c = true;
        qut.Transportation_Charges__c = true;
        qut.Transport_Charges__c = 10000;
        qut.Final_Value__c = 50000;
        qut.Insurance__c = true;
        qut.Transport_GST__c = '5';
        qut.Insurance_GST__c = '5';
        Insert qut;
        System.debug('quote--'+qut);

       /* Product2 p = new Product2();
        p.Name = 'Test Product';
        p.Description = 'Test desc';
        p.IsActive = true;
        p.UOM__c = 'Kg';
        insert p;                                    
        System.debug('product--'+p);
        
        //standard price book entry for Product p
        PricebookEntry pbe1 = new PricebookEntry();
        pbe1.Pricebook2Id = Test.getStandardPricebookId();
        pbe1.IsActive = true;
        pbe1.Product2Id = p.Id;
        pbe1.UseStandardPrice = false;
        //pbe1.CurrencyISOCode = 'INR - Indian Rupee';
        pbe1.UnitPrice = 100; 
        insert pbe1;                      
        System.debug('pricebookEntry--'+pbe1);
        
        //custom pricebook
        PriceBook2 pb = new PriceBook2();
        pb.Name = 'Custom PB';
        pb.IsActive = true;            
        insert pb;           
        System.debug('PriceBook2--'+pb);
        
        //custom pricebook entry for p1
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id = pb.Id;
        pbe.IsActive = true;
        pbe.Product2Id = p.Id;
        pbe.UseStandardPrice = false;
        //pbe.CurrencyISOCode = 'INR - Indian Rupee';
        pbe.UnitPrice = 100;                                                       
        insert pbe; 
        System.debug('PriceBookENtry ---'+pbe);

        //update Pricebookentry to use Standard Price
        pbe.UseStandardPrice = true;
        update pbe;
        // quote q = [ SELECT Id,Pricebook2Id FROM Quote WHERE Id=:qut.Id];
        // q.Pricebook2Id = pb.Id;
        // update q;
        
        QuoteLineItem quoteLineItem = New QuoteLineItem();
        quoteLineItem.QuoteId = qut.Id;
        quoteLineItem.Product2Id = p.id;
        quoteLineItem.Description = 'Testing';
        quoteLineItem.UnitPrice = 100;
        quoteLineItem.Quantity = 2;
        quoteLineItem.Performa_GST__c = '5';
        quoteLineItem.Performa_Discount_Amount__c = 10;
        quoteLineItem.PricebookEntryId = pbe.Id;
        Insert quoteLineItem;
        System.debug('quoteline item--'+quoteLineItem);*/

        ApexPages.StandardController sc = new ApexPages.StandardController(qut);
        quotePerformaInvoiceController testQuotePerformaInvoice = new quotePerformaInvoiceController(sc);

        PageReference pageRef = Page.quotePerformaInvoice;
        pageRef.getParameters().put('Id', String.valueOf(qut.Id));
        Test.setCurrentPage(pageRef); 

        testQuotePerformaInvoice.controllermethod();
        testQuotePerformaInvoice.getAmtInWords();
        testQuotePerformaInvoice.getPacking_Tranport_InsuranceAMT();
        testQuotePerformaInvoice.getLineTotal();
        testQuotePerformaInvoice.getLine_Item_Total_Amount();
        testQuotePerformaInvoice.getroundoffValue();
        testQuotePerformaInvoice.getInsuranceLineTotal();
        testQuotePerformaInvoice.getTransportLineTotal();
        testQuotePerformaInvoice.getPackingLineTotal();
        testQuotePerformaInvoice.getTotal_GST_Amount();
        testQuotePerformaInvoice.getTotal_After_Discount();
        

        // QuoteInvoiceController Test class code Start
        
        PageReference quoteInvoicePageref = Page.quotePerformaInvoice;
        pageRef.getParameters().put('Id', String.valueOf(qut.Id));
        Test.setCurrentPage(quoteInvoicePageref); 
        QuoteInvoiceController.savePdf(qut.Id);
        
        test.stopTest();
        
        // quotePerformaInvoiceController and QuoteInvoiceController Test class End 
    }
    
    // OrderPDFController  And OrderVerticalController Test class Start 
    Static testMethod void OrderPDFControllerTest(){
        test.startTest();
        Id oppRecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('International').getRecordTypeId();
        Id quoteRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Export').getRecordTypeId();
        Id orderRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Export').getRecordTypeId();
        System.Debug('quote record type order--'+quoteRecordTypeId);
        System.Debug('order record type order'+quoteRecordTypeId);
       
        Count__c countSetting = New Count__c();
        countSetting.Indian_Customer_Code__c = 10;
        countSetting.N_TEX_Engineering_LastOrderNumber__c = 20.00;
        insert countSetting; 
        
        VoucherNumberDetail__c vochNum = New VoucherNumberDetail__c();
        vochNum.Name = 'Name';
        vochNum.Financial_Year__c = '2022-23';
        insert vochNum;
        
        Account acc = New Account();
        acc.Name = 'GOC Test';
        acc.Business_domain__c = 'Export';
        Insert acc;
        
        Address__c address = New Address__c();
        address.Name = acc.Name;
        address.Account__c = acc.Id;
        Insert address;
        
        Contact con = New Contact();
        con.LastName = 'Testing GOC';
        con.FirstName = 'Testing GOC';
        con.AccountId = acc.Id;
        insert con;
        
        Opportunity opp = New Opportunity();
        opp.Name = 'HPPL';
        opp.CloseDate = system.today();
        opp.StageName = 'Qulification';
        //opp.Opportunity_Currency__c = 'INR - Indian Rupee';
        opp.Entity_Name__c = 'N-TEX Engineering Works';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordtypeId;
        Insert opp;
        
        Quote qut = New Quote();
        qut.Entity_Name__c = 'N-TEX Engineering Works';
        qut.Name = 'Testing';
        qut.Delievery_Time__c = '8 to 10 weeks';
        qut.Payment_Term__c = 'By LC - 100% along with Irrocavarable L.C., L.C. Tenor - At Sight';
        //qut.Payment_Mode__c = 'By Cash';
        qut.RecordTypeId = quoteRecordTypeId;
        qut.ExpirationDate = System.today();
        qut.OpportunityId = opp.id;
        qut.Packing_Type__c = 'Export Sea/Air Worthy Pallatise Packing';
        qut.Packing_Charges__c = 100;
        qut.Packing__c = true;
        qut.Transportation_Charges__c = true;
        qut.Transport_Charges__c = 100;
        qut.FOB__c=true;
        qut.FOB_Charges__c = 100;
        qut.Final_Value__c = 50;
        qut.Insurance__c = true;
        qut.status = 'Draft';
        Insert qut;

        Order ord = New Order();
        ord.Entity_Name__c = 'N-TEX Engineering Works';
        ord.Name = 'Testing';
        ord.Expiration_Date__c = System.today()+1;
        ord.AccountId = acc.id;
        ord.EffectiveDate = System.today();
        ord.Delivery_Time__c = '8 to 10 weeks';
        ord.Delivery_Date__c = System.today()+2;
        //ord.Payment_Term__c = 'By LC - 100% along with Irrocavarable L.C., L.C. Tenor - At Sight';
       // ord.Payment_Mode__c = 'By Cash';
        ord.OpportunityId = opp.id;
       //ord.RecordTypeId = orderRecordTypeId;
       // ord.QuoteId = qut.id;
        ord.Packing_Charges__c = 100;
        //ord.Packing_Type__c = 'Export Sea/Air Worthy Pallatise Packing';
        ord.Packing__c = true;
        ord.Transportation_Charges__c = true;
        ord.Transport_Charges__c = 100;
        ord.FOB__c=true;
        ord.FOB_Charges__c = 100;
        ord.Final_Value__c = 50;
        ord.Insurance__c = true;
        ord.status = 'Draft';
        Insert ord;

        Advance_Payment__c adv = new Advance_Payment__c();
        adv.Advance_Amount__c = 100;
        adv.Advance_Payment_Date__c = System.today();
       // adv.Payment_Mode__c = 'Cash';
        adv.Order__c = ord.id;
        insert adv;

        // Opportunity oppUpdate = [Select Id,StageName,SyncedQuoteId FROM Opportunity WHERE Id =:qut.OpportunityId];
        // oppUpdate.StageName = 'Close Won';
        // oppUpdate.SyncedQuoteId = qut.id;
        // update oppUpdate;

        // Quote qutUpdate = [Select Id,status,IsSyncing,OpportunityId FROM Quote WHERE OpportunityId =:oppUpdate.Id];
        // // qutUpdate.IsSyncing = true;
        // qutUpdate.status = 'Accepted';
        // update qutUpdate;


        // Order ord = [Select Id FROM Order WHERE QuoteId = :qutUpdate.Id];
        
        PageReference pageRef = Page.OrderVerticalPerforma;
        pageRef.getParameters().put('Id', String.valueOf(ord.Id));
        Test.setCurrentPage(pageRef); 

        OrderPDFController.saveOrderPDF(ord.Id);

        ApexPages.StandardController sc = new ApexPages.StandardController(ord);
        OrderVerticalController testOrderVerticalInvoice = new OrderVerticalController(sc);
        testOrderVerticalInvoice.getadvPaymentRecords();
        testOrderVerticalInvoice.getAmtInWordsForFOB();
        testOrderVerticalInvoice.getAmtInWordsForCK();
        testOrderVerticalInvoice.getAmtInWordsForCIF();
        testOrderVerticalInvoice.getroundoffValue();

        test.stopTest();
        
        // OrderPDFController And OrderVerticalController Test class End 
    }

    //orderPerfromaInvoiceController and PerfomaInvoiceController Test Class Start
    Static testMethod void orderPerformaInvoiceControllerTest(){
        test.startTest();
        Id oppRecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        Id quoteRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        Id orderRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();

        system.Debug(quoteRecordTypeId);
      
        Count__c countSetting = New Count__c();
        countSetting.Indian_Customer_Code__c = 10;
        countSetting.N_TEX_Engineering_LastOrderNumber__c = 20.00;
        insert countSetting; 
        
        VoucherNumberDetail__c vochNum = New VoucherNumberDetail__c();
        vochNum.Name = 'Name';
        vochNum.Financial_Year__c = '2022-23';
        insert vochNum;
        
        Account acc = New Account();
        acc.Name = 'GOC Test';
        acc.Business_domain__c = 'Export';
        //acc.CurrencyIsoCode ='INR - Indian Rupee';
        Insert acc;
        
        Address__c address = New Address__c();
        address.Name = acc.Name;
        address.Account__c = acc.Id;
        Insert address;
        
        Contact con = New Contact();
        con.LastName = 'Testing GOC';
        con.FirstName = 'Testing GOC';
        con.AccountId = acc.Id;
        insert con;
        
        Opportunity opp = New Opportunity();
        opp.Name = 'HPPL';
        opp.CloseDate = System.today();
        opp.StageName = 'Qulification';
        //opp.Opportunity_Currency__c = 'INR - Indian Rupee';
        opp.Entity_Name__c = 'N-TEX Engineering Works';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordtypeId;
        Insert opp;
        
        Quote qut = New Quote();
        qut.Entity_Name__c = 'N-TEX Engineering Works';
        qut.Name = 'Testing';
        qut.Delievery_Time__c = '8 to 10 weeks';
        //qut.Bank__c = 'Bank of Baroda';
        qut.Payment_Term__c = '50% Advance, Balance before dispatch of Goods';
        qut.ExpirationDate = System.today();
        //qut.Payment_Mode__c = 'By Cash';
        qut.RecordTypeId = quoteRecordTypeId;
        qut.OpportunityId = opp.id;
       // qut.PDF_Count__c = 6;     
        qut.Packing_Type__c = 'Crate Packing';
        qut.Packing_Charges__c = 1000;
        qut.Packing__c = true;
        qut.Transportation_Charges__c = true;
        qut.Transport_Charges__c = 1000;
        qut.Final_Value__c = 500;
        qut.Insurance__c = true;
        Insert qut;
        
       
        Order ord = New Order();
        ord.Entity_Name__c = 'N-TEX Engineering Works';
        ord.Name = 'Testing';
        ord.Expiration_Date__c = System.today()+1;
        ord.AccountId = acc.id;
        ord.EffectiveDate = System.today();
        ord.Delivery_Time__c = '8 to 10 weeks';
        //ord.Payment_Term__c = '50% Advance, Balance before dispatch of Goods';
        //ord.Payment_Mode__c = 'By Cash';
        //ord.RecordTypeId = orderRecordTypeId;
        //ord.OpportunityId = opp.id;
        ord.QuoteId = qut.id;
        ord.Packing_Charges__c = 1000;
        //ord.Packing_Type__c = 'Crate Packing';
        ord.Packing__c = true;
        ord.Transportation_Charges__c = true;
        ord.Transport_Charges__c = 1000;
        ord.Final_Value__c = 500;
        ord.Insurance__c = true;
        ord.status = 'Draft';
        Insert ord;

        Advance_Payment__c adv = new Advance_Payment__c();
        adv.Advance_Amount__c = 1000;
        adv.Advance_Payment_Date__c = System.today();
        //adv.Payment_Mode__c = 'Cash';
        adv.Order__c = ord.id;
        insert adv;

        // Opportunity oppUpdate = [Select Id,StageName,SyncedQuoteId FROM Opportunity WHERE Id =:qut.OpportunityId];
        // oppUpdate.StageName = 'Close Won';
        // oppUpdate.SyncedQuoteId = qut.id;
        // update oppUpdate;

        // Quote qutUpdate = [Select Id,status,IsSyncing,OpportunityId FROM Quote WHERE OpportunityId =:oppUpdate.Id];
        // // qutUpdate.IsSyncing = true;
        // qutUpdate.status = 'Accepted';
        // update qutUpdate;

        
        // Order ord = [Select Id,OrderNumber,Is_Performa_Generate__c,Total_Gst_Amount_Hidden__c,Packing_Charges__c,Final_Value__c,Transport_Charges__c,Total_After_Discount_Hidden__c,Insurance1__c FROM Order WHERE QuoteId = :qutUpdate.Id];
        

        PageReference pageRef = Page.PerformaInvoice;
        pageRef.getParameters().put('Id', String.valueOf(ord.Id));
        Test.setCurrentPage(pageRef); 
        
        performaInvoiceController.savePdf(ord.Id);
        
        ApexPages.StandardController orderStand = new ApexPages.StandardController(ord);
        orderPerformaInvoiceController testOrderPerformaInvoice = new orderPerformaInvoiceController(orderStand);


        testOrderPerformaInvoice.getadvPaymentRecords();
        testOrderPerformaInvoice.getPackingLineTotal();
        testOrderPerformaInvoice.getInsuranceLineTotal();
        testOrderPerformaInvoice.getTransportLineTotal();
        testOrderPerformaInvoice.getTotal_After_Discount();
        testOrderPerformaInvoice.getTotal_GST_Amount();
        testOrderPerformaInvoice.getAmtInWords();
        testOrderPerformaInvoice.getLine_Item_Total_Amount();
        testOrderPerformaInvoice.getroundoffValue();
        //testOrderPerformaInvoice.updatingSeries();
       
        test.stopTest();
        
        //orderPerfromaInvoiceController and PerfomaInvoiceController Test Class Start
    }
    
    
    // SalesOrderDocumentDetail And PurchaseOrderController Test class code Start 
    Static testMethod void SalesOrderDocumentDetailTest(){
        test.startTest();
        Id oppRecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        Id quoteRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        Id orderRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
         
        Count__c countSetting = New Count__c();
        countSetting.Indian_Customer_Code__c = 10;
        countSetting.N_TEX_Engineering_LastOrderNumber__c = 20.00;
        insert countSetting; 
        
        VoucherNumberDetail__c vochNum = New VoucherNumberDetail__c();
        vochNum.Name = 'Name';
        vochNum.Financial_Year__c = '2022-23';
        insert vochNum;
        
        Account acc = New Account();
        acc.Name = 'GOC Test';
        acc.Business_domain__c = 'Export';
        Insert acc;
        
        Address__c address = New Address__c();
        address.Name = acc.Name;
        address.Account__c = acc.Id;
        Insert address;
        
        Contact con = New Contact();
        con.LastName = 'Testing GOC';
        con.FirstName = 'Testing GOC';
        con.AccountId = acc.Id;
        insert con;
        
        Opportunity opp = New Opportunity();
        opp.Name = 'HPPL';
        opp.CloseDate = system.today();
        opp.StageName = 'Qulification';
        opp.Entity_Name__c = 'N-TEX Engineering Works';
        opp.AccountId = acc.id;
        opp.RecordTypeId = oppRecordtypeId;
        Insert opp;
        
        Quote qut = New Quote();
        qut.Entity_Name__c = 'N-TEX Engineering Works';
        qut.Name = 'Testing';
         qut.Delievery_Time__c = '8 to 10 weeks';
        //qut.Bank__c = 'Bank of Baroda';
        qut.Payment_Term__c = '50% Advance, Balance before dispatch of Goods';
       // qut.Payment_Mode__c = 'By Cash';
        qut.RecordTypeId = quoteRecordTypeId;
        qut.OpportunityId = opp.id;
        // qut.PDF_Count__c = 6;     
         qut.Packing_Type__c = 'Crate Packing';
         qut.Packing_Charges__c = 1000;
         qut.Packing__c = true;
         qut.Transportation_Charges__c = true;
         qut.Transport_Charges__c = 1000;
         qut.Final_Value__c = 500;
         qut.Insurance__c = true;
        Insert qut;
        
       
        Order ord = New Order();
        ord.Entity_Name__c = 'N-TEX Engineering Works';
        ord.Name = 'Testing';
        ord.Expiration_Date__c = System.today();
        ord.AccountId = acc.id;
        ord.EffectiveDate = System.today();
        ord.Delivery_Time__c = '8 to 10 weeks';
        //ord.Payment_Term__c = '50% Advance, Balance before dispatch of Goods';
        //ord.Payment_Mode__c = 'By Cash';
        //ord.RecordTypeId = orderRecordTypeId;
        //ord.OpportunityId = opp.id;
        ord.QuoteId = qut.id;
        ord.Packing_Charges__c = 1000;
        //ord.Packing_Type__c = 'Crate Packing';
        ord.Packing__c = true;
        ord.Transportation_Charges__c = true;
        ord.Transport_Charges__c = 1000;
        ord.Final_Value__c = 50;
        ord.Insurance__c = true;
        ord.status = 'Draft';
        Insert ord;

        // Opportunity oppUpdate = [Select Id,StageName,SyncedQuoteId FROM Opportunity WHERE Id =:qut.OpportunityId];
        // oppUpdate.StageName = 'Close Won';
        // oppUpdate.SyncedQuoteId = qut.id;
        // update oppUpdate;

        // Quote qutUpdate = [Select Id,status,IsSyncing,OpportunityId FROM Quote WHERE OpportunityId =:oppUpdate.Id];
        // // qutUpdate.IsSyncing = true;
        // qutUpdate.status = 'Accepted';
        // update qutUpdate;

        // Order ord = [Select Id,OrderNumber,TotalAmount FROM Order WHERE QuoteId = :qutUpdate.Id];
        
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
        pbe1.UnitPrice = 1000; 
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
        pbe.UnitPrice = 1000;                                                       
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
        orderItems.UnitPrice = 200;
        orderItems.Quantity = 3;
        orderItems.PricebookEntryId = pbe.Id;
        Insert orderItems;
        
        PageReference pageRef = Page.SalesOrderDocumentNew;
        pageRef.getParameters().put('Id', String.valueOf(ord.Id));
        Test.setCurrentPage(pageRef); 

        PurchaseOrderController.saveOrderPDF(ord.Id);
        
        ApexPages.StandardController salesOrderStandardController = new ApexPages.StandardController(ord);
        SalesOrderDocumentDetail testSalesOrderClass = new SalesOrderDocumentDetail(salesOrderStandardController);
        system.assert(testSalesOrderClass.OLIlist.size()>0);
        test.stopTest();
        
        // SalesOrderDocumentDetail And PurchaseOrderController Test class code End 
    }
    
}