public class OrderCreationController {
  
    public static void createOrder(Set<Id> QuoteId){
        List<Quote> quoList=[SELECT Agent__c, Bank__c, Billing_Address__c, Calculated_values__c, City__c, Country__c,
                             Created_Date__c, Delievery_Time__c, Entity_Name__c, FOB_Charges__c,
                             FOB__c, Final_Value__c, GST_Number_Buyer__c, GST_Number_Consignee__c,
                             GST__c, Insurance1__c, Insurance__c, PDF_Count__c, Packing_Charges__c, Packing_Type__c, Packing__c,
                             Payment_Mode__c, Payment_Term__c, Place_of_Supply__c, Quote_Currency__c, Quote_Number__c,
                             Quote_Series_Hidden__c, Same_as_Billing_address__c, Select_Account_For_Related_Address__c,
                             Shipping_Address__c, Shipping_City__c, Shipping_Country__c, Shipping_State_Province__c,
                             Shipping_Street__c, Shipping_Zip_Postal_Code__c, State_Province__c, Street__c, Subject__c,
                             Total_CIF__c, Total_C_K__c, Total_FOB__c, Total_GST__c, Total_OF_All__c, Transport_Charges__c,
                             Transport_To__c, Transportation_Charges__c, Type__c, Zip_Postal_Code__c, Record_Type__c,
                             GST_Number_Consignee_1__c, CIN__c, AccountId, Status, Name, Id, OpportunityId, Pricebook2Id,
                             ExpirationDate,CurrencyIsoCode, Jurisdiction_City__c,Price_Validity_Till__c FROM Quote where Id IN:QuoteId];
        List<Order> orderList=new List<Order>();
        Map<Id,Id> orderIdMap=new Map<Id,ID>();
        for(Quote quo:quoList){
            Order ord=new Order();
            ord.Name=quo.Name;
            ord.OpportunityId=quo.OpportunityId;
            ord.AccountId=quo.AccountId;
            ord.Pricebook2Id=quo.Pricebook2Id;
            ord.QuoteId=quo.id;
            ord.EffectiveDate=date.today();
            ord.Status='Draft';
            ord.Bank__c=quo.Bank__c;
            ord.Entity_Name__c = quo.Entity_Name__c;
            ord.Billing_Address__c=quo.Billing_Address__c;
            ord.Expiration_Date__c=quo.ExpirationDate;
            ord.Packing_Charges__c=quo.Packing_Charges__c;
            ord.Packing_Type__c=quo.Packing_Type__c;
            ord.Packing__c=quo.Packing__c;
            ord.Payment_Mode__c=quo.Payment_Mode__c;
            ord.Payment_Term__c=quo.Payment_Term__c;
            ord.Shipping_Address__c=quo.Shipping_Address__c;
            ord.Transport_Charges__c=quo.Transport_Charges__c;
            ord.Transport_To__c=quo.Transport_To__c;
            ord.Transportation_Charges__c=quo.Transportation_Charges__c;
            ord.Place_of_Supply__c = quo.Place_of_Supply__c;
            ord.CurrencyIsoCode=quo.CurrencyIsoCode;
            ord.Price_Validity_Till__c=quo.Price_Validity_Till__c;
            orderList.add(ord);
        }
        if(!orderList.isempty()){
            insert orderList;
            
        }
        for(Order ord:orderList){
            orderIdMap.put(ord.QuoteId,ord.id);
        }
        List<QuoteLineItem> quoItemList=[SELECT Id,CurrencyIsoCode,Description, Performa_GST__c, Performa_Discount_Amount__c,OpportunityLineItemId,PricebookEntryId, Quantity, UnitPrice, Discount, Product2Id, ListPrice, QuoteId FROM QuoteLineItem where QuoteId In:QuoteId];
        List<OrderItem> orderItemList=new List<OrderItem>();
        for(QuoteLineItem quo:quoItemList){
            OrderItem ord=new OrderItem();
            ord.OrderId=orderIdMap.get(quo.QuoteId);
            ord.UnitPrice=quo.UnitPrice;
            ord.Quantity=quo.Quantity;
            ord.ListPrice=quo.ListPrice;
            ord.PricebookEntryId=quo.PricebookEntryId;
            ord.Product2Id=quo.Product2Id;
            ord.Description=quo.Description;
            ord.Performa_GST__c=quo.Performa_GST__c;
            ord.Performa_Discount_Amount__c=quo.Performa_Discount_Amount__c;
            //ord.CurrencyIsoCode=quo.CurrencyIsoCode;
            orderItemList.add(ord);
            
        }
        if(!orderItemList.isEmpty()){
            insert orderItemList;
        }
    }

}