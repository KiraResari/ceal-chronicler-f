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

  * I now managed to get to the point where I can display a single point in time

* Next, I want to implement a scrollable list of points in time

  * There, the main issue seems to be getting it scrollable

  * While scrolling works on Android, it does not work on Windows & Chrome, and the scroll bar stays locked in one place

  * I now managed to get it to work like this:

    * ````dart
        Widget _buildTimeBar(BuildContext context) {
          List<PointInTime> points = context.watch<TimeBarController>().pointsInTime;
          ScrollController controller = ScrollController();
        
          return Scrollbar(
            controller: controller,
            child: SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    points.map((point) => TimeBarPanel(pointInTime: point)).toList(),
              ),
            ),
          );
      ````

* Right, so now we have a list of dummy points in a scrollable list

* Next, I want to add the functionality to add additional points in time

  * I could add that functionality into the `TimeBarPanel`, or between them
  * I think between would look cleaner, but it would require additional thought
    * Each button would  have to know its position relative to the existing panels, which is possible
    * However, I think I'd better experiment a bit with the options I have for adding new elements into the `List<PointInTime>`
      * I now did that, and I think from that I have a good idea of how to implement this

  * So, what I want is to add the buttons in between, and I just added functionality to the `PointInTimeRepository` that it can add new points in time based on an index
  * Alright, that now works! Awesome!
  * We can probably still tweak the style a bit, but that the functionality works is already pretty rad!
  * Aaaand, now I also improved their style, which means I am quite happy with what I got here now

* This is as far as I'm getting with this today

# 4-Jan-2024

* Now continuing with this
* Now that adding points in time works, I want to add the functionality to delete points in time, as long as more than one remains
  * One interesting problem I am running into here is trying to make the `TimeBarPanel` the exact same color as the `FloatingActionButton`s
    * The documentations that I read say something that sounds reasonable, but doesn't hold up when I try it out
    * Okay, I had to take a deep dive, and eventually found out that the color used for buttons is `theme.colorScheme.primaryContainer`
  * Now, the primary decision here is whether I want these buttons to be part of the `TimeBarPanel`, or below it
  * Each time bar panel will have two buttons that are associated directly with it: Delete and Rename, so I think it makes sense to have these buttons be part of the panel logically, even if they are visually located, say, below it
  * I now managed to get this to work
* Okay, next I want to get re-naming of points in time to work
  * I am making good progress with this, but still want to tweak it a little
  * Basically, I still want to do two things:
    * The text field in the editing popup should contain the current name by default
      * I now got that to work
    * If the input in the editing popup is invalid, the popup should disable the confirm button and show an error

# 6-Jan-2024

* Now continuing with this
* Last time I got stuck trying to improve the renaming dialog
  * I'd like for it to function like this:
    * While typing, it should validate the input and if the input is not valid, it should disable the confirm button and display a respective warning text
    * The input is invalid when:
      * It is the same as the original name
      * It is empty
      * The name is already taken
        * For this last one, the renaming dialog needs to access the  `PointInTimeRepository`
  * The complication here is that this leaves me with having to supply both the `TextEditingController` as well as the `RenamePointInTimeAlertDialogController` to the `ChangeNotifierProvider`, and that doesn't seem to be supported
  * I now managed to basically get this to work by putting the `TextEditingController` inside the `RenamePointInTimeAlertDialogController`, but now I have the issue that changes in the text field do not trigger a re-evaluation
  * With some help from ChatGPT, I now got this to work
  
* Now trying to get the background of the icon transparent, which is apparently also difficult

  * I now added a feature request for this here:

    * https://github.com/fluttercommunity/flutter_launcher_icons/issues/535

  * Well, I did manage to get the icon transparent now on my home screen, and what I did to do that was:

    * In the `android/app/src/main/AndroidManifest.xml`, reverted the `android:icon` entry back to this:

      * ````
           <application
                android:label="Ceal Chronicler F"
                android:name="${applicationName}"
                android:icon="@mipmap/ic_launcher">
        ````

    * Removed a lot of files that flutter_launcher_icons added

* This is as far as I'm getting with this now

# 24-Jan-2024

* Now continuing with this

* Okay, currently the program does not have much, but I think what it does have is still enough already that I should now tackle the structural issues of undo- and redo logic, along with saving and loading, since this is going to affect a lot of things

