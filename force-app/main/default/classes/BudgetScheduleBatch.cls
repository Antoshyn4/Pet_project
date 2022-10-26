public class BudgetScheduleBatch implements Schedulable, Database.Batchable<SObject> {

    String query = 'SELECT Id FROM ';

    public void BudgetSheduleBatch(){
        this.query += 'Budget__c';
    }

    public void execute(SchedulableContext sc){
        Database.executeBatch(new BudgetScheduleBatch());   
    }

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Budget__c> scope){
        Set<Id> setOfCompaniesId = new Set<Id>();
        for (Budget__c budget : [SELECT Company__c FROM Budget__c WHERE Id IN: scope]) {
            setOfCompaniesId.add(budget.Company__c);
        }
        List<AggregateResult> aggrRes = [SELECT COUNT(Id) coun, Company__r.Head_of_Company__c testId                                                FROM Budget__c
                                        WHERE Company__c IN :setOfCompaniesId
                                        AND Active__c = true
                                        GROUP BY Company__r.Head_of_Company__c];
        List<Employee__c> updateEmployeeList = new List<Employee__c>();

        for (AggregateResult aggr_i : aggrRes) {
            updateEmployeeList.add(new Employee__c(Id = (Id)(aggr_i.get('testId')), Count_of_bugets__c = (Decimal)aggr_i.get('coun')));
        }
        if (!updateEmployeeList.isEmpty()) {
            update updateEmployeeList;
        }
    }

    public void finish(Database.BatchableContext bc){

    }
}