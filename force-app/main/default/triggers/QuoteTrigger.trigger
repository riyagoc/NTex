trigger QuoteTrigger on Quote (after insert, before update,before insert,after update) {
public static boolean updateQuote=false;
    if(trigger.isbefore && trigger.isInsert)
    { 
        QuoteTriggerHandler.updatEntityField(trigger.new);
    }
 
    if(trigger.isAfter && trigger.isInsert)
    {
       
        QuoteTriggerHandler.updateAfterinsert(trigger.new);
    }
    // if(trigger.isAfter && trigger.isUpdate){
    //     Set<Id> quoteId=new set<Id>();
    //     for(Quote quo:Trigger.new){
    //         Quote oldQuote = Trigger.oldMap.get(quo.ID);
    //         if(quo.status=='Accepted' && quo.Status != oldQuote.Status && updateQuote==false) {
    //             quoteId.add(quo.id);
    //             updateQuote=true;
    //         }
    //     }
    //     if(!quoteId.isEmpty()){
    //         OrderCreationController.createOrder(quoteId);
    //     }
    // }

}