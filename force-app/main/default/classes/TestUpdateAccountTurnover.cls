@isTest
private class TestUpdateAccountTurnover{

@isTest
static void testUpdateAccountTurnoverWithOneOrderAndMultipleOrderItem(){

//Create an account with 1 order having Draft Status,Order shipment =100  and 5 OrderItem for each Order with UnitPrice=200 and quantity=1 
Account acct = TestDataFactory.createOneAccountWithOrdsAndOrdProducts(1, 1, 5, 1, 200,'Draft');  
Test.startTest();
List<Order> ord = [Select Id, OrderNumber, AccountId, TotalAmount, Status, ShipmentCost__c, NetAmount__c, EffectiveDate
                from Order
                where AccountId =:acct.Id];
TestDataFactory.setOrderStatusToOrdered(ord, 1); // Set Order Status to Ordered in order to activate the trigger 
Test.stopTest();
Account acc = [select Id, Name, Chiffre_d_affaire__c
            from Account
            where Id = :acct.Id];
System.assertEquals(acc.Chiffre_d_affaire__c, 1000,'Result should be 1000'); //Verify that the after the account "chiffre d'affaire" has been correctly updated  

}

@isTest
static void testUpdateAccountTurnoverWithMultipleOrder(){
//Create an account with 200 orders having status "Draft",Order shipment =100  and 1 OrderItem for each Order with UnitPrice=1 and quantity=1
Account acct = TestDataFactory.createOneAccountWithOrdsAndOrdProducts(200, 100, 1, 1, 10,'Draft');
Test.startTest();
List<Order> ordsToUpdate = new List<Order>();
List<order> ords = [select Id, OrderNumber, AccountId, Status, ShipmentCost__c, NetAmount__c, EffectiveDate
                from Order
                where AccountId = :acct.Id];
TestDataFactory.setOrderStatusToOrdered(ords, 20); 
//Set the 20th Order Status to Ordered in order to triggered the trigger 
Test.stopTest();
Account acc = [select Id, Name, Chiffre_d_affaire__c
            from Account
            where Id = :acct.Id]; 
System.assertEquals(acc.Chiffre_d_affaire__c, 200,'Result should be 200'); 
//Verify that the account "Turnover " has been correctly updated  

}

}