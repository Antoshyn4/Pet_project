public with sharing class testQuebleName implements Queueable, Database.AllowsCallouts{
    public void execute(System.QueueableContext sc) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:__GetPosts');
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        List<User__c> listOfPosts = new List<User__c>();

        if (res.getStatusCode() == 200) {
            List<WrapperClassPost> wrapperClassList= (List<WrapperClassPost>)JSON.deserialize(res.getBody(), List<WrapperClassPost>.class);
            for (WrapperClassPost wr : wrapperClassList) {
                listOfPosts.add(new User__c(id__c = wr.id, userId__c = wr.userId, title__c = wr.title, body__c = wr.body));
            }
        }else {
            System.debug('Status code is ' + res.getStatusCode());
        }

        HttpRequest reqCom = new HttpRequest();
        reqCom.setEndpoint('callout:__GetComments');
        reqCom.setMethod('GET');
        Http httpCom = new Http();
        HttpResponse ComRes = httpCom.send(reqCom);
        List<Comment__c> listOfComments = new List<Comment__c>();

        if (ComRes.getStatusCode() == 200) {
            List<WrapperClassComment> wrapperClassCommentList= (List<WrapperClassComment>)JSON.deserialize(ComRes.getBody(), List<WrapperClassComment>.class);
            for (WrapperClassComment wr : wrapperClassCommentList) {
                listOfComments.add(new Comment__c(postId__c = wr.postId, Id__c = wr.Id, name__c = wr.name, email__c = wr.email, body__C = wr.body));
            }
        } else {
            System.debug('Status code is ' + ComRes.getStatusCode());
        }

        HttpRequest reqPost = new HttpRequest();
        reqPost.setEndpoint('callout:__GetPosts');
        reqPost.setMethod('POST');
        Http PostHttp = new Http();
        HttpResponse PostRes = PostHttp.send(reqPost);

        if (PostRes.getStatusCode() == 201) {
            PostRes.setBody(JSON.serialize(new WrapperClassPost(101,101,'Test','Some body text')));
        }else {
            System.debug('Status code is ' + PostRes.getStatusCode());
        }

        if (!listOfPosts.isEmpty()) {
            upsert listOfPosts;   
        }
        if (!listOfComments.isEmpty()) {
            upsert listOfComments;
        }
    }
}
