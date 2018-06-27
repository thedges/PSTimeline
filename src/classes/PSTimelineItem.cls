public class PSTimelineItem {
    public static String TYPE_BOX = 'box';
    public static String TYPE_POINT = 'point';
    public static String TYPE_RANGE = 'range';
    public static String TYPE_BACKGROUND = 'background';
    
    @AuraEnabled public String id;
    @AuraEnabled public String title;
    @AuraEnabled public String content;
    @AuraEnabled public DateTime startDttm;
    @AuraEnabled public DateTime endDttm;
    @AuraEnabled public String type;
    @AuraEnabled public String className;
    @AuraEnabled public String style;
    
    public PSTimelineItem() {}

}