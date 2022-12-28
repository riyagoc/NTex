trigger PopulateVoucherNo on Order (after insert,before insert) {
    
    if(trigger.isBefore && trigger.isInsert)
    {
        orderTriggerHandler.beforeInsertMethod(trigger.new);
        
    }

    Set<ID> ordid = new Set<Id>();
    for(Order ord : Trigger.New)
    {
        ordid.add(ord.id);
        
    }
    
     VoucherNumberDetail__c VocherDetail = [Select Name,Financial_Year__c FROM VoucherNumberDetail__c];
     List<Order> ordList = [select Voucher_No__c,OrderNumber from order where id IN : ordid];
     
     for(Order ol : ordList)
     {
         ol.Voucher_No__c =  VocherDetail.Name + '/' + ol.OrderNumber + '/' + VocherDetail.Financial_Year__c;
     }
     update ordList;
}