public with sharing class toDoListController {

    @AuraEnabled(cacheable=true)
    public static List<DataTableWrapper> getIssues(Date dateValue) {
        List<Issue__c> listOfIssues = [SELECT Name, Description__c, Date_to_Do__c, Family_Member__c FROM Issue__c WHERE Date_to_Do__c =: dateValue];

        List<DataTableWrapper> response = new List<DataTableWrapper>();
        for(Issue__c issue : listOfIssues){
            DataTableWrapper item = new DataTableWrapper();
            item.name = issue.Name;
            item.nameUrl = '/'+issue.Id;
            item.Description = issue.Description__c;
            item.dateToDo = issue.Date_to_Do__c;
            item.memberOfFamily = issue.Family_Member__c;
            response.add(item);
        }

        return response;
    }

    @AuraEnabled
    public static Issue__c insertIssue(String name, String description, Date dateToDo, String familyMember){
        Issue__c newIssue = new Issue__c();
        newIssue.Name = name;
        newIssue.Description__c = description;
        newIssue.Date_to_Do__c = dateToDo;
        newIssue.Family_Member__c = familyMember;
    System.debug('test ' + newIssue);
        insert newIssue;
        return newIssue;
    }

    @AuraEnabled
    public static Task insertTask(String subject) {
        try {
            Task task = new Task(
                Subject = subject,
                OwnerId = UserInfo.getUserId(),
                Status = 'Not Started',
                Priority = 'Normal'
            );
            insert task;
            return task;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        return null;
    }
    
    @AuraEnabled
    public static Boolean deleteTask(Id recordId) {
        try {
            Database.delete(recordId);
            return true;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        return false;
    }

    private final static Integer MAX_RESULTS = 5;

    @AuraEnabled(cacheable=true scope='global')
    public static List<LookupSearchResult> search(String searchTerm, List<String> selectedIds) {
        // Prepare query parameters
        searchTerm += '*';

        // Execute search query
        List<List<SObject>> searchResults = [
            FIND :searchTerm
            IN ALL FIELDS
            RETURNING
            Family_Member__c(Id, Name, Role__c WHERE id NOT IN :selectedIds)
            LIMIT :MAX_RESULTS
        ];

        // Prepare results
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        String membersIcon = 'custom:custom1';
        Family_Member__c[] members = (List<Family_Member__c>) searchResults[0];
        for (Family_Member__c member : members) {
            String subtitle = member.Role__c == null ? 'Family Member' : + member.Role__c;
            results.add(new LookupSearchResult(member.Id, 'Family Member', membersIcon, member.Name, subtitle));
        }

        // Optionnaly sort all results on title
        results.sort();

        return results;
    }

    @AuraEnabled(cacheable=true scope='global')
    public static List<LookupSearchResult> getRecentlyViewed() {
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        List<RecentlyViewed> recentRecords = [
            SELECT Id, Name, Type
            FROM RecentlyViewed
            WHERE Type = 'Family_Member__c'
            ORDER BY LastViewedDate DESC
            LIMIT 5
        ];
        // Convert recent records into LookupSearchResult
        for (RecentlyViewed recentRecord : recentRecords) {
            if (recentRecord.Type == 'Family_Member__c') {
                results.add(
                    new LookupSearchResult(
                        recentRecord.Id,
                        'Family_Member__c',
                        'custom:custom1',
                        recentRecord.Name,
                        recentRecord.Name
                    )
                );
            }
        }
        return results;
    }

     private class DataTableWrapper {
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String nameUrl {get;set;}
        @AuraEnabled
        public String Description {get;set;}
        @AuraEnabled
        public Date dateToDo {get;set;}
        @AuraEnabled
        public String memberOfFamily {get;set;}
    }

}