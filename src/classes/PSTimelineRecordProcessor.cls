public class PSTimelineRecordProcessor implements PSRecordProcessorIF {
    private List<PSTimelineItem> itemList = new List<PSTimelineItem>();
    private Map<String, String> config = new Map<String, String>();
    
    public void setConfig(Map<String, String> config)
    {
        this.config = config;
    }
    
    public void addConfig(String name, String value)
    {
        config.put(name, value);
    }
    
    public void processRecord(SObject rec)
    {
        String objectName = config.get('objectName');
        String icon = config.get('objectIcon');
        String labelField = config.get('objectLabelField');
        String descField = config.get('objectDescField');
        String dateField = config.get('objectDateField');
        String iconField = config.get('objectIconField');
        String colorField = config.get('objectColorField');
        String itemType = config.get('itemType');
        String networkPrefix = config.get('networkPrefix');
        String sldsResourceURL = config.get('sldsResourceURL');
        String bgColor;
        Integer truncSize = Integer.valueOf(config.get('truncSize'));
        
        if (rec.get(dateField) != null)
        {
            PSTimelineItem item = new PSTimelineItem();
            item.id = rec.Id;
            
            // override icon field with value from record
            if (iconField != null && iconField.length() > 0)
            {
                String tmpIcon = (String)rec.get(iconField);
                if (tmpIcon != null && tmpIcon.length() > 0) icon = tmpIcon;
            }
            
            // get background color of item
            if (colorField != null && colorField.length() > 0)
            {
                String tmpColor = (String)rec.get(colorField);
                if (tmpColor != null && tmpColor.length() > 0) bgColor = tmpColor;
            }
            
            String iconHTML = getIconHTML(icon, 'x-small', networkPrefix, sldsResourceURL);
            String label = (String)rec.get(labelField);
            if (label == null) label = objectName + ' missing label';
            String body = cleanItemString(label, truncSize);
            
            if (iconHTML != null)
            {
                item.content = iconHTML + '<span class="slds-p-left_x-small" >' + body + '</span>';
            }
            else
            {
                item.content = body;
            }
            
            if (descField != null && descField.length() > 0)
            {
                item.title = (String)rec.get(descField);
            }
            
            item.startDttm = (DateTime)rec.get(dateField);
            item.type = itemType;
            if (bgColor != null) item.style = 'background-color: ' + bgColor + ';';
            itemList.add(item);
        } 
    }
    
    public void postProcess()
    {
    }
    
    public String toJSON()
    {
        return JSON.serialize(itemList, true).replaceAll('startDttm', 'start').replaceAll('endDttm', 'end');
    }
    
    private static String getIconHTML(String icon, String size, String networkPrefix, String sldsResourceURL)
    {
        String iconHTML = null;
        
        if (icon.startsWith('http'))
        {
            iconHTML = '<img src="' + icon + '" height="17" width="17"></img>';
        }
        else if (icon.startsWith('/resource'))
        {
            if (networkPrefix != null && networkPrefix.length() > 0)
            {
                icon = networkPrefix + icon;
            }
            iconHTML = '<img src="' + icon + '" height="17" width="17"></img>';
        }
        else if (icon.contains(':'))
        {
            List<String> res = icon.split(':');
            if (res.size() == 2)
            {
                String category = res[0];
                String name = res[1];
                
                if (networkPrefix != null && networkPrefix.length() > 0)
                {
                    sldsResourceURL = networkPrefix + sldsResourceURL;
                }
                
                iconHTML = '<span class="slds-icon_container slds-icon-' + category + '-' + name + '" >'
                    + '<svg aria-hidden="true" class="slds-icon slds-icon--' + size + '" name="' + name + '">' 
                    + '<use xlink:href="' + sldsResourceURL + '/assets/icons/' + category + '-sprite/svg/symbols.svg#' + name +'"></use>'
                    + '</svg></span>';
            }
        }   
        return iconHTML;
    }
    
    private static String cleanItemString(String str, Integer length)
    {
        if (str == null) return str;
        
        String newStr = str.replace('<p>', '').replace('</p>', '');
        if (newStr.length() > length)
        {
            newStr = newStr.replaceAll('\\<.*?\\>', '');
            if (newStr.length() > length)
            {
                newStr = newStr.substring(0,length) + '...';
            }
        }
        return newStr;
    }
}