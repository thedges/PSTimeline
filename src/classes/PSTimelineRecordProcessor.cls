public class PSTimelineRecordProcessor implements PSRecordProcessorIF {
    private Map<String, Integer> groupMap = new Map<String, Integer>();
    private List<Object> itemList = new List<Object>();
    private Map<String, String> config = new Map<String, String>();
    
    public void setConfig(Map<String, String> config)
    {
        this.config = config;
    }

    private void addGroup(String g)
    {
        if (!groupMap.containsKey(g))
        {
          groupMap.put(g, groupMap.size());
        }
    }
    
   public List<Object> getGroupList()
    {
        List<Object> gList = new List<Object>();
        Integer i = 0;
        for (String key : groupMap.keySet())
        {
          Map<String, Object> gmap = new Map<String, Object>();
          gmap.put('id', groupMap.get(key));
          gmap.put('content', key);
          gmap.put('visible', true);
          gmap.put('style', 'font-weight: bold;color:#259feb;');
          gList.add(gmap);
        }
        return gList;
    }

    public List<Object> getItemList()
    {
        return itemList;
    }

    public Object getResponse()
    {
        Map<String, Object> resp = new Map<String, Object>();
        resp.put('type', 'PSTimelineRecordProcessor');
        resp.put('groups', getGroupList());
        resp.put('items', itemList);
        return resp;
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
        String groupByField = config.get('objectGroupByField');
        String itemType = config.get('itemType');
        String networkPrefix = config.get('networkPrefix');
        String sldsResourceURL = config.get('sldsIconResource');
        String bgColor;
        Integer truncSize = Integer.valueOf(config.get('truncSize'));
        
        if (rec.get(dateField) != null)
        {
            Map<String, Object> item = new Map<String, Object>();
            item.put('id', rec.Id);
            
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
                item.put('content', iconHTML + '<span class="slds-p-left_x-small" >' + body + '</span>');
            }
            else
            {
                item.put('content', body);
            }
            
            if (descField != null && descField.length() > 0)
            {
                item.put('title', (String)rec.get(descField));
            }
            

            item.put('start', (DateTime)rec.get(dateField));
            item.put('type', itemType);

            if (groupByField != null && groupByField.length() > 0)
            {
              addGroup((String)rec.get(groupByField));
              item.put('group', groupMap.get((String)rec.get(groupByField)));
            }


            if (bgColor != null)
            {
                item.put('style', 'background-color: ' + bgColor + ';');
            }
            itemList.add(item);
        } 
    }
    
    public void postProcess()
    {
    }
    
    public String toJSON()
    {
        return JSON.serialize(itemList, true);
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
                String category = res[0].trim();
                String name = res[1].trim();
                
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