trigger AccountTrigger on Account (before insert,after insert) {
    
    if(trigger.isinsert )
    {
        if(trigger.isbefore)
        {
             AccountTriggerHandler.beforeInsertMethod(trigger.new);
        }
        if(trigger.isafter)
        {
            AccountTriggerHandler.afterInsertMethod(trigger.new);
        }
       
    }

}