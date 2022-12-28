public class AccountTriggerHandler {
    
    public static void beforeInsertMethod(List<account> AccList)
    {
        Count__c ct = Count__c.getOrgDefaults();
        
        for(account acc : AccList)
        {
            system.debug('acc.Client_Base__c '+acc.Client_Base__c);
            if(acc.Business_domain__c == 'Domestic')
            {
                string IndianCC = String.valueOf(ct.Indian_Customer_Code__c);
                acc.Customer_Code__c = 'DC - '+ IndianCC.removeEnd('.0');
                ct.Indian_Customer_Code__c = ct.Indian_Customer_Code__c + 1;
            }
            else
            {
                string InternationalCC = String.valueOf(ct.International_Customer_Code__c);
                acc.Customer_Code__c = 'OC - '+InternationalCC.removeEnd('.0');
                ct.International_Customer_Code__c = ct.International_Customer_Code__c + 1;
            }
        }
        
        update ct;
    }
    
    public static void afterInsertMethod(List<account> AccList)
    {
        List<Address__c> adrsList = new List<Address__c>();
        
        for(account acc : AccList)
        {
            Address__c adrs = new Address__c();
            adrs.Account__c = acc.id;
            adrs.Name = acc.BillingStreet;
            adrs.Street__c = acc.BillingStreet;
            adrs.City__c = acc.BillingCity;
            adrs.State_Province__c = acc.BillingState;
            adrs.Country__c = acc.BillingCountry;
            adrs.GST__c = acc.GST_Number__c;
            adrs.Zip_Postal_Code__c  = acc.BillingPostalCode;
            adrsList.add(adrs);
        }
        if(adrsList <> null)
        {
            insert adrsList;
        }
        
    }

}