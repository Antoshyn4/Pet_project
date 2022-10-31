@RestResource(urlMapping = '/fetchPosts/*')
global with sharing class PostRestService {

    @HttpGet
    // {
    //     id = 1
    //     userid = 1
    //     title = 'sunt aut facere repellat provident occaecati excepturi optio reprehenderit'
    //     body = 'quia et suscipit
    //     suscipit recusandae consequuntur expedita et cum
    //     reprehenderit molestiae ut ut quas totam
    //     nostrum rerum est autem sunt rem eveniet architecto'
    // }
    global static void getPost(){
        RestRequest req = RestContext.request; 
        Integer filtr = (Integer)JSON.deserialize(req.requestBody.toString(), Integer.class);
        RestResponse resp = RestContext.response;
        try {
            List<User__c> postsList = [SELECT id FROM User__c WHERE id__c =: filtr];
            resp.statusCode = 200;
            resp.responseBody = Blob.valueOf(JSON.serialize(postsList));
        } catch (Exception e) {
            resp.statusCode = 400;
            resp.responseBody = Blob.valueOf('Error massage: ' + e.getMessage());
        }
    }

    @HttpPost
    global static void postPost(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            res.statusCode = 201;
            User__c post = new User__c();
            List<WrapperClassPost> postsList = (List<WrapperClassPost>)JSON.deserialize(req.requestBody.toString(), List<WrapperClassPost>.class);
            List<User__c> updatepostsList = new List<USer__c>();
            for (WrapperClassPost wcp : postsList) {
                updatepostsList.add(new User__c(id__c = wcp.id, userId__c = wcp.userId, title__c = wcp.title, body__c = wcp.body));   
            }
            if (!postsList.isEmpty()) {
                insert updatepostsList;
            }
        } catch (Exception e) {
            res.statusCode = 401;
            res.responseBody = Blob.valueOf('Error massage: ' + e.getMessage());
        }
    }

    @HttpDelete
    global static void deletePost(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Integer filtr = (Integer)JSON.deserialize(req.requestBody.toString(), Integer.class);

        try {
            res.statusCode = 203;
            List<User__c> postsToDelete = [SELECT id FROM User__c WHERE id__c =: filtr];
            if (!postsToDelete.isEmpty()) {
                delete postsToDelete;
            }
        } catch (Exception e) {
            res.statusCode = 403;
            res.responseBody = Blob.valueOf('Error massage: ' + e.getMessage());
        }
    }

    @HttpPut
    global static void putPost(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            res.statusCode = 214;
            User__c post = new User__c();
            List<WrapperClassPost> postsList = (List<WrapperClassPost>)JSON.deserialize(req.requestBody.toString(), List<WrapperClassPost>.class);
            List<User__c> updatepostsList = new List<USer__c>();
            for (WrapperClassPost wcp : postsList) {
                updatepostsList.add(new User__c(id__c = wcp.id, userId__c = wcp.userId, title__c = wcp.title, body__c = wcp.body));   
            }
            if (!postsList.isEmpty()) {
                upsert updatepostsList;
            }
        } catch (Exception e) {
            res.statusCode = 414;
            res.responseBody = Blob.valueOf('Error massage: ' + e.getMessage());
        }
    }
}