* I'll start with undo-redo legic

  * This is already quite a problem

  * The theory is simple: By applying the command pattern, I can keep a stack of executed commands that one can navigate back and forth across

  * The question is: How do I apply that, especially if I want to avoid using an `EventBus`?

  * Let me try to illustrate the issue with a simple use case for creating a new point in time, and then undoing it

    * Presently, creating a new point in time is done via clicking the `AddPointInTimeButton`, which calls a method in the `TimeBarController`, which in turn calls a method in the `PointInTimeRepository` and then notifies its listeners so that the `TimeBar` gets updated
      * It would be no problem to rewrite this logic so that the `TimeBarController` creates a command and hands it to some sort of `CommandController`, which in turn keeps track of the executed commands and forwards it to the `PointInTimeRepository`
    * Undoing that action would involve clicking on an `UndoButton` in some sort of `Toolbar`, which would then trigger an action in the `ToolbarController`
      * That action could then trigger an undo from the `CommandController`, which takes care of everything beyond that
    * Right, and if I put it like that, I think it *should* be possible to do it without an `EventBus` like this:
      * All widget controllers need to listen to the `CommandController`, which in turn is a `ChangeNotifier` itself and notifies its listeners every time a command was executed

  * Okay, so far the theory, and if I lay it out like that it seems pretty straightforward

  * That's the control flow

  * Next, I also want to consider how to keep as much logic as possible within the individual commands, so that the `CommandController` does not end up becoming a mega-freaking HUGE god class

    * Obviously, the commands can't be `ChangeNotifier`s because that would require a fixed set of commands

    * Rather, where we want to go is probably somewhere along the lines of:

      * ````
        execute(Command command){
        	command.execute();
        	commandStack.add(command);
        	notifyListeners();
        }
        
        undoLast(){
        	Command lastCommand = commandStack.last;
        	lastCommand.undo();
        	commandStack.remove(lastCommand);
        	notifyListeners();
        }
        ````

    * ...I was going to suggest using the visitor pattern here, but looking at it like this, I don't think we actually need it

    * While the commands can't be change notifies, I don't see a reason why they should not be allowed to operate on the repositories

    * The question is whether the updating is going to work through the entire chain, but since all the things that can change should be subject to `context.watch` calls, I *think* that should work

  * Okay, so much for the theory, now to put it to the test

    * Now, two things need to be kept in mind here:
      * In addition to the undo-logic I also need redo-logic
      * Safeguarding against bad states by too quick command execution or undo/redo frenzies
        * Such as, you undo two commands in quick succession, like undo renaming of a point in time then undo adding it, and if the undoing of the adding completes before the renaming, then the renaming undo will fail because the point in time no longer exists
        * I *think* I can safeguard against that by introducing locks 
        * I *think* this package supports that:
          * https://pub.dev/packages/synchronized
    * Okay, so let's see, which commands do I need for a start?
      * `CreatePointInTimeCommand`
      * `RenamePointInTimeCommand`
      * `DeletePointInTimeCommand`
    * One question is whether to put those commands in the `commands` folder or the `timeline` folder
      * Hmm, since putting them in the  `commands` folder is too close to layer-architecture for my taste, I think I'll put them into the `timeline` folder instead, possibly a subfolder though to keep them bundled
    * Hmm, come to think about it, I think I might not even need to make the `CommandStack` a change notifier because the controllers can just call `await addAndExecute(command)` and then notify their listeners afterwards
    * And Come to Think of it 2 ~ The Thinkening, I don't believe there are any asynchronous commands that I need to consider, thus I can also save myself the whole locking logic 
      * Well, following the teachings of the great prophet YANGI, let's try with synchronous commands now, and see how far that will get us

# User Story

As a Game Designer and Author, I want a tool to help me keep track of characters, events, items, knowledge, locations, affiliations and other things that can change over the course of a story. For example, I want to be able to go back and forth in time to figure out who learned what at what time, or who was where at what time and with whom.

## Acceptance Criteria

### Time Bar

- [ ] All screens have a time bar at the top, which allows going back and forth in time
- [x] By default, there is only one point in time 
- [x] Points in time can be given names
  - [x] These names have to be unique
- [x] Points in time can be added before or after any other point in time
- [x] Points in time can be deleted
  - [ ] If an event happens at a point in time, that point can't be deleted
    - [ ] There is a functionality that allows skipping to the event in question
  - [x] If there is only a single point in time, that point in time can't be deleted
- [x] Points in time can't be re-ordered

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