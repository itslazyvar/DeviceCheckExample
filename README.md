# DeviceCheck Example
This is a companion repo to the ["Hidden Gems: Using DeviceCheck to Prevent Abuse and Misuse"](https://swiftydb.gale.li/posts/hg-devicecheck/) article on Swifty D.B.

The repo has an example app and an accompanying NodeJS server that you can use to play around with. 


## Steps to prepare

1. Set a unique bundle ID in Xcode and register this bundle ID with Apple at https://developer.apple.com/account/resources/identifiers/list/bundleId, if you don't you will get token related errors
2. Generate and download an authentication key at https://developer.apple.com/account/resources/authkeys/list, tick the DeviceCheck tickbox and make note of the Key ID, you're going to need it in a future step
3. Place the downloaded authentication key in the same folder as `NodeJSExampleServer.js`
4. Fill in `devAccountTeamID`, `authKey` and `authKeyID` variables in `NodeJSExampleServer.js` with your authentication key details. Developer account Team ID can be found at https://developer.apple.com/account
5. Fill in `primaryHost` variable in `DCheck.swift` with the IP-address or URL + port number, e.g. `"http://10.0.0.10:9889"`, `"http://exampleserver.com:9889"`
6. Run `npm install1` to install dependencies from `package.json`
7. Run `node NodeJSExampleServer.js` to get the server up and running
8. Select a connected physical device in Xcode as run destination and run the app

## References & Documentation
Apple documention on DeviceCheck: https://developer.apple.com/documentation/devicecheck

Apple WWDC17 session about DeviceCheck: https://devstreaming-cdn.apple.com/videos/wwdc/2017/702lyr2y2j09fro222/702/702_hd_privacy_and_your_apps.mp4
This session ("Privacy and Your Apps", Session 702) is unlisted from Apple's website, DeviceCheck part starts around 24 minute mark.

Apple WWDC21 Session 10110, "Safeguard your accounts, promotions, and content": https://developer.apple.com/videos/play/wwdc2021/10110/

Apple WWDC21 Session 10244, "Mitigate fraud with App Attest and DeviceCheck": https://developer.apple.com/videos/play/wwdc2021/10244/)

## Acknowledgements

Huge thanks to Tim Colla from Marino Software. His [blog post](https://www.marinosoftware.com/insights/how-to-prevent-fraud-without-compromising-user-privacy-devicecheck-on-ios-11) made me aware of DeviceCheck in the first place and [their repo](https://github.com/marinosoftware/DeviceCheckSample) got me up and running. Some of that code made it's way into this repo either in modified form or other ways, wherever applicable [this license](Acknowledgements/LICENSE.marinosoftware) applies to that code.