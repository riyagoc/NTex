public with sharing class orderTriggerHandler {
   // public orderTriggerHandler() {}

    public static void beforeInsertMethod(List<order> orderList)
    {
        Count__c ct = Count__c.getOrgDefaults();

        List<id> quoteids = new List<id>();
        map<id,quote> quoMap = new map<id,quote>();
        for(order ord : orderList)
        {
            quoteids.add(ord.QuoteId);
        }
        
        if(quoteids.size() <> 0)
        {
            quoMap = new map<id,quote>([select id ,Entity_Name__c,Billing_Address__c,Shipping_Address__c from Quote where id in: quoteids]);
            
        }
        for(order ord : orderList)
        {
            
            if(quoMap.get(ord.QuoteId).Entity_Name__c == 'N-TEX Engineering Works')
            {
                String lastNumNEW = String.valueOf(ct.N_TEX_Engineering_LastOrderNumber__c +1);
                ord.Order_Series_Hidden__c = lastNumNEW.removeEnd('.0');
                ct.N_TEX_Engineering_LastOrderNumber__c = ct.N_TEX_Engineering_LastOrderNumber__c +1;
            }
            if(quoMap.get(ord.QuoteId).Entity_Name__c == 'N-TEX Machinery Private Limited')
            {
              //  System.debug(quoMap.get(ord.QuoteId).Entity_Name__c);
                String lastNumNMPL = String.valueOf(ct.N_TEX_Machinery_LastOrderNumber__c +1);
                ord.Order_Series_Hidden__c = lastNumNMPL.removeEnd('.0');
                ct.N_TEX_Machinery_LastOrderNumber__c = ct.N_TEX_Machinery_LastOrderNumber__c +1;
            } 
            
            if(ord.Billing_Address__c == null)
            {
                ord.Billing_Address__c = quoMap.get(ord.QuoteId).Billing_Address__c;
                
            }
            
            if(ord.Shipping_Address__c == null)
            {
                ord.Shipping_Address__c = quoMap.get(ord.QuoteId).Shipping_Address__c;
            }
        
        }
        update ct;
    }
}