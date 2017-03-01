# HPHangman
A game of Hangman for muggles, witches, and wizards alike!

![Welcome Screen](https://github.com/bmanjuu/HPHangman/blob/master/HPHangmanWelcomeScreen.png)   ![Gameplay](https://github.com/bmanjuu/HPHangman/blob/master/HPHangmangGameScreen.png)

## Requirements
This game is an iOS app that requires iOS 10.2+ to run. 

## Installation
Download this project and run using the latest version of Xcode.

## Technical Highlights
* Realm 
* AVFoundation
* Xcode 8.2.1 
* Written in Swift 3.0  

## Description
The user is tasked with saving Harry Potter from Lord Voldemort in playing this magically-themed version of Hangman. 

In this game, the user is presented with a concealed word (indicated by a series of underscores), an image of Harry in a duel with a few Deatheaters, and information regarding the number of incorrect guesses they've made, the letters they've guessed incorrectly so far, and the balance that they currently have in their Gringott's bank account. 

During the game, the user can either guess a letter or a word for each turn. The user also has an option to buy a letter should their Gringott's balance allows for it. With each incorrect guess, the image of Harry in battle loses its opacity and the user loses a chance or "spell". After 6 incorrect guesses, the image is completely transparent and the user loses the game. 

Upon winning the game, the user is awarded money from the Ministry of Magic based on the number of incorrect guesses they've made. The amount is shown in the final view of the game and directly reflected in their Gringott's account balance at the start of the next game. The user does not lose money from their Gringott's account upon losing a game, but the final screen will still show their current balance for reference. 

At the end of each game, the user has an option to restart the game and engage in an another epic duel. Based on the game result, the difficulty of words in their next game will increase or decrease a level. There are 10 levels total, and the user starts their first game at level 1. 

Music is present throughout the game to provide a more immersive experience.

## Author
Betty Fung

## Acknowledgements
* Images were obtained from the [Harry Potter Wiki](http://harrypotter.wikia.com/wiki/Main_Page)
* Music was obtained from YouTube's Audio Library 
  * Arcadia - Wonders by Kevin MacLeod is licensed under a Creative Commons Attribution license (https://creativecommons.org/licenses/by/4.0/)
    * Source: http://incompetech.com/music/royalty-free/index.html?isrc=USUAN1100326
    * Artist: http://incompetech.com/
  * Black Vortex - Scoring Action by Kevin MacLeod is licensed under a Creative Commons Attribution license (https://creativecommons.org/licenses/by/4.0/)
    * Source: http://incompetech.com/music/royalty-free/index.html?isrc=USUAN1300037
    * Artist: http://incompetech.com/
  * Crisis - Scoring Action by Kevin MacLeod is licensed under a Creative Commons Attribution license (https://creativecommons.org/licenses/by/4.0/)
    * Source: http://incompetech.com/music/royalty-free/index.html?isrc=USUAN1100277
    * Artist: http://incompetech.com/
  * Pooka by Kevin MacLeod (no credit description available) 
* App Icon was made by Madebyoliver from www.flaticon.com 
* LinkedIn, for the opportunity and inspiration to create this game! :)
