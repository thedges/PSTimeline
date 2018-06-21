public class PSTimelineItem {
    public static String TYPE_BOX = 'box';
    public static String TYPE_POINT = 'point';
    public static String TYPE_RANGE = 'range';
    public static String TYPE_BACKGROUND = 'background';
    
    public String id;
    public String title;
    public String content;
    public DateTime startDttm;
    public DateTime endDttm;
    public String type;
    public String className;
    public String style;
}