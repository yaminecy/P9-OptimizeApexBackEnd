trigger UpdateAccountTurnover on Order (after update) {
    set<id> ids=new set<id>();
    for(order ord: trigger.new){
        ids.add(ord.AccountId);
    }
        
    List<Account> accountsToUpdate=new List<Account>();
    Map<ID, Account> acc = new Map<ID, Account>([select id,Chiffre_d_affaire__c from account where id in :ids]);
    AggregateResult[] groupedResults = [SELECT AccountId,SUM(TotalAmount)amt FROM Order where AccountId in:ids and Status='Activated' group by AccountId]; //Query all orders with status "Activated" and group them by account

    for(AggregateResult Results: groupedResults){
         Id accountId =(id) Results.get('AccountId');         
         Account a=acc.get(accountId);        
         a.Chiffre_d_affaire__c=integer.valueOf(Results.get('amt')); // For each account, updated the "Chiffre d'affaire" field with the value of all Order "TotalAmount" related to it
         accountsToUpdate.add(a);
    } 
     for(Account acct:accountsToUpdate){
        system.debug(acct);
    }
    
     update accountsToUpdate;


}