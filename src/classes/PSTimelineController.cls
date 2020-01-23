public without sharing class PSTimelineController
{
  private static String CREATED = 'created';
  private static String ITEM_BG_COLOR = '#d5ddf5';
  private static String GROUP_RECORD = 'Record';
  private static String GROUP_ACTIVITY = 'Activity';
  private static String GROUP_CHATTER = 'Chatter';
  private static String GROUP_CONTENT = 'Content';
  private static String GROUP_CASE_COMMENT = 'Case Comment';
  private static String GROUP_CASE_MILESTONE = 'Case Milestone';
  private static String GROUP_KA = 'Knowledge Article';

  @AuraEnabled
  public static Object queryData(String params)
  {
    System.debug('queryData invoked...');
    Map<String, String> paramMap = (Map<String, String>)JSON.deserialize(params,   Map<String, String>.class);
    System.debug(JSON.serializePretty(paramMap));
    //PSResponse resp = new PSResponse();
    Integer i = 1;

    try
    {
      //if (paramMap.containsKey('contactId'))  c.ContactId = paramMap.get('contactId');
      //List<PSTimelineItem> itemList = new List<PSTimelineItem>();
      List<Object> itemList = new List<Object>();
      Map<String, Integer> groupMap = new Map<String, Integer>();
      Integer groupNum = 0;

      String locale = paramMap.get('locale');
      if (locale == 'fr')
      {
        CREATED = 'créé';
        GROUP_RECORD = 'Record';
        GROUP_ACTIVITY = 'Activité';
        GROUP_CHATTER = 'Bavarder';
        GROUP_CONTENT = 'Contenu';
        GROUP_CASE_COMMENT = 'Commentaire de l\'affaire';
        GROUP_CASE_MILESTONE = 'Milestone Case';
        GROUP_KA = 'Article de connaissance';
      }

      String defaultBGColor = paramMap.get('defaultBGColor');
      if (defaultBGColor != null)
      {
        ITEM_BG_COLOR = defaultBGColor;
      }

      String recordId = paramMap.get('recordId');
      String itemType = paramMap.get('itemType');
      String groupItems = paramMap.get('groupItems');
      String sldsResourceURL = paramMap.get('sldsIconResource');

      Integer truncSize = 50;
      if (paramMap.containsKey('truncSize')) truncSize = Integer.valueOf(paramMap.get('truncSize'));

      String networkPrefix = null;
      if (paramMap.containsKey('networkPrefix')) networkPrefix = paramMap.get('networkPrefix');

      groupMap.put(GROUP_RECORD, groupMap.size());





      // **************** //
      // get created date //
      // **************** //
      if (recordId != null && recordId.length() > 0)
      {
        Id myId = ID.valueOf(recordId);
        String objectName = myId.getSObjectType().getDescribe().getName();
        String objectLabel = myId.getSObjectType().getDescribe().getLabel();

        String queryStr = 'SELECT Id, CreatedDate FROM ' + objectName + ' WHERE Id = \'' + recordId + '\'';
        System.debug('queryStr=' + queryStr);
        List<sObject> recList = Database.query(queryStr);
        if (recList != null && recList.size() == 1)
        {
          //PSTimelineItem item = new PSTimelineItem();
          Map<String, Object> item = new Map<String, Object>();

          //item.put('id', recList[0].Id);

          String iconHTML = getIconHTML('custom:custom9', 'x-small', networkPrefix, sldsResourceURL);
          String body = objectLabel + ' ' + CREATED + '!';

          if (iconHTML != null)
          {
            item.put('content', iconHTML + '<span class="slds-p-left_x-small" >' + body + '</span>');
          }
          else
          {
            item.put('content', body);
          }

          item.put('start', (Datetime)recList[0].get('CreatedDate'));
          item.put('type', itemType);
          item.put('group', groupMap.get(GROUP_RECORD));
          if (ITEM_BG_COLOR != '#d5ddf5') item.put('style', 'background-color:' + ITEM_BG_COLOR + ';');

          itemList.add(item);
        }
      }


      ////////////////////
      // get activities //
      ////////////////////
      if (paramMap.get('activityFlag') == 'true')
      {
        groupMap.put(GROUP_ACTIVITY, groupMap.size());
          
        String taskIcon = paramMap.get('taskIcon');     // standard:task
        String eventIcon = paramMap.get('eventIcon');   // standard:event
        String emailIcon = paramMap.get('emailIcon');   // standard:email
        String callIcon = paramMap.get('callIcon');     // standard:call

        for (Event e : [SELECT Id, Subject, Description, ActivityDateTime, StartDateTime, EndDateTime FROM Event WHERE WhatId = :recordId OR WhoId = :recordId])
        {
          Map<String, Object> item = new Map<String, Object>();
          item.put('id', e.Id);

          String iconHTML = getIconHTML(eventIcon, 'x-small', networkPrefix, sldsResourceURL);
          String body = cleanItemString(e.Subject, truncSize);

          if (iconHTML != null)
          {
            item.put('content', iconHTML + '<span class="slds-p-left_x-small" >' + body + '</span>');
          }
          else
          {
            item.put('content', body);
          }

          item.put('title', e.Description);
            
          if (e.ActivityDateTime != null)
          {
            item.put('start', e.ActivityDateTime);
          }
          else if (e.StartDateTime != null)
          {
            item.put('start', e.StartDateTime);
          }
            
          item.put('type', itemType);
          item.put('group', groupMap.get(GROUP_ACTIVITY));
          if (ITEM_BG_COLOR != '#d5ddf5') item.put('style', 'background-color:' + ITEM_BG_COLOR + ';');

          itemList.add(item);

        }

        ///////////////
        // get tasks //
        ///////////////
        for (Task t : [SELECT Id, Subject, Description, TaskSubtype, ActivityDate, CreatedDate, Status FROM Task WHERE WhatId = :recordId OR WhoId = :recordId])
        {
          Map<String, Object> item = new Map<String, Object>();
          item.put('id', t.Id);

          Datetime dttm = t.ActivityDate;
          if (t.ActivityDate == null)
          {
            dttm = t.CreatedDate;
          }

          String icon = taskIcon;
          if (t.TaskSubtype == 'Email')
          {
            icon = emailIcon;
          }
          else if (t.TaskSubtype == 'Call')
          {
            icon = callIcon;
          }

          String iconHTML = getIconHTML(icon, 'x-small', networkPrefix, sldsResourceURL);
          String body = cleanItemString(t.Subject, truncSize);

          if (iconHTML != null)
          {
            item.put('content', iconHTML + '<span class="slds-p-left_x-small" >' + body + '</span>');
          }
          else
          {
            item.put('content', body);
          }


          item.put('title', t.Description);
          item.put('start', dttm);
          item.put('type', itemType);
          item.put('group', groupMap.get(GROUP_ACTIVITY));
          if (ITEM_BG_COLOR != '#d5ddf5') item.put('style', 'background-color:' + ITEM_BG_COLOR + ';');

          if (t.TaskSubtype == 'Task')
          {
            if (t.status == 'Completed')
            {
              //item.className = 'Complete';
            }
            else
            {
              Date td = Date.today();
              if (t.ActivityDate < td && t.status != 'Completed')
              {
                item.put('className', 'Overdue');
              }
            }
          }
          itemList.add(item);

        }
      }

      ///////////////
      // get files //
      ///////////////
      if (paramMap.get('contentFlag') == 'true')
      {
        groupMap.put(GROUP_CONTENT, groupMap.size());
          
        for (ContentDocumentLink cdl : [SELECT ContentDocumentId, ContentDocument.FileType, ContentDocument.Title, ContentDocument.CreatedDate, LinkedEntityId, ShareType, SystemModstamp, Visibility
                                        FROM ContentDocumentLink
                                        WHERE LinkedEntityId = :recordId])
        {
          Map<String, Object> item = new Map<String, Object>();
          item.put('id', cdl.ContentDocumentId);


          String contentIcon = paramMap.get('contentIcon');   // standard:file

          String label = cdl.ContentDocument.FileType + ': ' + cdl.ContentDocument.Title;
          String iconHTML = getIconHTML(contentIcon, 'x-small', networkPrefix, sldsResourceURL);
          String body = cleanItemString(label, truncSize);

          if (iconHTML != null)
          {
            item.put('content', iconHTML + '<span class="slds-p-left_x-small" >' + body + '</span>');
          }
          else
          {
            item.put('content', body);
          }

          if (label.length() > truncSize) item.put('title', label);
          item.put('start', cdl.ContentDocument.CreatedDate);
          item.put('type', itemType);
          item.put('group', groupMap.get(GROUP_CONTENT));
          if (ITEM_BG_COLOR != '#d5ddf5') item.put('style', 'background-color:' + ITEM_BG_COLOR + ';');

          itemList.add(item);

        }
      }

      ////////////////////////////
      // get chatter text posts //
      ////////////////////////////
      if (paramMap.get('chatterFlag') == 'true')
      {
        groupMap.put(GROUP_CHATTER, groupMap.size());
          
        for (FeedItem fi : [SELECT Id, Body, LastModifiedDate
                            FROM FeedItem
                            WHERE ParentId = :recordId AND Type = 'TextPost'])
        {
          Map<String, Object> item = new Map<String, Object>();
          item.put('id', fi.Id);

          String chatterIcon = paramMap.get('chatterIcon');   // standard:post
          String iconHTML = getIconHTML(chatterIcon, 'x-small', networkPrefix, sldsResourceURL);

          String body = cleanItemString(fi.Body, truncSize);

          if (iconHTML != null)
          {
            item.put('content', iconHTML + '<span class="slds-p-left_x-small item_label">' + body + '</span>');
          }
          else
          {
            item.put('content', body);
          }

          if (fi.Body.length() > truncSize) item.put('title', fi.Body);
          item.put('start', fi.LastModifiedDate);
          item.put('type', itemType);
          item.put('group', groupMap.get(GROUP_CHATTER));
          if (ITEM_BG_COLOR != '#d5ddf5') item.put('style', 'background-color:' + ITEM_BG_COLOR + ';');

          itemList.add(item);

        }
      }

      ///////////////////////
      // get case comments //
      ///////////////////////
      if (paramMap.get('caseCommentFlag') == 'true')
      {
        groupMap.put(GROUP_CASE_COMMENT, groupMap.size());
          
        for (CaseComment cc : [SELECT Id, CommentBody, LastModifiedDate
                               FROM CaseComment
                               WHERE ParentId = :recordId])
        {
          Map<String, Object> item = new Map<String, Object>();
          //item.put('id', cc.Id);

          String commentIcon = paramMap.get('caseCommentIcon');   // custom:custom19

          String iconHTML = getIconHTML(commentIcon, 'x-small', networkPrefix, sldsResourceURL);
          String body = cleanItemString(cc.CommentBody, truncSize);

          if (iconHTML != null)
          {
            item.put('content', iconHTML + '<span class="slds-p-left_x-small" >' + body + '</span>');
          }
          else
          {
            item.put('content', body);
          }


          if (cc.CommentBody.length() > truncSize) item.put('title', cc.CommentBody);
          item.put('start', cc.LastModifiedDate);
          item.put('type', itemType);
          item.put('group', groupMap.get(GROUP_CASE_COMMENT));
          if (ITEM_BG_COLOR != '#d5ddf5') item.put('style', 'background-color:' + ITEM_BG_COLOR + ';');

          itemList.add(item);

        }
      }

      /////////////////////////
      // get case milestones //
      /////////////////////////
      if (paramMap.get('caseMilestoneFlag') == 'true')
      {
        groupMap.put(GROUP_CASE_MILESTONE, groupMap.size());
          
        for (CaseMilestone cc : [SELECT Id, MilestoneType.Name, IsViolated, IsCompleted, TargetDate
                               FROM CaseMilestone
                               WHERE CaseId = :recordId AND IsDeleted != true])
        {
          Map<String, Object> item = new Map<String, Object>();
          item.put('id', cc.Id);

          String milestoneIcon = paramMap.get('caseMilestoneIcon');   // standard:case_milestone

          String iconHTML = getIconHTML(milestoneIcon, 'x-small', networkPrefix, sldsResourceURL);
          String msg = cc.MilestoneType.Name;
          if (cc.IsViolated)
          {
              msg += ' (violation)';  
          }
          else if (cc.IsCompleted)
          {
              msg += ' (completed)'; 
          }
          String body = cleanItemString(msg, truncSize);

          if (iconHTML != null)
          {
            item.put('content', iconHTML + '<span class="slds-p-left_x-small" >' + body + '</span>');
          }
          else
          {
            item.put('content', body);
          }

          if (msg != null && msg.length() > truncSize) item.put('title', msg);
          item.put('start', cc.TargetDate);
          item.put('type', itemType);
          item.put('group', groupMap.get(GROUP_CASE_MILESTONE));
          
          if (cc.IsViolated) 
          {
            item.put('className', 'Overdue');
          }
          else {
            if (ITEM_BG_COLOR != '#d5ddf5') item.put('style', 'background-color:' + ITEM_BG_COLOR + ';');
          }

          itemList.add(item);

        }
      }

      ////////////////////////////
      // get knowledge articles // 
      ////////////////////////////
      if (paramMap.get('kaFlag') == 'true')
      {
        groupMap.put(GROUP_KA, groupMap.size());
          
        for (CaseArticle cc : [SELECT Id, KnowledgeArticleId, KnowledgeArticleVersionId, KnowledgeArticleVersion.Title, CreatedDate  
                                   FROM CaseArticle 
                                  WHERE CaseId = :recordId AND IsDeleted != true])
        {
          Map<String, Object> item = new Map<String, Object>();
          item.put('id', cc.KnowledgeArticleVersionId);

          String kaIcon = paramMap.get('kaIcon');   // standard:knowldedge

          String iconHTML = getIconHTML(kaIcon, 'x-small', networkPrefix, sldsResourceURL);
          String msg = cc.KnowledgeArticleVersion.Title;
          String body = cleanItemString(msg, truncSize);

          if (iconHTML != null)
          {
            item.put('content', iconHTML + '<span class="slds-p-left_x-small" >' + body + '</span>');
          }
          else
          {
            item.put('content', body);
          }

          if (msg != null && msg.length() > truncSize) item.put('title', msg);
          item.put('start', cc.CreatedDate);
          item.put('type', itemType);
  
          item.put('group', groupMap.get(GROUP_KA));
          if (ITEM_BG_COLOR != '#d5ddf5') item.put('style', 'background-color:' + ITEM_BG_COLOR + ';');

          itemList.add(item);

        }
      }

      // loop through child object count
      for (Integer j = 1; j <= 5; j++)
      {
        if (paramMap.get('child' + j + 'Flag') == 'true')
        {

          String labelField = paramMap.get('child' + j + 'LabelField');
          String dateField = paramMap.get('child' + j + 'DateField');
          String colorField = paramMap.get('child' + j + 'ColorField');
          String descField = paramMap.get('child' + j + 'DescField');
          String objectName = paramMap.get('child' + j + 'Object');
          String parentField = paramMap.get('child' + j + 'ParentField');
          String icon = paramMap.get('child' + j + 'Icon');

          String objectLabel = Schema.getGlobalDescribe().get(objectName).getDescribe().getLabel();
          if (!groupMap.containsKey(objectLabel))
          {
            groupMap.put(objectLabel, groupMap.size());
          }
          Integer groupId = groupMap.get(objectLabel);

          String queryStr = 'SELECT Id, ' + labelField + ', ' + dateField;
          if (colorField != null && colorField.length() > 0)
          {
            queryStr += ', ' + colorField;
          }
          if (descField != null && descField.length() > 0)
          {
            queryStr += ', ' + descField;
          }
          queryStr += ' FROM ' + objectName + ' WHERE ' + parentField + ' = \'' + recordId + '\'';

          System.debug('queryStr=' + queryStr);
          List<sObject> recList = Database.query(queryStr);
          if (recList.size() > 0)
          {
            for (sObject rec : recList)
            {
              if (rec.get(dateField) != null)
              {
                Map<String, Object> item = new Map<String, Object>();
                item.put('id', rec.Id);

                String iconHTML = getIconHTML(icon, 'x-small', networkPrefix, sldsResourceURL);
                String label = (String)rec.get(labelField);
                String body = cleanItemString(label, truncSize);

                if (iconHTML != null)
                {
                  item.put('content', iconHTML + '<span class="slds-p-left_x-small" >' + body + '</span>');
                }
                else
                {
                  item.put('content', body);
                }

                // get background color of item
                String bgColor = ITEM_BG_COLOR;
                if (colorField != null && colorField.length() > 0)
                {
                  String tmpColor = (String)rec.get(colorField);
                  if (tmpColor != null && tmpColor.length() > 0) bgColor = tmpColor;
                }

                if (bgColor != null) item.put('style', 'background-color: ' + bgColor + ';');

                if (descField != null && descField.length() > 0)
                {
                  item.put('title', (String)rec.get(descField));
                }

                item.put('start', (DateTime)rec.get(dateField));
                item.put('type', itemType);
                item.put('group', groupId);

                itemList.add(item);
              }
            }
          }
        }
      }

      //String dataJSON = JSON.serialize(itemList, true);
      //resp.data = dataJSON;
      Map<String, Object> resp = new Map<String, Object>();
      resp.put('groups', createGroupList(groupMap, '#259feb'));
      resp.put('items', itemList);
      return  resp;


    }
    catch (exception e)
    {
      throw new AuraHandledException(e.getMessage());
    }


  }

  private static List<Object> createGroupList(Map<String, Integer> groupMap, String bgColor)
  {
    List<Object> gList = new List<Object>();
    Integer i = 0;
    for (String key : groupMap.keySet())
    {
      Map<String, Object> gmap = new Map<String, Object>();
      gmap.put('id', groupMap.get(key));
      gmap.put('content', key);
      gmap.put('visible', true);
      gmap.put('style', 'font-weight: bold;color:' + bgColor + ';');
      gList.add(gmap);
    }
    return gList;
  }

  private static void addGroup(String g, Map<String, Integer>groupMap)
  {
    if (!groupMap.containsKey(g))
    {
      groupMap.put(g, groupMap.size());
    }
  }

  @AuraEnabled
  public static String queryObjectData(String params)
  {
    System.debug('queryObjectData invoked...');
    Map<String, String> paramMap = (Map<String, String>)JSON.deserialize(params,   Map<String, String>.class);
    System.debug(JSON.serializePretty(paramMap));
    PSResponse resp = new PSResponse();
    Integer i = 1;

    try
    {
      //if (paramMap.containsKey('contactId'))  c.ContactId = paramMap.get('contactId');
      List<PSTimelineItem> itemList = new List<PSTimelineItem>();

      String itemType = paramMap.get('itemType');
      String sldsResourceURL = paramMap.get('sldsIconResource');

      Integer truncSize = 50;
      if (paramMap.containsKey('truncSize')) truncSize = Integer.valueOf(paramMap.get('truncSize'));

      String networkPrefix = null;
      if (paramMap.containsKey('networkPrefix')) networkPrefix = paramMap.get('networkPrefix');


      getObjectItems(itemList, paramMap.get('objectName'), paramMap.get('objectIcon'), paramMap.get('objectLabelField'),
                     paramMap.get('objectDescField'), paramMap.get('objectDateField'), paramMap.get('objectColorField'),
                     paramMap.get('objectIconField'), paramMap.get('objectEarliestDate'), itemType, networkPrefix, sldsResourceURL, truncSize);

      System.debug('itemList=' + JSON.serializePretty(itemList));

      String dataJSON = JSON.serialize(itemList, true).replaceAll('startDttm', 'start').replaceAll('endDttm', 'end');
      resp.data = dataJSON;
    }
    catch (exception e)
    {
      resp.status = PSResponse.ERROR;
      resp.msg = e.getMessage();
    }

    return  JSON.serialize(resp);
  }

  private static void getObjectItems(List<PSTimelineItem> itemList, String objectName, String icon, String labelField,
                                     String descField, String dateField, String colorField, String iconField, String earliestDate,
                                     String itemType, String networkPrefix, String sldsResourceURL, Integer truncSize)
  {
    String bgColor = null;
    String whereClause = null;

    String fieldQuery = '';
    fieldQuery = addQueryField(fieldQuery, labelField);
    fieldQuery = addQueryField(fieldQuery, descField);
    fieldQuery = addQueryField(fieldQuery, dateField);
    fieldQuery = addQueryField(fieldQuery, colorField);
    fieldQuery = addQueryField(fieldQuery, iconField);

    String queryStr = 'SELECT Id, ' + fieldQuery + ' FROM ' + objectName;

    // get earliest date if not null
    Date dt = null;
    if (earliestDate != null)
    {
      if (earliestDate.contains('/') && earliestDate.length() == 10)
      {
        dt = Date.parse(earliestDate);
      }
      else if (earliestDate.length() > 0)
      {
        Integer val = 0 - Integer.valueOf(earliestDate);
        dt = Date.today();
        dt = dt.addDays(val);
      }
    }

    if (dt != null)
    {
      whereClause = ' WHERE ' + dateField + ' >= ' + DateTime.newInstance(dt, Time.newInstance(00, 00, 00, 00)).format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    }

    if (whereClause != null) queryStr += whereClause;

    System.debug('queryStr=' + queryStr);

    List<sObject> recList = Database.query(queryStr);
    if (recList.size() > 0)
    {
      for (sObject rec : recList)
      {
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
    }
  }

  private static String addQueryField(String queryStr, String fieldName)
  {
    if (queryStr == null)
    {
      queryStr = '';
    }

    if (fieldName != null && fieldName.length() > 0)
    {
      if (queryStr.length() == 0)
      {
        queryStr = fieldName;
      }
      else
      {
        queryStr = queryStr + ', ' + fieldName;
      }
    }

    return queryStr;
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
                   + '<use xlink:href="' + sldsResourceURL + '/assets/icons/' + category + '-sprite/svg/symbols.svg#' + name + '"></use>'
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
        newStr = newStr.substring(0, length) + '...';
      }
    }
    return newStr;
  }

  @AuraEnabled
  public static Object getRuntimeContext()
  {
    try
    {
      Map<String, String> contextMap = new Map<String, String>();

      contextMap.put('userId', UserInfo.getUserId());
      contextMap.put('userType', UserInfo.getUserType());
      contextMap.put('userFirstName', UserInfo.getFirstName());
      contextMap.put('userLastName', UserInfo.getLastName());
      contextMap.put('userName', UserInfo.getUserName());
      contextMap.put('orgName', UserInfo.getOrganizationName());

      if (Network.getNetworkId() != null)
      {
        contextMap.put('networkId', Network.getNetworkId());

        Network nw = [SELECT Name, UrlPathPrefix FROM Network WHERE Id = :Network.getNetworkId() LIMIT 1];

        contextMap.put('networkName', nw.Name);
        contextMap.put('networkPrefix', '/' + nw.UrlPathPrefix);
      }

      return (contextMap);
    }
    catch (exception e)
    {
      throw new AuraHandledException(e.getMessage());
    }
  }
}