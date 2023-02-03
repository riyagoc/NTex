@isTest
public with sharing class orderTriggerHandlerTest {
    
    Static testMethod void beforeInsertMethod(){
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
        //qut.Payment_Term__c = 'By LC - 100% along with Irrocavarable L.C., L.C. Tenor - At Sight';
        qut.Payment_Mode__c = 'By Cash';
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
        ord.Payment_Mode__c = 'By Cash';
        ord.OpportunityId = opp.id;
       //ord.RecordTypeId = orderRecordTypeId;
       // ord.QuoteId = qut.id;
        ord.Packing_Charges__c = 100;
        ord.Packing_Type__c = 'Export Sea/Air Worthy Pallatise Packing';
        ord.Packing__c = true;
        ord.Transportation_Charges__c = true;
        ord.Transport_Charges__c = 100;
        ord.FOB__c=true;
        ord.FOB_Charges__c = 100;
        ord.Final_Value__c = 50;
        ord.Insurance__c = true;
        ord.status = 'Draft';
        Insert ord;

        // Advance_Payment__c adv = new Advance_Payment__c();
        // adv.Advance_Amount__c = 100;
        // adv.Advance_Payment_Date__c = System.today();
        // adv.Payment_Mode__c = 'Cash';
        // adv.Order__c = ord.id;
        // insert adv;

        // // Opportunity oppUpdate = [Select Id,StageName,SyncedQuoteId FROM Opportunity WHERE Id =:qut.OpportunityId];
        // // oppUpdate.StageName = 'Close Won';
        // // oppUpdate.SyncedQuoteId = qut.id;
        // // update oppUpdate;

        // // Quote qutUpdate = [Select Id,status,IsSyncing,OpportunityId FROM Quote WHERE OpportunityId =:oppUpdate.Id];
        // // // qutUpdate.IsSyncing = true;
        // // qutUpdate.status = 'Accepted';
        // // update qutUpdate;


        // // Order ord = [Select Id FROM Order WHERE QuoteId = :qutUpdate.Id];
        
        // PageReference pageRef = Page.OrderVerticalPerforma;
        // pageRef.getParameters().put('Id', String.valueOf(ord.Id));
        // Test.setCurrentPage(pageRef); 

        // OrderPDFController.saveOrderPDF(ord.Id);

        // ApexPages.StandardController sc = new ApexPages.StandardController(ord);
        // OrderVerticalController testOrderVerticalInvoice = new OrderVerticalController(sc);
        // testOrderVerticalInvoice.getadvPaymentRecords();
        // testOrderVerticalInvoice.getAmtInWordsForFOB();
        // testOrderVerticalInvoice.getAmtInWordsForCK();
        // testOrderVerticalInvoice.getAmtInWordsForCIF();
        // testOrderVerticalInvoice.getroundoffValue();

        test.stopTest();
        
        /*test.startTest();
        Id oppRecordtypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        Id quoteRecordTypeId = Schema.SObjectType.quote.getRecordTypeInfosByName().get('Domestic').getRecordTypeId();
        system.Debug(quoteRecordTypeId);
        
        
        //List<Bank_Details__mdt> bankMetaData = [select Beneficiary_Account__c,Branch__c,Bank_API__c,Current_A_C_No__c,Entity_Name__c,IFSC_Code__c,Beneficiary_Bank__c,Beneficiary_Name__c,Swift_code__c from Bank_Details__mdt];
        
        
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
        qut.Delievery_Time__c = '8 to 10 Weeks';
        //qut.Bank__c = 'Bank of Baroda';
        qut.Payment_Term__c = '50% Advance, Balance before dispatch of Goods';
        qut.Payment_Mode__c = 'By RTGS / NEFT / TT / IMPS / DD / Cheque';
        qut.RecordTypeId = quoteRecordTypeId;
        qut.OpportunityId = opp.id;
        qut.PDF_Count__c = 6;
        qut.Packing_Charges__c = 12.30;
        qut.status = 'Draft';
        Insert qut;
        
        // Opportunity oppUpdate = [Select Id,StageName,SyncedQuoteId FROM Opportunity WHERE Id =:qut.OpportunityId];
        // oppUpdate.StageName = 'Close Won';
        // oppUpdate.SyncedQuoteId = qut.id;
        // update oppUpdate;
       
        // Quote qutUpdate = [Select Id,IsSyncing,status FROM Quote WHERE Id =:qut.Id];
        // //qutUpdate.IsSyncing = true;
        // qutUpdate.status = 'Accepted';
        // update qutUpdate;
        
        // Order ord = [Select Id,OrderNumber,Is_Performa_Generate__c,Packing_Charges__c,Final_Value__c,Transport_Charges__c,Total_After_Discount_Hidden__c FROM Order WHERE QuoteId = :qutUpdate.Id];
        // ord.Is_Performa_Generate__c = false;
        // update ord;

        Order ord = New Order();
        ord.Entity_Name__c = 'N-TEX Engineering Works';
        ord.Name = 'Testing';
        ord.Expiration_Date__c = System.today();
        ord.AccountId = acc.id;
        ord.EffectiveDate = System.today();
        ord.Delivery_Time__c = '8 to 10 weeks';
        //ord.Payment_Term__c = '50% Advance, Balance before dispatch of Goods';
        ord.Payment_Mode__c = 'By Cash';
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
        
        test.stopTest();*/
    }
}
