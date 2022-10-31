public with sharing class WrapperClassPost {
    public Integer userId;
    public Integer id;
    public String title;
    public String body;

    public WrapperClassPost(Integer userId, Integer id, String title, String body){
        this.body = body;
        this.id = id;
        this.title = title;
        this.userId = userId;
    }
}
