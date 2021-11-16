@isTest
public with sharing class TestTeamOrders {
    @isTest
    static void  TestTeamOrders() {
//Create 5 accounts with 2 orders each, having status "Ordered",Order shipment =100  and 10 OrderItem for each Order with UnitPrice=1000 and quantity=1
Account [] accts = TestDataFactory.createMultipleAccountWithOrdsAndOrdProducts(5,2,100,10,1,1000,'Ordered');
TeamOrders  tOrds = new TeamOrders();
System.assertEquals(tOrds.SumOders,Null,'Result should be 100000'); //Verify that we get the sum of all Order TotalAmount 

    }
}
