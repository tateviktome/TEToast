# TEToast
TEToast is a fully customizable ToastView written in swift with very simple interface.

## Features
1. In general, supports title, comment and an image
2. Ability to choose position of the view` center, top or bottom
3. (V1) Ability to apply appearance (cornerRadius, fonts, colors and etc.)

## Example
```swift
let toast = TEToastView(title: "Hello November", comment: "My favorite season...")
toast.present()
```
> Makes a ToastView in the center of screen with title and comment...
> Simple enough? 🙃

## Version 2 available (No more frame-based 😈)
```swift
let toast = TEToastViewV2(image: nil, title: "Hello Spring", comment: "Lovely and kind season...", position: .boundary(position: .bottom, inset: 10.0))
toast.present(inSuperview: self.view)
```
> Makes a ToastView in the bottom of screen(inset of 10.0) with title and comment...
> Simplicity is the ultimate sophistication 🤓
