@isTest
public with sharing class TestCalculateNetAmountTrigger {

@isTest
static void testCalculateNetAmountTrigger() {
    // create an account with an order 
    Account acct = TestDataFactory.createOneAccountWithOrdsAndOrdProducts(1, 100, 5, 1, 200,'Draft');  
    acct.Status='Ordered';
Test.startTest();
List<Order> ord = [Select Id, OrderNumber, AccountId, TotalAmount, Status, ShipmentCost__c ,NetAmount__c
                from Order where AccountId =:acct.Id]; 

// Set Order Status to+ Ordered in order to activate the trigger 
Test.stopTest();
List<Order> orde = [select Id, NetAmount__c from Order
            where Id = :acct.Id AND status='Ordered'];
System.assertEquals(orde.NetAmount__c, 900,'Result should be 900'); //Verify that . 
    

}
}
