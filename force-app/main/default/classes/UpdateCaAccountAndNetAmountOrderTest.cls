@isTest
private class UpdateCaAccountAndNetAmountOrderTest{
    
    @isTest
    static void testUpdateAccountChiffreAffaireWithOneOrderAndMultipleOrderItem(){
        
        //Create an account with 1 orders having Draft Status,Order shipment =100  and 5 OrderItem for each Order with UnitPrice=200 and quantity=1 
        Account acct = TestDataFactory.createOneAccountWithOrdsAndOrdProducts(1, 100, 5, 1, 200,'Draft');  
        Test.startTest();
        List<Order> ord = [Select Id, OrderNumber, AccountId, TotalAmount, Status, ShipmentCost__c, NetAmount__c, EffectiveDate
                           from Order
                           where AccountId = :acct.Id];
        TestDataFactory.setOrderStatusToOrdered(ord, 1); // Set Order Status to Ordered in order to triggered the trigger 
        Test.stopTest();
        Account acc = [select Id, Name, Chiffre_d_affaire__c
                        from Account
                        where Id = :acct.Id];
        System.assertEquals(acc.Chiffre_d_affaire__c, 1000,'Result should be 1000'); //Verify that the after the account "chiffre d'affaire" has been correctly updated  
        
    }
    
    @isTest
    static void testUpdateAccountCAWithMultipleOrder(){
        //Create an account with 200 orders having status "Draft",Order shipment =100  and 1 OrderItem for each Order with UnitPrice=1 and quantity=1
        Account acct = TestDataFactory.createOneAccountWithOrdsAndOrdProducts(200, 100, 1, 1, 10,'Draft');
        Test.startTest();
        List<Order> ordsToUpdate = new List<Order>();
        List<order> ords = [select Id, OrderNumber, AccountId, Status, ShipmentCost__c, NetAmount__c, EffectiveDate
                            from Order
                            where AccountId = :acct.Id];
        TestDataFactory.setOrderStatusToOrdered(ords, 20); //Set the 20th Order Status to Ordered in order to triggered the trigger 
        Test.stopTest();
        Account acc = [select Id, Name, Chiffre_d_affaire__c
                        from Account
                        where Id = :acct.Id]; 
        System.assertEquals(acc.Chiffre_d_affaire__c, 200,'Result should be 200'); //Verify that the account "Chiffre d'affaire " has been correctly updated  
        
    }
   
    @isTest
    static void testUpdateAccountCAOrderOrdered(){
        //Create 10 account with 5 orders each having status "Ordered",Order shipment =100  and 10 OrderItem for each Order with UnitPrice=1000 and quantity=10
        Account [] accts = TestDataFactory.createMultipleAccountWithOrdsAndOrdProducts(10,5,100,10,10,1000,'Ordered');
        Test.startTest();
        UpdateAccountCAOrderOrdered uca = new UpdateAccountCAOrderOrdered();
        Id batchId = Database.executeBatch(uca); //Launch the batch 
        Test.stopTest();
        List<Account> acctsUpdated =[select Id,Name,Chiffre_d_affaire__c from Account where Id in(select AccountId from Order where status='Ordered')];
        for(Account acct : acctsUpdated){
           system.assertEquals(500000,acct.Chiffre_d_affaire__c,'Result should be 500000'); //Verify that all account "chiffre d'affaire" having Oder with Status Ordered has been updated
        }  
        
    }
    
    @isTest
    static void testCalculMontant(){
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
    
    @isTest
    static void testTeamOrdersController(){
        
        //Create 5 account with 2 orders each having status "Ordered",Order shipment =100  and 10 OrderItem for each Order with UnitPrice=1000 and quantity=1
        Account [] accts = TestDataFactory.createMultipleAccountWithOrdsAndOrdProducts(5,2,100,10,1,1000,'Ordered');
        TeamOrders  tOrds = new TeamOrders();
        system.assertEquals(tOrds.SumOders,100000,'Result should be 100000'); //Verify that we get the sum of all Order TotalAmount 
        
    }
    
}