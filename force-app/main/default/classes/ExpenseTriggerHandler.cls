public class ExpenseTriggerHandler {
    
    public void onAfterUpdate(Map<Id, Expense__c> newMap, Map<Id, Expense__c> oldMap){
        checkPurchaseAlreadyCompletedValue(newMap, oldMap);
    }
    
    public void onAfterInsert(List<Expense__c> expenseList){
       updateExpenseValue(expenseList);
    }
    
    public void checkPurchaseAlreadyCompletedValue(Map<Id, Expense__c> newMap, Map<Id, Expense__c> oldMap){
        Set<Id> setOfMonthlyBudgetId = new Set<Id>();
        for (Expense__c expense : newMap.values()){
            setOfMonthlyBudgetId.add(expense.Monthly_Budget__c);
        }
        List<Monthly_Budget__c> listOfMonthlyBudget = [SELECT Id, Educational_expenses__c, Family_expenses__c, Hobby_expenses__c, Medical_expenses__c, Shopping__c FROM Monthly_Budget__c WHERE Id IN :setOfMonthlyBudgetId];
        
        for (Id expenseId : newMap.keyset()){
            if (oldMap.get(expenseId).Purchase_already_completed__c != newMap.get(expenseId).Purchase_already_completed__c && newMap.get(expenseId).Purchase_already_completed__c == true){
                for (Monthly_Budget__c monthlyBudget : listOfMonthlyBudget){
                    if (monthlyBudget.Id == newMap.get(expenseId).Monthly_Budget__c){
                        if(newMap.get(expenseId).Type__c == 'Educational') {
                            monthlyBudget.Educational_expenses__c += newMap.get(expenseId).Price__c;              
                    	}
                        if(newMap.get(expenseId).Type__c ==  'Family') {	
                            monthlyBudget.Family_expenses__c += newMap.get(expenseId).Price__c;
                        }
                        if(newMap.get(expenseId).Type__c ==  'Hobby') {
                            monthlyBudget.Hobby_expenses__c += newMap.get(expenseId).Price__c;
                        }
                        if(newMap.get(expenseId).Type__c ==  'Medical') {
                            monthlyBudget.Medical_expenses__c += newMap.get(expenseId).Price__c;
                        }
                        if(newMap.get(expenseId).Type__c == 'Shopping') {
                            monthlyBudget.Shopping__c += newMap.get(expenseId).Price__c;
                        }
                    }
                }
            }
        }
        update listOfMonthlyBudget;
    }
    
    public void updateExpenseValue(List<Expense__c> listOfExpense){
        Set<Id> setOfMonthlyBudgetId = new Set<Id>();
        for (Expense__c expense : listOfExpense){
            setOfMonthlyBudgetId.add(expense.Monthly_Budget__c);
        }
        
        List<Monthly_Budget__c> listOfMonthlyBudget = [SELECT Id, Educational_expenses__c, Family_expenses__c, Hobby_expenses__c, Medical_expenses__c, Shopping__c FROM Monthly_Budget__c WHERE Id IN :setOfMonthlyBudgetId];
        for (Expense__c expense : listOfExpense){
            if	(expense.Purchase_already_completed__c == true){
                for (Monthly_Budget__c monthlyBudget : listOfMonthlyBudget){
                    if (monthlyBudget.Id == expense.Monthly_Budget__c){
                        if(expense.Type__c == 'Educational') {
                            monthlyBudget.Educational_expenses__c += expense.Price__c;              
                    	}
                        if(expense.Type__c ==  'Family') {	
                            monthlyBudget.Family_expenses__c += expense.Price__c;
                        }
                        if(expense.Type__c ==  'Hobby') {
                            monthlyBudget.Hobby_expenses__c += expense.Price__c;
                        }
                        if(expense.Type__c ==  'Medical') {
                            monthlyBudget.Medical_expenses__c += expense.Price__c;
                        }
                        if(expense.Type__c == 'Shopping') {
                            monthlyBudget.Shopping__c += expense.Price__c;
                        }
                    }
                }
            }
        }
        update listOfMonthlyBudget;
    }
}