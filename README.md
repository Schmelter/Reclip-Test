# Overview

We would like you to create a small app that allows users to browse and play a collection of featured reclip videos.

You have one week to finish this project. The time you'll need to spend at a keyboard is approximately 5 - 8 hours.

To be clear, we do _not_ want you spending more than 8 hours on the project. If there are things about your implementation that you'd change given more time, you can describe them in the "notes" section below.

# Instructions

## Step 1: Clone the starter project

_Estimated working time: 5 min_

Clone this repo. It contains a starter project that you can build upon. 

The starter project includes: 
- Scaffolding.
- The info that you'll need to use the "featured feed" API.
- Custom font assets and their definitions.
- Several UI helpers that might come in handy.

Feel free to discard or modify any of the existing code if you'd prefer to write it another way. 

## Step 2: Make your changes

_Estimated working time: 4 - 7 hours_

Update the starter project to meet the following requirements:
- All views must be implemented in code using either SwiftUI or UIKit - no xibs or storyboards.
- The app should fetch the latest videos from the "featured feed" API on every launch.
- The "featured feed" API might return duplicates of the same video. The app should filter out these duplicates.
- A loading view has been provided for you (`LoadingViewController.swift`). This view should be shown while waiting for the "featured feed" request to finish.
- On success, a vertically-scrolling list of the videos in the feed should be shown. Each video's view should fill the screen and match the design specified [here](https://www.figma.com/file/qa80b092KKh1C5Zk7m3jaw/Interview-Project?node-id=342%3A2).
- The user should be able to navigate between videos in the feed by scrolling vertically. This navigation does not need to loop (scrolling up from the last video in the feed does not need to take you back to the first video in the feed).
- Tapping the visible video should toggle playback.
- If the user navigates away from the video while playing, it should be paused automatically.
- While the video is playing, the `ProgressBar`'s playhead and progress indicator should both advance to match the video's relative playback position.
- Dragging the playhead left or right should update the video's playback time.
- Each video's playback progress should be persisted locally between app launches. If the user returns to an unfinished video, playback should resume at the last-viewed playback time.
- The featured feed scene's functionality should be implemented using an MVVM pattern, and the view model should be fully unit-tested.

When you're finished, open a pull request with your changes.

## Step 3: Respond to feedback via a phone interview

_Estimated working time: 30 minutes_

Once your PR's been opened, we'll review your code and schedule a call to discuss any comments


# Grading Criteria (from Highest to Lowest Priority)

- Does the application do what it is supposed to do? In other words, does it satisfy the list of requirements?
- Does the implemented interface match the designs?
- Is the application bug-free?
  - Is it free from memory leaks?
  - Is it free from potential crashes?
  - Is the UI always responsive?
  - Is thread-safety considered?
- Is the application free from compilation warnings?
- Is the code clean?
  - Is the code separated into logical parts?
  - Is the style consistent?
  - Do names make sense?
  - Is the code maintainable and easy to read?
  - Has unused code been deleted?

# Notes

> This is your space to add any info that you'd like us to know about your solution.
