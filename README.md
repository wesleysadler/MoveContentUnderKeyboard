
## MoveContentUnderKeyboard
iOS 9 application that shows how to move text fields that are hidden by the keyboard it was written using Swift, Storyboard, Autolayout, UIScrollView.

### Description
Move Content Under Keyboard shows how to adjust the UI to display text fields that are hidden by the keyboard. The application has two tabs (UITabBar) one showing the first option given in Apple's Text Programming Guide for iOS Managing the Keyboard the second tab shows the second option given in the same guide. Keyboard notification code is designed using concepts from objc.io Swift Talk on typed notifications. The application is build in a Storyboard with autolayout with each tab containing a UIScrollView which makes the configuration a little tricky. The key to setting up UIScrollView with autolayout is getting the UIScrollView to set its size. In this application the UIScrollView contains a UIView that is pinned to each side of the container this allows the scroll view to determine its size. Also note that the size of the view changes based on the device layout (portrait vs landscape) due to the UIImageView constraints being an aspect ratio and the width constraint being a percent of a placeholder label field. The architecture of each tab is different with the first tab using MVVM (Model-View-ViewModel) with POP (Protocol-Oriented Programming) and the second tab using Massive View Controller.

The second view controller, the second tab has code to show three different ways to dismiss a keyboard.

Option 1 - using keyboardDismissMode on UIScrollView
```
scrollView.keyboardDismissMode = .onDrag
```

Option 2 - using UITapGestureRecognizer on UIView
```
let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(sender:)))
view.addGestureRecognizer(tap)

@objc func dismissKeyboard(sender: UITapGestureRecognizer) {
guard let active = activeTextField else { return }

active.resignFirstResponder()
}
```
Option 3 - UITextFieldDelegate
```
func textFieldShouldReturn(_ textField: UITextField) -> Bool {

if activeTextField === textField {
activeTextField?.resignFirstResponder()
}
return true
}
```

### References
[Apple's documentation](https://developer.apple.com/library/content/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html)
 [objc.io Swift Talk](https://talk.objc.io/episodes/S01E27-typed-notifications-part-1)
