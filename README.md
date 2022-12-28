![Design sem nome (1)](https://user-images.githubusercontent.com/52421538/209866895-05bc6a65-bc81-4dce-88d2-5e7281993c2c.png)

> Status: Developing ⚠️

### This is an e-commerce application in flutter, using FIrebase for real-time authentication and data persistence with a NoSQL database hosted in the cloud.
# Getting Started

## Some fields in Authentication model is:
  + token
  + email
  + userId
  + expiryDate
  + logoutTimer
  
## class that extend ChangeNotifier to state Provider:
  + Auth
  + Cart
  + Order_list
  + Product
  + Product_list
  
## In addition to CRUD, I implement other features such as:
 + _authenticate()
 + signup()
 + login()
 + tryAutoLogin()
 + logout()
 + _clearLogoutTimer()
 + _autoLogout()
 + toggleFavorite()
 
 ## Tecnologies Used:
 
 <table>
  <tr>
    <td>Flutter</td>
    <td>Dart</td>
    <td>Android SDK</td>
  </tr>
  <tr>
    <td>stable, 3.3.7</td>
    <td>2.18.4</td>
    <td>33.0.0</td>
  </tr>
 </table>
 
 ## Dependencies Used:
  
  <table>
  <tr>
    <td>Provider</td>
    <td>Intl</td>
    <td>Http</td>
    <td>shared_preferences</td>
  </tr>
  <tr>
    <td>^6.0.4</td>
    <td>^0.17.0</td>
    <td>^0.13.5</td>
    <td>^2.0.15</td>
  </tr>
 </table>
 
 ## running the application:
  ### if (this is your first time using flutter first follow these steps):
  1. install flutter sdk - <https://docs.flutter.dev/get-started/install>
  2. install android developer - <https://developer.android.com/studio>
  ### else:
  1. run `git clone https://github.com/LuizRoberto18/shop_app`
  2. run `flutter pub get`
  3. run `flutter run`
 
