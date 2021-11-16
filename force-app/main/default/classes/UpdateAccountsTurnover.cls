global class UpdateAccountsTurnover implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext info){ 
        // Only query accounts with at least an order with status "Ordered"
        return Database.getQueryLocator([select Id,Name,(select Id,TotalAmount,OrderNumber,status from Orders)
       from Account where Id in (select AccountId from Order where status ='Ordered')]);
    }
    
    global void execute(Database.BatchableContext info, List<Account> scope){ 
        // For each account update the "Chiffre d'affaire" field 

        List<Account> acctsToUpdate = new List<Account>();
        List<Order> listOrders =  [select Id,TotalAmount,AccountId,status from Order where status ='Ordered'];
        for(Account acct:scope){
            acct.Chiffre_d_affaire__c =0;
            for(order ord:listOrders){
                if(ord.AccountId == acct.Id){
                    acct.Chiffre_d_affaire__c =  acct.Chiffre_d_affaire__c + ord.TotalAmount;
                }
            }
            acctsToUpdate.add(acct);
        }
        if(acctsToUpdate.isEmpty())
            system.debug('No Account has any orders Ordered');
        else{
            update acctsToUpdate;
            system.debug('Batch executed');
        }
        
        
    }    
    
    global void finish(Database.BatchableContext info){     
        system.debug('Batch finished');
    } 
}