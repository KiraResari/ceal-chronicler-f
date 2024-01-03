# 2-Jan-2024

* Now continuing with this
* I created this project last year, and have since spent the better part of a year working with Flutter at work, so I don't know how much of what I created in this project I'm actually willing to re-use, since a lot of it looks like garbage now
  * For instance, I think the events are not actually needed if I build a good architecture
* I think before I go up and at it, it makes sense to now flesh out the concept and architectural design of this
  * Last year, what I created I did as part of a learning project to help me learn flutter, so I winged a lot of stuff
  * But now I think I need a better idea of where I'm going with this

## Concept Phase

* So, here's me trying to flush out the requirements
  * I now wrote together what I want for the first version at the bottom under [User Story](#user-story)
  * The biggest two additions are the time bar, as well as the technical functionalities, which include loading, saving un- and re-do
  * Especially the latter two have significant implications for my design, since they pretty much mandate that I use the command pattern
    * I *think* I should be able to get that to work without the need for an event bus
  * Also, it probably makes sense to start with the time bar, and move on to the characters from there
  * We probably don't need a start screen anymore though
  * Oh, and I also need to give routing a thought
    * Basically, I want the app to navigate like a website, since I can already foresee nonlinear paths at this point
      * For example, you could open a character from the characters overview, and then navigate from there to an item, or you could open an item from the items overview and then navigate from there to the character
* Add all that up, and I think you arrive at a big, fat "start over from scratch"
  * Well, maybe not *quite* everything needs to be re-done, but most of it
* Okay, now I have an idea of what I want, as well as a general angle of approach

## Development Phase

* My first goal is going to be to have a screen that contains only the time bar with a single point in time
* For starters, I am going to leave the old bits in place and then remove them as they become obsolete
* Okay, turns out already that is giving me some really weird problems
  * All I did was try to create a simple screen with two placeholders and a background color, but I didn't manage to make it get the background color from the theme, in spite of that being supposed to work like that
  * Maybe this will help?
    * https://stackoverflow.com/questions/57666495/flutter-app-theme-ofcontext-style-doesnt-work-on-text
* Well, this is as far as I'm getting with this today

# 3-Jan-2024

* Now continuing with this

* Last time, I ended with that strange bug with the background colors

  * The post I read on stack overflow did shed some light on it, and it makes sense that this has to do with the background color being set in a context that is not yet active, and yet...

  * ...it feels somewhat strange since I think that same thing worked in the sample project

  * Maybe it has to do with stateful and stateless widgets?

  * Let me try this with a fresh project to see

    * In there, it works as expected, even if I do it the same way

    * The difference seems to be that the new project uses a newer flutter version, which is also something I wanted to do for the Ceal Chronicler, so let's try migrating up and see if that helps 

      * Nah, didn't help, but I'll still keep it since I wanted to migrate to the new version anyways

    * There are still some differences in how the theme data is set, so maybe that holds the key

      * Yes, that looks good

      * So, if I set the theme like that then it works:

        * ````dart
              var themeData = ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
              );
              return MaterialApp(
                title: title,
                theme: themeData,
                home: const MainBody(),
              );
          ````

* Right, so next, I'm gonna continue working on the time bar

  * The basic idea is that I have an ordered list of points in time, can add to or remove from that list (up to a minimum of 1 point in time), and can rename the points in time
  * So the very basic object here is the `PointInTime`, which has only a name
    * We can use the name as the identifier, since we defined that the name of points in time has to be unique

  * We need something to hold all points in time, which I am going to name `PointInTimeRepository`
    * ...thus coining the convention for this project that all classes that are responsible for holding data objects are called repositories


# User Story

As a Game Designer and Author, I want a tool to help me keep track of characters, events, items, knowledge, locations, affiliations and other things that can change over the course of a story. For example, I want to be able to go back and forth in time to figure out who learned what at what time, or who was where at what time and with whom.

## Acceptance Criteria

### Time Bar

- [ ] All screens have a time bar at the top, which allows going back and forth in time
- [ ] By default, there is only one point in time 
- [ ] Points in time can be given names
  - [ ] These names have to be unique
- [ ] Points in time can be added before or after any other point in time
- [ ] Points in time can be deleted only, if no event happens at that point in time
  - [ ] If an event happens at a certain point in time and someone attempts to delete that point is time, a message appears stating which events prevent the deletion of that point in time
  - [ ] If there is only a single point in time, that point in time can't be deleted
- [ ] Points in time can't be re-ordered

### Characters Overview

- [ ] Contains an overview of all characters that exists at the current point in time
- [ ] Allows creating new characters
- [ ] Allows deleting existing characters

### Character View

- [ ] There is character screen which displays all the information related to a character at a given time
- [ ] The character screen has the following editable fields:
  - [ ] First Appearance
    - [ ] By default contains the point in time at which the character was created
    - [ ] Can be edited to other points in time, but not to a point in time that is later than Stage Out (if that is filled)
    - [ ] Allows jumping to that point in time
  - [ ] Stage Out
    - [ ] Is empty by default
    - [ ] Can hold points in time, including the first appearance, but not before that
    - [ ] Points in time can be selected from a menu (e.g. dropdown)
    - [ ] Allows jumping to that point in time
  - [ ] Name 
- [ ] Editing a field causes the contents to change from that point in time onward, until it is edited again
  - [ ] The exception is Stage Out, which is always the same at all points in time 

### Technical

- [ ] A chronicle can be saved to a file
- [ ] A chronicle can be loaded from a file
- [ ] Actions can be undone
- [ ] Actions can be re-done
- [ ] You can navigate back to the last visited view
- [ ] You can navigate forward, which undoes navigating backwards