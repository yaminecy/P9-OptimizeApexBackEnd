@isTest
public with sharing class TestUpdateAccountTotalRevenue {

@isTest
static void TestUpdateAccountTotalRevenue(){
//Create 10 accounts with 5 orders each having the  status "Ordered",Order shipment =100  and 10 OrderItem for each Order with UnitPrice=1000 and quantity=10
Account [] accts = TestDataFactory.createMultipleAccountWithOrdsAndOrdProducts(10,5,100,10,10,1000,'Draft');
Test.startTest();
UpdateAccounts uca = new UpdateAccounts();
Id batchId = Database.executeBatch(uca); //Launch the batch 
Test.stopTest();
List<Account> acctsUpdated =[select Id,Name,Chiffre_d_affaire__c from Account where Id in(select AccountId from Order where status='Ordered')];
for(Account acct : acctsUpdated){
system.assertEquals(500000,acct.Chiffre_d_affaire__c,'Result should be 500000');
//Verify that all accounts "chiffre d'affaire" having Oder with Status Ordered has been updated
        }  

    }
}

