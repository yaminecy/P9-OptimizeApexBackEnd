trigger CalculateAmount on Order (before update) {
    for(order ord : trigger.new){
        if(ord.NetAmount__c == null && ord.ShipmentCost__c== null){
            ord.NetAmount__c = 0;
        	ord.ShipmentCost__c =0;
        }    
            ord.NetAmount__c = ord.TotalAmount - ord.ShipmentCost__c;  // Update the "Net Amount" field using the formula NetAmount = TotalAmount - ShipmentCost
    }

}