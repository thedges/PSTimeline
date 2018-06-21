# PSTimeline
Timeline component based on [VisJS Timeline](http://visjs.org/docs/timeline/#Overview) to show record activity such as chatter posts, document uploads, tasks, events, case comments, and records on child objects. Basically a component to help show all the activity that occurred for a record. Use cases could be around health care, social services, case history, etc... 

![alt text](https://github.com/thedges/PSTimeline/blob/master/PSTimeline.gif "Sample Image")

<b>Some options of the component:</b>
  * Drag left and right on the timeline to slide to different dates
  * Scroll up/down on mouse to zoom in/out of timeline window
  * Click the icon in upper-right to recenter timeline back on current day
  * Click the icon in upper-left to fit all items within the timeline
  * Double click on item to load the associated record
  
  
<b>This Lightning component is very configurable with following options:</b>

   - <b>Navigate to new window</b> - navigate to new window on item double-click or stay in current window
   - <b>Item Type</b> - item type to show in timeline (box or range)
   - <b>SLDS Icon Static Resource Reference</b> - reference to static resource file that stores the SLDS icons (default is "/resource/SLDS261")
   - <b>Minimum Height</b> - the minimum height of component; leave blank to not set limit
   - <b>Maximum Height</b> - the maximum height of component; leave blank to not set limit
   - <b>Days Before</b> - the number of days in past to show on initial timeline
   - <b>Days After</b> - the number of days in future to show on initial timeline
   - <b>Truncation Size</b> - the max size of any label strings before truncation occurs
   - <b>Show Tooltips</b> - boolean to determine if tooltips will show when you hover over an item 

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

The component supports ability to child records for up to 5 related child objects. Configuration options are:

   - <b>Show Child Records</b> - boolean to show this child records
   - <b>Child Icon</b> - the icon to show for this child
   - <b>Child Object</b> - the sObject API name for this child 
   - <b>Child Parent Field</b> - the sObject Field API name that contains the lookup/master-detail to the parent record 
   - <b>Child Label Field</b> - the sObject Field API name that contains the label to show in the timeline item 
   - <b>Child Date Field</b> - the sObject Field API name that contains the date or date/time field to plot on timeline  

<b>NOTE:</b> For any icon values provided in the component configuration, you have 3 options:
   1. Use a reference to one of the Lightning design icons defined [here](http://www.lightningdesignsystem.com/icons/). The format of the configuration string is <category>:<name>. So for the first icon in the Action category, the configuration property would be "action:add_contact". For account icon down in the Standard category section, the configuration property would be "standard:account". The component is preconfigured using this approach.
   2. Upload your own static resource file of images you want and reference normal way of "/resource/<image_name>"
   3. Lastly is providing a full http/https URL to an image stored on some remote server

<b>Dependency:</b> Install the [LightningStrike.io](https://github.com/thedges/Lightning-Strike) and [PSCommon](https://github.com/thedges/PSCommon) packages first

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>
