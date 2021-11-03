public with sharing class TeamOrders {
    public Integer SumOders{
        get{
			AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order where status ='Ordered']; // get the sum of all order TotalAmount 
			return Integer.valueOf(groupedResults.get('total'));
        }
        set;
    }

}
