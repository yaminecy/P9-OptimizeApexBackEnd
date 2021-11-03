@isTest
private class testUpdateAccountTurnover {
@isTest static void test() {
    Account  account1 = new Account(Name = 'Test Account 1');
    Insert account1;

    Product2  product  = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
    Insert product;

    //Create the PricebookEntry
    PricebookEntry pbe = new PricebookEntry(
        Pricebook2Id = Test.getStandardPricebookId(),
        Product2Id = product.Id,
        UnitPrice = 1020,
        IsActive = true
    );
    Insert pbe;

    Order  order1 = new Order(AccountId = account1.Id);
    insert order1;

    OrderItem orderItem1 = new OrderItemItem (OrderId = order1.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
    insert orderItem1;
    OrderItem orderItem2 = new OrderItemItem (OrderId = order1.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
    insert orderItem2;        
}
}