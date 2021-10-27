global class Batch01AccountTurnover implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext info){ 
            // Request only accounts that have at least one order with status 'ordered'
        return Database.getQueryLocator('SELECT Id FROM Account');
 
    }
     
    global void execute(Database.BatchableContext info, List<Account> scope){      
        list<Order> listOrders =  [SELECT Id, TotalAmount, AccountId FROM Order WHERE Status = 'Activated'];
        
         for(integer i=0; i < scope.size(); i++){
             Account myAccount = scope[i];
             myAccount.Chiffre_d_affaire__c = 0;
            for(integer j=0; j < listOrders.size(); j++){
                if(listOrders[j].AccountId == myAccount.Id){
                    myAccount.Chiffre_d_affaire__c = myAccount.Chiffre_d_affaire__c + listOrders[j].TotalAmount;
                }                   
            }
        }
        
        update scope;
    }    
     
    global void finish(Database.BatchableContext info){     
        
    } 
 }