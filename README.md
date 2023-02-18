# Recipe Application

An application for mobile devices, which allows users to search for recipes using the meal's name, or the names of the ingredients they wish to use.
Application is written in Flutter and Spring. 
The database I'm using is Cloud Firestore, which is a NoSQL database. I'm also using Algolia for improved search flexibility. 
The external recipe API is provided by Spoonacular.

# Features

- add your own recipes to the database, for other people to see
- add recipes to your favorites for easy access
- add items to your personal pantry, which allows you to search for recipes using these ingredients
- add reviews to recipes, browse other people's reviews
- see profile screens of other users, which contain recipes they've added
- 4 search options, including:
  - simple search via name
  - search via name and parameters like intolerances, amount of nutrients, or time to prepare
  - search using ingredients
  - search using pantry - no need to manually type in your fridge's contents every time
