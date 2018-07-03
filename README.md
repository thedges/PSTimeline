# PSTimeline
Timeline components based on [VisJS Timeline](http://visjs.org/docs/timeline/#Overview) to show record activity such as chatter posts, document uploads, tasks, events, case comments, and records on child objects. Primary use cases could be around health care, social services, case history, etc... basically anything you want to show sequence of 'events' and visual reference to time.

There are two primary components in this package:
  1. <b>PSTimeline (Record)</b> - a component to help show all the activity that occurred for a record. Use this component when you want to show 'events' for a specific record. You can configure to show chatter posts, document uploads, tasks, events, case comments, and records on child objects.
  2. <b>PSTimeline (Object)</b> - a component to help show all records that occurred for a specific object. You would typically use use this component on a Home page or dashboard type page where you are showing all records for a given object.

## PSTimeline (Record)
![alt text](https://github.com/thedges/PSTimeline/blob/master/PSTimeline.gif "Sample Image")


<b>Some options of the component:</b>
  * Drag left and right on the timeline to slide to different dates
  * Scroll up/down on mouse to zoom in/out of timeline window
  * Double click on item to load the associated record
  * Ability to move to specific date in timeline
  * Grouping of activities in to buckets/swimlanes
  * Control icon in top-right of component:
    -  <img src="https://github.com/thedges/PSTimeline/blob/master/PSTimelineCenter.png" height="20" width="20"/> Click to recenter timeline on current day/time
    -  <img src="https://github.com/thedges/PSTimeline/blob/master/PSTimelineCalendar.png" height="20" width="20"/> Click to select a specific date to move to
    -  <img src="https://github.com/thedges/PSTimeline/blob/master/PSTimelineFit.png" height="15" width="20"/> Click to fit all items within the timeline
    -  <img src="https://github.com/thedges/PSTimeline/blob/master/PSTimelineGroup.png" height="15" width="20"/> Click to toggle grouping of records
    -  <img src="https://github.com/thedges/PSTimeline/blob/master/PSTimelineRefresh.png" height="20" width="20"/> Click to perform a full data refresh and plot on timeline

  
<b>This Lightning component is very configurable with following options:</b>

   - <b>Item Type</b> - item type to show in timeline (box or range)
   - <b>SLDS Icon Static Resource Reference</b> - reference to static resource file that stores the SLDS icons (default is "/resource/SLDS261")
   - <b>Minimum Height</b> - the minimum height of component; leave blank to not set limit
   - <b>Maximum Height</b> - the maximum height of component; leave blank to not set limit
   - <b>Days Before</b> - the number of days in past to show on initial timeline
   - <b>Days After</b> - the number of days in future to show on initial timeline

   - <b>Navigate to new window</b> - boolean to navigate to new window on item double-click or stay in current window
   - <b>Show Hover</b> - boolean to determine if hover details will show when you hover over an item 
   - <b>Truncation Size</b> - the max size of any label strings before truncation occurs

   - <b>Show Activities</b> - boolean to show activities (tasks, events, emails, calls)
   - <b>Task Icon</b> - the icon to show for tasks (default: "standard:task")
   - <b>Event Icon</b> - the icon to show for events (default: "standard:event")
   - <b>Email Icon</b> - the icon to show for email (default: "standard:email")
   - <b>Call Icon</b> - the icon to show for calls (default: "standard:call")

   - <b>Show Chatter Posts</b> - boolean to show chatter text posts
   - <b>Chatter Icon</b> - the icon to show for chatter text posts (default: "standard:post")

   - <b>Show Content Uploads (files)</b> - boolean to show content uploads (i.e. Chatter files) 
   - <b>Content Icon</b> - the icon to show for content (default: "standard:file")

   - <b>Show Case Comments</b> - boolean to show case comments
   - <b>Case Comment Icon</b> - the icon to show for case comments (default: "custom:custom19")
   
   - <b>Show Case Milestones</b> - boolean to show case milestones
   - <b>Case Comment Icon</b> - the icon to show for case comments (default: "standard:case_milestone")
   
   - <b>Show Case Articles</b> - boolean to show knowledge articles attached to cases
   - <b>Case Article Icon</b> - the icon to show for case articles (default: "standard:knowledge")

The component supports ability to show child records for up to 5 related child objects. Configuration options are:

   - <b>Show Child Records</b> - boolean to show this child records
   - <b>Child Icon</b> - the icon to show for this child
   - <b>Child Object</b> - the sObject API name for this child 
   - <b>Child Parent Field</b> - the sObject Field API name that contains the lookup/master-detail to the parent record 
   - <b>Child Label Field</b> - the sObject Field API name that contains the label to show in the timeline item 
   - <b>Child Date Field</b> - the sObject Field API name that contains the date or date/time field to plot on timeline   
   

## PSTimeline (Object)
<img src="https://github.com/thedges/PSTimeline/blob/master/PSTimelineObject.gif" height="600px" width="800px"></img>

<b>Similar to above, options of the component:</b>
  * Drag left and right on the timeline to slide to different dates
  * Scroll up/down on mouse to zoom in/out of timeline window
  * Double click on item to load the associated record
  * Ability to move to specific date in timeline
  * Grouping of activities in to buckets/swimlanes
  * Control icon in top-right of component:
    -  <img src="https://github.com/thedges/PSTimeline/blob/master/PSTimelineCenter.png" height="20" width="20"/> Click to recenter timeline on current day/time
    -  <img src="https://github.com/thedges/PSTimeline/blob/master/PSTimelineCalendar.png" height="20" width="20"/> Click to select a specific date to move to
    -  <img src="https://github.com/thedges/PSTimeline/blob/master/PSTimelineFit.png" height="15" width="20"/> Click to fit all items within the timeline
    -  <img src="https://github.com/thedges/PSTimeline/blob/master/PSTimelineGroup.png" height="15" width="20"/> Click to toggle grouping of records
    -  <img src="https://github.com/thedges/PSTimeline/blob/master/PSTimelineRefresh.png" height="20" width="20"/> Click to perform a full data refresh and plot on timeline
    -  <img src="https://github.com/thedges/PSTimeline/blob/master/PSTimelineFilter.png" height="20" width="20"/> Click to get pop-up window to allow dynamic filtering of records 
    
<b>This Lightning component is very configurable with following options:</b>

   - <b>Item Type</b> - item type to show in timeline (box or range)
   - <b>SLDS Icon Static Resource Reference</b> - reference to static resource file that stores the SLDS icons (default is "/resource/SLDS261")
   - <b>Minimum Height</b> - the minimum height of component; leave blank to not set limit
   - <b>Maximum Height</b> - the maximum height of component; leave blank to not set limit
   - <b>Days Before</b> - the number of days in past to show on initial timeline
   - <b>Days After</b> - the number of days in future to show on initial timeline

   - <b>Navigate to new window</b> - boolean to navigate to new window on item double-click or stay in current window
   - <b>Show Hover</b> - boolean to determine if hover details will show when you hover over an item 
   - <b>Show filter section</b> - boolean to show filter section on initial view

   - <b>API Name of Object</b> - the API name of object to plot records on timeline
   - <b>Filter Fields</b> - a CSV list of field API names to show in filter section (see Filter Fields section below for advanced syntax)
   - <b>Filter Operation</b> - logic for all filter fields applied during soql query; either 'AND' or 'OR'
   - <b>Object Icon</b> - the default icon to show for this object
   - <b>Object Label Field</b> - the sObject field API name that contains the label to show in the timeline item 
   - <b>Object Details Field</b> - the sObject field API name that contains the text or HTML details to show when hover over item (see Formula Fields section below for advanced formula options)
   - <b>Object Date Field</b> - the sObject field API name that contains the date/time field to plot on timeline  
   - <b>Object Icon Field</b> - the sObject field API name that contains icon to show for specific records; this is override field where you can set the specific icon to use for each record based on a formula field (see Formula Fields below for details) 
   - <b>Object Color Field</b> - the sObject field API name that contains color definition to paint background color for item on time (see below for details)
   - <b>Object Grouping</b> - boolean to set if grouping of records in to buckets/swimlanes
   - <b>Object Grouping Field</b> - the sObject field that contains the grouping (i.e. some text value) for each record; this could be a Picklist field or a formula field where you define custom groupings to your need
   - <b>Past Date Limit</b> - used to provide how far in past to look for records to help with performance; options are number of days or date in past to limit object search (enter either 1. positive integer or 2. MM/DD/YYYY)"
   - <b>SOQL LIMIT</b> - an integer value to limit the number of records pulled; use this if your data set is very large; suggest testing for demos around limit of 500 or so; the SOQL query that runs pulls records in descending date order so you get recent records

 
### Icons 
For any icon values provided in the component configuration, you have 3 options:
   1. Use a reference to one of the Lightning design icons defined [here](http://www.lightningdesignsystem.com/icons/). The format of the configuration string is <category>:<name>. So for the first icon in the Action category, the configuration property would be "action:add_contact". For account icon down in the Standard category section, the configuration property would be "standard:account". The component is preconfigured using this approach.
   2. Upload your own static resource file of images you want and reference normal way of "/resource/<image_name>"
   3. Lastly is providing a full http/https URL to an image stored on some remote server

### Filter Fields 
In the PSTimeline (Object) component you can provide a comma-separated-list (CSV) of sObject Field API names to provide filtering capabilities. The component will parse the CSV list and build a pop-up window with filtering options (text box, drop-down lists, etc...). In simplest form, you can enter simple CSV value like

  `Subject,Type,Status,CustomField__c`
  
But you can also provide some more advanced options to each field if needed. The format is '<fieldAPIName>|{option:value,option:value}'. For example, lets say you want to override the standard label for the Type field and provide a default value of 'New'. Your CSV format would look like
  
  `Subject,Type|{'label':'Case Type','value':'New'},Status,CustomField__c`
  
or let's say you want to also enable default wildcard capability (i.e. wrap any text with % chars) for a text field like 'Subject', your string format would be 

  `Subject|{'wildcard':'true'},Type|{'label':'Case Type','value':'New'},Status,CustomField__c`

### Formula Fields 
Remember that you can use formula fields anywhere in the configuration properties where you need to provide a field API name for options like item color, item hover details, item label or item grouping. So for color, you can have a formula field like following to show different background colors for items:

  `CASE(Status,
  "New", "#d9d9d9",
  "Working", "#ccebff",
  "Escalated", "#ffb3b3",
  "Closed", "#adebad",
  "#d9d9d9")`
  
Or show different item icon with formula field like following:

  `LEFT($Api.Partner_Server_URL_260, FIND( '/services', $Api.Partner_Server_URL_260)) & 
    CASE( Type, 
    "Animal Control", "resource/CaseType/OneCityAnimalInactive.png", 
    "Events", "resource/CaseType/OneCityEventsInactive.png", 
    "General Inquiry", "resource/CaseType/OneCityGeneralInactive.png", 
    "Licensing and Permitting", "resource/CaseType/OneCityPermitInactive.png", 
    "Noise", "resource/CaseType/OneCityNoiseInactive.png", 
    "Public Works", "resource/CaseType/OneCityPublicWorksInactive.png", 
    "Street and Traffic", "resource/CaseType/OneCityStreetInactive.png", 
    "resource/CaseType/OneCityNoTypeInactive.png")`
    
And lastly for item hover details, you can have a formula field that has embedded HTML tags to format your hover pop-up as you like:

  `'<h3>Subject + '</h3>' + 
  '<table><tr><td valign="top" style="padding-right: 10px">' + 
  '</td><td>' + 
  '<br/><b>Type:</b> ' + TEXT(Type) + 
  '<br/><b>Status:</b> ' + TEXT(Status) + 
  '<br/><b>Priority:</b> ' + TEXT(Priority) + 
  '</td></tr></table>'`

<b>Dependency:</b> Install the [LightningStrike.io](https://github.com/thedges/Lightning-Strike) and [PSCommon](https://github.com/thedges/PSCommon) packages first

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>
