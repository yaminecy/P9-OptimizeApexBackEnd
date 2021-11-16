@isTest
public with sharing class TestCalculateNetAmountTrigger {

    @isTest
    static void TestCalculateNetAmount(){
    //Create an account with 5 orders having status "Draft",Order shipment =10000  and 5 OrderItem for each Order with UnitPrice=100 and quantity=5
    Account acct = TestDataFactory.createOneAccountWithOrdsAndOrdProducts(1, 10000, 5, 5, 1000,'Draft');
    Test.startTest();
    List<Order> ord = [Select Id, OrderNumber, AccountId, TotalAmount, Status, ShipmentCost__c, NetAmount__c, EffectiveDate
                    from Order
                    where AccountId = :acct.Id];
    TestDataFactory.setOrderStatusToOrdered(ord, 1); //Set Order status to Ordered
    Test.stopTest();
    Order od = [select TotalAmount,NetAmount__c
                from Order
                where AccountId = :acct.Id];
    System.assertEquals(od.NetAmount__c, 15000,'Result should be 15000'); //Verify That the Order Net Amount fied has been correctly calculated 
}
}