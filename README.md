# Uplift-Alpha-Travel-Planning-App
We created a travel planning iOS app for people with disabilities: best user experience for iPhone 14 and iPhone 14 Pro Max. Watch Youtube Video Now for App Walkthrough.
Created by: Team Uplift Alpha (Eric, George, Mohammed, Sam, Kerri) MVP Product. 

Here is a quick reference guide and short description of the features. 

1. Login

We implemented logging in using a seperate ViewController and 
linking our app to Firebase. If the user does not already have an account, 
then can create one by providng their name, email, and a desired username 
and password. 

2. Favorites

As a part of our home page, we have a collection view which displays a list of favorite locations that 
the user can add their most fun or memorable places to. 

3. Profile Tracking

While signed in, we keep track of all of the user's login information, including how many reviews they 
have created. This can be viewed in the profile tab, with the option of logging out whenever convenient.

4. Adding Reviews

We programmatically created a ViewController which allowed users to score each location on a 
scale of 1-100 in 3 areas: Mobility Accessibility, Sensory Perceptions, and Neurological 
Comfort. We did this using sliders. The users could leave a text review as well. 

5. Saving Reviews

We saved all reviews directly to Firebase. All of the review scores and scroll views 
update in real time. 

6. Displaying Reviews

We display the average score of each of the three categories into three custom widgets 
whose color dynamically changes with the percentile score. Directly below the three 
functional buttons, their is also a scroll view which gets populated with any text reviews 
which users leave the location. 

7. Functional Buttons

We built in the ability for users to do three interactive things once they 
had selected a location, all from right within the app:
(1) Visit the website of the location
(2) Launch directions to that location using Apple Maps
(3) Call the location directly on the phone

8. Look Around

We used Apple's Look Around feature which was rolled out in 2019 to offer users the ability 
to get a 3D look around their location of choice. Note that this feature is not available 
in STL yet, but it is very possible to test in San Francisco. 

9. Search

We added a search bar which allows users to find the locations of unknown 
places near them. The more specific the query, the more specific the 
response. 

10. Screen Reader Support

We added custom descriptions for every UIView, UILabel, UIButton, and other relevant components in our app 
to interface directly with iOS' native screen reader. Working to 
adequately address and prioritize accessibility throughout the app. 
