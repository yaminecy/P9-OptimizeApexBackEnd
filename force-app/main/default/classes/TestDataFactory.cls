@isTest
public with sharing class TestDataFactory{

// This function returns an account and receive in parameters the number of Orders, OrderProduct, Quantity of each orderProduct,the status of each Order, the  Order Shipment Cost and the insert them in the database 
public static Account createOneAccountWithOrdsAndOrdProducts( Integer numOrders, Integer orderShipmentCost, 
Integer numOrderProduct, Integer orderProductQuantity, Integer orderProductPrice,String orderStatus ){
    
    Product2 pd = new Product2(Name = 'ProductTest', Family = 'family', IsActive = true);
    insert pd;

    PricebookEntry pbe = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = pd.Id, UnitPrice = 50000, IsActive = true);
    insert pbe;
    
    Account acct = new Account(Name = 'TestAccount');
    insert acct;
    
    List<Order> ords = new List<Order>();
    for(Integer k = 0; k < numOrders; k ++){
            ords.add(new Order(AccountId = acct.Id, Pricebook2Id = Test.getStandardPricebookId(), Status = orderStatus, ShipmentCost__c = orderShipmentCost, 
            EffectiveDate = System.today()+k));
    }
    insert ords;

    List<OrderItem> ordItems = new List<OrderItem>();
    for (Integer l = 0; l < numOrders; l ++){
        Order o = ords[l];
        for (Integer m = 0; m < numOrderProduct; m ++){
            ordItems.add(new OrderItem(OrderId = o.Id, Product2Id = pd.Id, PriceBookEntryId = pbe.Id, Quantity = orderProductQuantity, 
            UnitPrice = orderProductPrice));
        }
    }
    insert ordItems;
    return acct;
}
// This function returns a multiple accounts and receive in parameters the number of accounts, Orders, OrderProduct, Quantity of each orderProduct, the status of each Order, the  Order Shipment Cost and the insert them in the database 
public static List<Account> createMultipleAccountWithOrdsAndOrdProducts(Integer numAccounts,Integer numOrders,Integer orderShipmentCost, 
Integer numOrderProduct, Integer orderProductQuantity, Integer orderProductPrice,String orderStatus){
    List <Account> accts = new List<Account>();
    for(Integer k = 0;k<numAccounts; k++){
        Account acct = createOneAccountWithOrdsAndOrdProducts(numOrders,orderShipmentCost,numOrderProduct,
                                                orderProductQuantity,orderProductPrice,orderStatus );
        accts.add(acct);
    }                                                                        
    upsert accts;
    return accts;
                                    
}
// This fuction set the Status of a list of Orders received in parameters to Ordered and then insert them into the database  
public static void setOrderStatusToOrdered(List<Order> ods,Integer orderNumber){
    List<Order> ords = new List<Order>();
    for(Integer n=0;n<orderNumber;n++){
        Order od = ods[n];
        od.Status = 'Ordered';
        ords.add(od);
    }
    update ords;
}
}