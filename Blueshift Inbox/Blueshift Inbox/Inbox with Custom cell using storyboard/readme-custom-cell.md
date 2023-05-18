## Inbox with custom cell using Storyboard

This type of inbox is created using the storyboard and thats why there is need of writing any code to present the inbox.
In order to show inbox screen using storyboard,
1 - Add a new UIViewController to your storyboard
2 - Go to Identity inspector and set the class name to `BlueshiftInboxViewController`
3 - Go to Attribute inspector and set the customisation properties like color, no messages text, activity indicator options. 
4 - To set the customn inbox layouts, you will have to set the `Inbox delegate name` property in the Attribute inspector. The `Inbox delegate name` should be set in below way - 
    <module_name>.<delegate_class_name>
    for example, for this sample inbox project, we will set this property as,
    "Blueshift_Inbox.MultipleCellsInboxDelegate""
6 - Create the class to implement the `BlueshiftInboxViewControllerDelegate`to set custom cell attributes.
    Set the variable `customCellNibNames` and provide the list of custom nib names which you want to use.
    Implement method `getCustomCellNibNameForMessage` to let SDK know which layout needs to be used by returning the xib name for given `BlueshiftInboxMessage`.
    Refer to file `MultipleCellsInboxDelegate.swift` to see the implementation. 
7 - Create a custom layout by copying the SDK's `BlueshiftInboxTableViewCell.xib`  
    in your project. Rename it to give custom name. Now you can customise the UI based on your requirement. Create assiciated class for the tableViewCell, give the same name as the custom xib name. Repeat this step for the number of custom cells you want to create.
    


