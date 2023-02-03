public with sharing class QuoteTriggerHandler { 
    
    public static void updatEntityField(List<quote> newQuoteList)
    {
        Count__c ct = Count__c.getOrgDefaults();
        List<id> opportunityIds = new List<id>();
        map<id,opportunity> oppMap = new map<id,opportunity>();

        for(Quote q : newQuoteList)
        {
            opportunityIds.add(q.OpportunityId);
        }
        if(opportunityIds.size() <> 0)
        {
            oppMap = new map<id,opportunity>([select id,Entity_Name__c from opportunity where id in : opportunityIds]);
        }
        for(Quote q : newQuoteList)
        {
            q.Entity_Name__c = oppMap.get(q.OpportunityId).Entity_Name__c;
            System.debug(oppMap.get(q.OpportunityId).Entity_Name__c);
        }
    }
    public static void updateAfterinsert(List<quote> newQuoteList)
    {
        Count__c ct = Count__c.getOrgDefaults();
        list<quote> qtList = new list<quote>();

        for(Quote q : newQuoteList)
        {
            quote qutIns = new quote();
            qutIns.id = q.id;
            if(q.Entity_Name__c == 'N-TEX ENGINEERING WORKS')
            {
                string lastNumNEW = String.valueOf(ct.NTEX_Engineering_LastQuoteNumber__c +1);
                qutIns.Quote_Series_Hidden__c = lastNumNEW.removeEnd('.0');
                ct.NTEX_Engineering_LastQuoteNumber__c = ct.NTEX_Engineering_LastQuoteNumber__c +1;
            }
            if(q.Entity_Name__c == 'N-TEX MACHINERY PRIVATE LIMITED')
            {
                string lastNumNMPL = String.valueOf(ct.N_TEX_Machinery_LastNumber__c +1);
                qutIns.Quote_Series_Hidden__c = lastNumNMPL.removeEnd('.0');
                ct.N_TEX_Machinery_LastNumber__c = ct.N_TEX_Machinery_LastNumber__c +1;
            }
            qtList.add(qutIns);
        }
        update qtList;
        update ct;
    }
}