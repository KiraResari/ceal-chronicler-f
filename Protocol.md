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

[Time elapsed so far: 2.5 hours]

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

[Time elapsed so far: 6.5 hours]

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

[Time elapsed so far: 10.75 hours]

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

[Time elapsed so far: 13 hours]

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
      * Wait, no, there's still the problem that the undo and redo buttons exist in a different context than the controllers, so it's important that the controllers listen to the `CommandStack` so they get notified even when something changes that they did not trigger
    * And Come to Think of it 2 ~ The Thinkening, I don't believe there are any asynchronous commands that I need to consider, thus I can also save myself the whole locking logic 
      * Well, following the teachings of the great prophet YANGI, let's try with synchronous commands now, and see how far that will get us

  * I now managed to successfully create the `CreatePointInTimeCommand` and get it to work, which is a good start

  * And now I managed to add the commands for Deleting and Renaming points in time too, and they work as well

  * The next part will be the Undo and Redo buttons

    * Score! Undo works now!
    * Redo is now also implemented, however, it still fails when attempting to redo renaming of a point after its creation was undone
      * I think the reason for this is that when undoing and redoing the creation of a point in time, the redo creates a different point in time instead of restoring the undone point in time
      * I now managed to fix this

  * BREAKTHROUGH! We won!

  * With that, the Undo-Redo logic is working nicely!

  * Now, for the finishing touch I still want to polish the buttons a bit

  * And now it looks pretty good too

  * With that, I declare the Undo-Redo done

* This is as far as I'm getting with this today

[Time elapsed so far: 18.75 hours]

# 26-Jan-2024

* Now continuing with this
* Last, I finished the undo-redo functionality
* Now, I want to tackle saving and loading
  * This is gonna be a bit more tricky, since I need to target the different platforms differently
    * Technically, I only need it for PC, but since I also want to use this as a learning project, I also want to implement saving and loading for web and Android
  * I'll start with the PC save/load functionality
    * Right now, we have only one type of object that needs to persisted, and that is the `PointInTime`
    * However, I think at this point I think it makes sense to consider what a save consists of, and create an object for that
    * One save represents a chronicle, with everything that belongs to it, points in time, characters, places, etc... so it would make sense to have a `Chronicle` object and persist that, and through it everything else
    * The thing is, I already have a `PointInTimeRepository`, the task of which it is to watch over all the points in time
      * Let us consider for a moment if it makes sense to have a `ChronicleRepository` instead
        * My first instinct is to say "no", because that would create something of a god class, and the `PointInTimeRepository` is already 80 lines long and still growing
        * The `PointInTimeRepository` contains the following public functions:
          * `get all`
          * `get first`
          * `createNewAtIndex`
          * `createAtIndex`
          * `get existingNames`
          * `remove`
          * `rename`
          * `getPointIndex`
        * Literally all of those functions operate on the `List<PointInTime> _pointsInTime`, which is the one and only instance variable of this class, thus meaning this class has extremely high cohesion
        * If I were to add a `ChronicleRepository` and store the points in time there, I think that would over-complicate things because for pretty much all of those operations, the points in time would have to be fetched from the `ChronicleRepository` repository instead
        * So, yeah, no, I don't think a `ChronicleRepository` makes sense after all
      * So, what is the alternative?
      * I could, whenever a save is called, get all the relevant objects out of their respective repositories, assemble them into a `Chronicle` and then read that, and whenever a load is called I could read the `Chronicle`, and then disassemble its fields into the relevant repositories
        * This still feels a bit weird, but at least it has the advantage that the `Chronicle` is an object with a very clearly defined purpose: Bundling all the relevant objects for saving and loading
    * Okay, so let's go with that for now
    * For starters, though, I need to make the `PointInTime` into a `JsonSerializable` and test that
      * Yoshu, looks good!
    * Right, next is adding the `Chronicle` object and doing the same for that
      * This is gonna be more interesting since it involves parsing a list, and my previous solution on that is a bit bogus
      * I now did that too, and it works
      * I have to say though, the JSON encoding and decoding is a bit funky, but since I now have a template for most cases, I should be fine from here on out
    * Okay, so next is the actual saving and loading, now that I have the objects prepared and ready to be parsed to and from JSONs
    * I suppose it makes sense to start with the saving
      * When saving, I want a system popup to appear that asks me where I want to save the file to
      * Oooh, but before that, there's some really fancy interaction with saving and the undo-redo logic
        * "Saving should not be necessary if a command has been executed and saved" is the name of the test that is a bit of a twister
          * The question that needs to be answered at this point is how saving is going to be implemented structurally
            * Whatever class is gonna do the saving needs access to all the repositories
            * I feel a strong tug to simply put it into the `CommandProcessor`, but at the same time that also feels like it's outside of its responsibility
            * At the same time, it would make the interaction between the undo-redo logic that is housed in the `CommandProcessor` and the saving logic so much easier to process if all the saving logic would go through there
            * And yet, save and load clearly should not be commands, because I don't want them to be un- and redo-able
            * With all that in mind, I feel it probably is a good start to give the  `CommandProcessor` `save` and `load` functions, aiming at that they will forward to a dedicated class while at the same time modifying the undo/redo logic accordingly 
      * Right, I think I figured out a good logic for that now
* This is as far as I'm getting with this today
* What I want to do next:
  * Add actual saving functionality

[Time elapsed so far: 21 hours]

# 27-Jan-2024

* Now continuing with this
* Last time I got started with the save-load functionality
  * The next thing I wanted to do was adding the actual saving functionality when the button is clicked
  * And that's where things are gonna get more interesting because they're getting platform-dependent
  * Hey, this looks like a convenient way for picking the file name https://pub.dev/packages/file_picker
    * Gosh, I wonder if I'll even *have* to implement different logic for the different platforms with that
    * Let's try
    * Awesome! That worked unexpectedly easily!
  * Cool, let's see if it also works on other platforms just like that
    * Okay, looks like it doesn't work on web
    * And looking at the documentation, it won't work for android as well, so I need special cases for those, but I don't think I'll need separate classes for just that
    * Okay, so, saving for web seems to be more complicated
    * It looks like I can probably get it to work *somehow* for Android, but for Web it's another matter altogether
    * This plugin seems to support saving for Android and iOS, but not for web: https://pub.dev/packages/flutter_file_dialog 
      * Ah, no, that also works differently, I'm afraid
    * Well, since my targeted platform is Windows anyway, I suppose we can skip this for now
    * Since I tend to have pretty big gaps between when I actually get to work on this project, odds are that this plugin will support saving for these platforms before I'm done with it
    * And until then, for mobile I can at least use the same solution that I used in the first draft, and simply save to a fixed file for now
      * Well, at least that doesn't throw an error, though I suppose I won't be able to tell if it really worked on mobile until I implement loading
  * Okay, so much for saving, now let's try loading
    * Again, loading first comes with its own baggage of interaction with the undo-redo functionality, so I want to write test cases for that and get those to work first
      * I now did that, though it turns out there were not as many necessary, given that loading is always possible, and pretty much only resets the command history which triggers everything else
    * Okay, now onward to making it work
      * Alright! loading now works on Windows
      * And on Android too! Sweet!
      * Only web still has issues, oh well
        * I suppose it makes sense that saving and loading require somewhat special handling in web, since there it's more like upload and download, or export and import I guess
        * But that's a problem for another day
        * For now, I'll just wrap it up nicely by disabling these buttons on web
  * With that, saving and loading works good enough for my taste now
* Next, I quickly want to add a status message bar for status messages
  * Though this is not in the acceptance criteria, I have regularly witnessed in the Kanji Tree R how useful that could be, so I want to add it here too
  * While easy in theory, I seem to have some trouble with the `MessageBar` not reacting to the `notifyListeners()` of the `CommandProcessor`, despite me having watched it via `context.watch<CommandProcessor>().statusMessage`
  * Ah, I figured out what the issue was: I accidentally created a second `CommandProcessor` that was never triggered, but which the `MessageBar` listened to
    * I now fixed that by interposing a `MessageBarController` that gets the `CommandProcessor` from the context
  * Okay, so now the message bar basically works
  * For now, I'm just gonna add messages for every command
  * I now did that
  * The message bar is still a bit crude for now, but since it's mostly for providing feedback of what is happening in the app to me right now, I think this is good enough for now
* This is as far as I'm getting with this for now

[Time elapsed so far: 26.5 hours]

# 29-Jan-2024

* Now continuing with this
* Now it's time to fill the main body of the app with some content
  * For that, I need to consider the views that I want to exist
  * Also, I need to give navigation a thought
  * I think, for starters it makes sense to hard-code the central view as a character overview that displays all the characters that exist at this point in time
    * Or maybe, I'll make it so that it displays all the characters, including those not yet introduced and those that already stage outed
  * Starting from there, I'll probably already be able to work quite some time until everything works nicely 
  * Okay, so, up until this point I've held on to all my old classes, figuring that maybe I would use them again, but looking at it now I think it's best to just throw them away and make a clean slate
  * I now finished cleaning up, and managed to throw quite a bit of gunk out
    * Also, now I can finally run all the tests again, which feels quite liberating
* Since I don't have much time today, this is already as far as I'm getting with this now

[Time elapsed so far: 27.75 hours]

# 31-Jan-2024

* Now continuing with this
* This is the last time that I'll get to work on this for a bit, so I want to leave the project at a stable float today
  * As such, I don't want to open up the whole characters-task complex after all, but rather focus on something that I can finish with the next few hours
  * For that, I think, the incidents are ideally suited, although I did not write acceptance criteria for those yet, so I'll do that now
* So, incidents it is now
  * An incident is anything notable that happens at a certain point in time
  * That means an incident is always tied to a particular point in time
  * An incident is pretty much just a string
  * I am thinking about whether to make incidents into objects with their own ID
    * The advantage of that would be that it would be easy to reference and extend them later on, thus keeping later saves compatible with earlier ones
    * The disadvantage would be that it would make it more complicated
    * However, I think it makes sense to spend some time to put that infrastructure in place now
  * Funnily, I just noticed how Incidents currently are pretty much identical to  points in time, but they will diverge soon enough
    * Still, that naturally makes introducing them a lot easier, since I can just copy a lot from the points in time to use as a template
      * This will mean duplication for now, but since the idea is to keep the objects separate and flexible, I figure this is okay for now
  * Now, for how to tie points in time and incidents together
    * I could just put the incidents directly into the points in time
    * However, that would mean that the `PointInTimeRepository` would have to know about the `IncidentRepository`, and I kinda wanna avoid dependencies at the same level
    * So, how to avoid that then?
    * Well, fortunately, I did already give each `PointInTime` and `Incident` a unique ID, so I can refer to them via that
  * I'm making good progress thus far
  * Now working on the incident commands
    * There, the one thing that is a bit tricky is the `DeleteIncidentCommand`, because that one needs to search all the `PointInTime`s and remove the references from them
    * But it's either that, or have the `Incident` reference the `PointInTime` instead, which would either create the opposite problem if done unilaterally, or a bilateral connection which I kinda want to avoid because it can result in a situation where the objects are out of sync and really weird stuff starts happening
    * So I think I'm gonna go for "slightly slower but more sturdy" here (it should not make a noticeable difference anyway)
    * Or, I can just make the `DeleteIncidentCommand` a bit more clunky by requiring it to pass along the related `PointInTime`
      * That would definitely work for now, but it would also disable the ability to delete `Incident`s from a separate `IncidentView` that may exist at one point in the future
    * So likewise, I'm also gonna go for "slightly slower but more flexible" here
  * I now finished with the commands
  * Right, that is the backbone for the Incidents
  * After this, I have to work on the `IncidentView` and related controller, which is also going to entail enabling switching between the active point in time
  * Aaand, this is something I am not gonna get done today after all
  * Oh well, I suppose I can still afford some time to finish this off at the beginning of the new month
* Anyway, this is as far as I'm getting with this today

[Time elapsed so far: 31.75 hours]

# 1-Feb-2024

* Now continuing with this

* I am presently in the middle of implementing the Incidents

* There, I realized that this also necessitates me implementing the functionality for changing the current point in time

  * Basically, the `IncidentOverview` that will be the component for displaying the incidents needs to know which point in time is active in order to display the incidents for that point in time

  * Currently, the `TimeBarController` contains the information about which point in time is the active point in time, but I think it would be better to extract that into a dedicated class, since multiple views would need that one

  * Right, so, since I already have a `CommandProcessor`, let's call that class the `TimeProcessor` until I can think of a better name

  * So, before I continue with the incidents then, I should work on the logic for switching the active point in time

    * I got that one basically down

  * Now, I also have to consider what happens if you delete the active point in time

    * Okay, so, until now I managed to avoid widget tests, but I can see how adding this functionality is going to affect so many things that I might as well just write a widget test for this

    * Aaaaand, it's fucking me up because keys are not strings, and I can't get the string values that I assigned to keys back out of these keys, which means I can't easily create unique keys for objects such as the `DeletePointInTimeButton` of a certain `TimeBarPanel` 

    * I now managed to get around that by implementing a custom `StringKey` class

    * Okay, so by now I added what I feel is a solid widget test suite that I can work from

    * Aaand, the widget tests once again behave kinda unexpectedly 

      * Okay, so apparently the keys are not really reliable, because they apparently get changed when the widgets are rebuilt, thus making widget testing yet even more interesting 

    * Okay, so interestingly, the tests exposed that there is apparently already some nascent logic that unexpectedly changes the active point in time when it is deleted

      * So, apparently, when a point in time is deleted, the next time is automatically active, though I don't understand how
      * However, when the point in time that is the furthest to the right is deleted, there's no active point in time
      * Right, I think in order to tackle this, I need complex unit tests after all instead of widget tests
      * Hmm, I wonder if this has some subtle interference with the keys?
      * Hmm, nope, doesn't seem to be the case
      * Weird
      * Okay, by trying around I found that apparently, for whatever strange reason, when a point in time is deleted, the next point in time button "adopts" that point in time, leaving us with a situation where the button labeled "Point in Time3" activates "Point in Time2"
      * Really Weird
      * I don't quite grep this, but I figure it is related to how both the `PointInTimeButton` and the `PointInTimeButtonController` save the `PointInTime`, and since the button passes the point to the controller, I assumed that it would always be the same, but clearly this is not the case
      * How the fuck is it possible that they get unsynched like this?
      * Okay, so, I now managed to fix it like this:
    
        * ````
            @override
            Widget build(BuildContext context) {
              var controller = PointInTimeButtonController(point);
              return ChangeNotifierProvider.value(
                value: controller,
                builder: (context, child) => _buildPaddedButton(context),
              );
            }
          ````
      * I'm not quite sure why this works, but clearly it does, so...

    * Also, we have an annoying `A PointInTimeButtonController was used after being disposed.` error
    
      * Okay, I think I managed to solve that like this:
    
        * ````
            PointInTimeButtonController(this._point) {
              _timeProcessor.addListener(_notifyListenersCall);
            }
            
            void _notifyListenersCall() => notifyListeners();
            
            @override
            void dispose() {
              super.dispose();
              _timeProcessor.removeListener(_notifyListenersCall);
            }
          ````
    
    * Well, those bugs certainly threw me off my schedule
  
* This is as far as I'm getting with this today

[Time elapsed so far: 36.25 hours]

# 3-Feb-2024

* Now continuing with this
* Presently, the issue is that the point of time is incorrectly set while deleting
  * In the preface of this, I uncovered really weird behavior in regards to the controller, which caused this to mostly behave, but only due to a bug
    * I did manage to fix that, so I am all clear to work on the actual issue here now
  * "Deleting first point in time should make remaining point in time active" is the issue I'm working on right now
    * And that's actually quite tricky, since I also need to consider how undoing this works
    * But anyway, it seems pretty obvious that this is tied to the `DeletePointInTimeCommand`
    * The commands are actually pretty neat:  Since they represent user interactions, they can never, ever chain, always come form a controller, and always target one or more repositories, which then notify their listeners after being changed, thus creating a very solid control flow
    * Actually, now that I write it like that, I figure I can simply write a unit test for that to keep it simpler
  * Okay, so I now fixed that, and it was actually pretty straightforwar
  * I suppose the architecture that I set up really facilitates this
* Right, so next I want to work off a few things that have been accumulating on my todo list
* First, I noticed that the architecture I described above is not what I actually have in place: Currently, the repositories don't do any notifying, so I want to see if I can change that and if that will work
  * Well, I merged the `TimeProcessor` into the `PointInTimeRepository` , which cleaned up a bit
  * But then I realized that while this made the `PointInTimeRepository` a `ChangeNotifier` by necessity, I don't actually need to have it throw around notifications in all the other cases (same goes for the `IncidentRepository`), since all changes to them are made by commands, and handling of any commands triggers a change notification through the `CommandProcessor` anyway, so it looks like we're good
  * In the long term, I'll probably even get the `ChangeNotifier` out of the `PointInTimeRepository` again as I implement a view change history like what I have with undo-redo right now, which will probably move all the notifying into a central `ViewProcessor` or something like that
  * Anyway, this part is good for now then
* Very well, as for my next move, the `RepositoryService` currently does not save the incidents, which is something that I still need to add
  * I now did that
* This is as far as I'm getting with this today

[Time elapsed so far: 38.25 hours]

# 5-Feb-2024

* Now continuing with this
* Next, I want to simplify the `PointInTimeRepository` to match the `IncidentRepository`
  * The reason for this is that I find that the interface of the `IncidentRepository` is better defined with its `add(Incident incident)` and `void remove(Incident incidentToBeRemoved)` functions, as well as the public `List<Incident> incidents = []`, so I want to change the `PointInTimeRepository` to mirror that and move all more specific logic such as `createNewAtIndex` out into whatever class is calling that
  * However, upon closer inspection, I realize that the `createNewAtIndex` is actually not quite as out of place there as I thought, because unlike with the incidents, the creation of points with unique names is a concern that fits the `PointInTimeRepository` very well
  * So, in the end I only ended up renaming the `createAtIndex` function to `addAtIndex`, which is still an improvement
* Right, now on to the actual functionality of adding, editing and removing incidents
* I'll start with adding incidents
  * Okay, that works now
* However, I uncovered a bug:
  * When undoing the creation of a point in time that is the active point in time, that point in time remains active, leaving one stranded at an unreachable point in time
  * I now fixed that
* This is as far as I'm getting with this today

[Time elapsed so far: 39.75 hours]



# 7-Feb-2024

* Now continuing with this
* Next, I want to enable deleting of incidents
  * Well, that was quick
* So finally, the last thing that is missing is the ability to rename incidents
  * I now managed to get this to work
* Right, so that's the core logic for incidents done, though naturally I already thought of new requirements
* However, more importantly, I ran into a bug that I should fix right away:
  * When a chronicle is loaded, the active point in time is still that of the previously loaded chronicle
  * I now fix that
* There's still a few small things that I would like to clean up before I set this down
* But this is as far as I'm getting with this today

[Time elapsed so far: 41.25 hours]

# 8-Feb-2024

* Now continuing with this

* Today, I really plan to wrap up with the Incidents

* I have mostly cleanup planned for today

* First, I want to try and consolidate the `RenameDialog` & controller with the `RenamePointInTimeAlertDialog` & controller, since I actually pretty much copied the former from the latter, so they have a LOT of duplication that I want to get rid of

  * The `RenameDialog` & controller are the more generic versions, so let's see if I can make the `RenamePointInTimeAlertDialog` & controller derive from them

  * Okay, so making the `RenamePointInTimeAlertDialogController` inherit from the `RenameDialogController` already worked nicely

  * Meanwhile, trying to consolidate the `RenameDialog` with the `RenamePointInTimeAlertDialog` is more complicated because the call to `TextEditingController controller =    context.read<RenameDialogController>().textEditingController;` does apparently not recognize the `RenamePointInTimeAlertDialogController` at that point

    * I added a pair of methods for reading and watching the controller, so I can override them like this in the `RenamePointInTimeAlertDialogController`:

      * ````dart
          @override
          RenameDialogController readController(BuildContext context) {
            return context.read<RenamePointInTimeAlertDialogController>();
          }
          
          @override
          RenameDialogController watchController(BuildContext context) {
            return context.watch<RenamePointInTimeAlertDialogController>();
          }
        ````

    * Now this works too

  * With that, this part of the cleanup is done

* Next, there's a thing that's actually a requirement that I've overlooked, and that's that points in time should not be deleteable if they have incidents

  * Stating the reason for why it can't be deleted is actually more complicated, so I am going to skip over that at this point and instead focus on the disabling part
  * I now did that
  * Now let me just see if I can communicate the reason with relative ease
    * Yup, looks good

* Cool, so, since I still have a bit of time left today, I figure I might as well use that to work on my lingering regret concerning the points in time, namely that shifting them up and down is not yet possible

  * I now created the commands for that
  * Now to add the buttons
  * That was a bit more tricky, but it works now too

* Since I had some time, I also tried to make it so that the text in the rename dialogs is initially selected, but nothing I tried there worked

  * Oh well, that's a tale for another day

* With that, I am done for now

[Time elapsed so far: 44 hours]

# 8-May-2024

* Now continuing with this
* Next, I want to tackle the Characters
  * Those are, in fact, tricky
  * So, for starters, I want a very basic character, with a first appearance, a last appearance, and a name that can change
  * First, let's focus on adding characters
  * For starters, I think it makes sense to just display the characters next to the incidents, since there is ample space
    * °sigh° and already I am starting to run into an issue like "RenderFlex children have non-zero flex but incoming width constraints are unbounded."
  * I just noticed that the character model classes are very similar to the incident model classes, so I'll try to abstract these
  * On a closer look, `CharacterId`/IncidentId and `Character`/`Incident` are already tied to one another via their parent classes, and I don't think further abstraction makes sense, but I can probably abstract the repositories
    * I now managed to abstract the repositories, which should make things easier down the line
    * Yes, because now adding a character repository is just a matter of adding a single line plus imports
  * Anyway, with this groundwork done, the first thing to do is adding new characters
    * Again, this is very similar to the `CreateIncidentCommand`, so maybe I can abstract those
    * Hmm, no, doesn't look like it
      * I'd like to do something like `CreateIncidentCommand<T extends Repository<U>, U extends IdHolder>`
      * But that doesn't work because `_createdIncident ??= U();` is not accepted
      * Oh well, it was worth a try
  * Alright, the very basic adding of characters works now
  * However, thus far, the characters still exist at all points in time simultaneously, which is not the intention
    * Instead, newly created characters should only be displayed at the point in time of their creation and thereafter
    * I am currently in the process of trying to get that to behave correctly, but it's not yet working
* This is as far as I'm getting with this today

[Time elapsed so far: 47.5 hours]

# 9-May-2024

* Now continuing with this
* Last time, I got to the point where I was able to add characters, and theoretically they should only appear at their designated points in time and thereafter, but didn't
  * Ah, it looks like the change of a point in time currently does not trigger a rebuild of the characters overview
  * Okay, this is potentially tricky, but it feels like this happens because currently view changes are not handled the same as commands
  * However, it does work with incidents, so...
  * Ah, I think the `CharacterOverviewController` is still missing a listener on the `PointInTimeRepository`
    * Okay, looks like that fixed that
* Right, next I wanted to see if I can improve the `PointInTimeRepository` a bit, because currently it looks notably different than my other repositories
  * For starters, it uses a List rather than a Map, which makes it more complicated for me to find Points in Time by their ID
  * However, the index that I use in the list is important too, since the order of the list is equal to the order of the points in time
  * So let's see if I can just turn it into a map and get that still to work, and if that works, maybe I can even get it to inherit from the abstract `Repository` class that I introduced earlier
    * Hmm, I think the problem lies with inserting things at a specific index...
    * It's probably inevitable at this point to use the map on top of the list if I want to do that, which will at the same time kill off the option of consolidating this into the abstract `Repository` class, but oh well...
    * Aaaand, now I seem to have busted the saving/loading in doing that...
      * Thankfully the tests detected that
      * Ah, I think I had a renaming oversight somewhere
      * Okay, that fixed that
  * And yay, we're exactly at 100 tests now
* Next, I want to make it so that characters can also be saved/loaded
  * Assuming the framework that I built up is robust, that should be a simple matter of adding the `CharacterRepository` to the `Chronicle`
  * Well, it's a bit more complicated, it would seem
  * OOOOH, and it looks like presently adding new fields to saves breaks the loading! That's no good!
    * Okay, I fixed that now
    * With that, I can now load my old chronicle file again
  * However, it looks like the loading of characters is not working yet
    * Well, duh, looks like I forgot to add the line for transferring the loaded characters to the repository, so no surprise there =>,<=
  * Okay, now saving and loading of characters works!
* Next, I have to make it so that Points in Time that are the first appearance of a character can't be deleted 
  * Alright, that works now too!
* Alright, next will be the implementation of the character screen
* Actually, before that, it might make sense to first implement the view navigation logic, since this is where it will start escalating
  * Specifically, I can think of the following scenarios that might become relevant in the near future:
    * In the character view, it  should be possible to jump to different points in time, for example to the point in time where the name has changed
      * If we do it like the command pattern, and use something like a `ViewChangeCommand`, then this is easy because we can fire it from everywhere
        * However, with this, we need to consider that since these are gonna use a separate stack from the `Command`s, some `Command`s may break this stack, so how do we deal with that?
          * For example, if I create a new point, then go to that point, then to another point, then delete that point, and then try to navigate back, then that will clearly fail, since the point to which should be navigated no longer exists
          * There's multiple ways to deal with this
            * For one, we can simply say that any deletion empties the navigation stack
              * Since I assume that `ViewChangeCommand`s are always going to target a specific entity via its ID, it should only be deletions that are problematic
            * A more thorough way might be to scan the `ViewChangeCommand` stack every time a deletion is triggered and remove any `ViewChangeCommand`s that relate to the deleted item
              * But restoring them might be tricky
            * A way that preserves history through undo/redo of `Commands` and yet does not cause any problems would be more complicated, but possible:
              * Basically, it involves making validity checks for every `ViewChangeCommand` in the stack to see if the forward/backward buttons are active
        * Since `ViewChangeCommand`s never alter any data, it should not be possible for them to break the `Command` stack, so at least in this direction we should be clear
    * In the character view, it should not be possible to jump to points in time at which the character does not exist
      * That means the `TimeBarController` needs a way to know which character is active, meaning that similarly to how the `PointInTimeRepository` has an `activePointInTime`, the `CharacterRepository` needs an `activeCharacter`
  * Right, that is a lot to process, but it all nicely converges on a system revolving around `ViewChangeCommand`s  
    * The next question is how to best deal with this and the existing `CommandProcessor`
      * Basically, I need to decide about whether to integrate it in the existing `CommandProcessor`, or whether to create a class for this, say, a `ViewProcessor`
      * I mean, clearly I need a separate stack for this
      * And keeping the complex logic for the validity checks mentioned above in mind, yeah, I think it's definitely gonna be a class of its own
      * The disadvantage of this is that everything that listens to the `CommandProcessor` will now also have to listen to the `ViewProcessor`, but oh well
  * Okay, let's try implementing that `ViewProcessor` for navigating back and forth along the time line at first 
* This is as far as I'm getting with this today

[Time elapsed so far: 50.5 hours]



# 10-May-2024

* I'll now start with implementing the `ViewProcessor`
  * I am making good progress there
  * I have gotten to the point where navigating to points in time and navigating backwards works in the tests
  * Next, I will have to work on navigating forwards
* This is as far as I'm getting with this today

[Time elapsed so far: 52 hours]



# 11-May-2024

* Now continuing with this

* I am presently working on the `ViewProcessor`

  * The next thing I need to do there is navigating forwards
    * I now did that
  * With that, the `ViewProcessor` should be done

* Now, the next step will be integrating it

  * Right now, the only view change I have is the change of active points in time in the time bar
  * Alright, I now managed to do this
  * Though, as expected, I had to add listeners to the `ViewProcessor` to all the  affected view controllers, that is, `TimeBarController`, `CharacterOverviewController` and `IncidentOverviewController`
    * However, putting the `ViewProcessor` next to the `CommandProcessor` now, I see that it was right to make it into a separate class, because while they both use the command pattern, they use it in slightly, yet irreconcilably different ways
    * Also, since I can't fathom needing a third type of command processor, I think it's okay if we have this duality here for now
      * Maybe I could unite them into one class that takes both types of commands and delegates those, to dedicated sub-classes, but I think that would only make things more confusing

* Next, I want to implement one of the reasons why I actually did this: Namely forward/backward navigation buttons 

  * Alright, those now work too! And with minimal effort too!

* Right, and to finish off the navigation chapter, I want to make it so that loading a chronicles clears the `ViewProcessor` history

  - Functionally, this makes no difference since all the `ViewCommand`s in the `ViewProcessor` are invalid and thus inaccessible anyway after loading, but they're still polluting the memory that way, so I'd better take them out
  - Ah, no, wait. In fact, it *does* make a functional difference, since you could load a previous version of the chronicle you'te currently working on, which would allow some `ViewCommand`s to be valid, which would produce some weird behavior, so yeah, definitely gotta clear the history there
  - Okay, I did that now

* With that, the navigation is now complete

* Okay, so next is implementing the character view, now that we have implemented a mechanic for navigating in general

  * Well, actually, we still need to implement a mechanic for switching between the `MainView` and the `CharacterView`, but that can wait until we actually have a `CharacterView`

  * So, what does the `CharacterView` need for the first iteration?

    * A back-button
    * A display field for the character name
    * A display field for the first appearance

  * Now, here's an interesting question regarding the layout:

    * I could make it either column-based or row-based
    * Row-based would mean that the fields and their labels could be one object
    * Column-based would make them different objects, but they'd be vertically aligned better
    * Hmm, is there some way to make grid- or table- layouts?
    * Ah, yes, `Table`  looks like something good to try here
    * I'll start simple for now and then see how to take it from there

  * In the first iteration, I'll add a simplistic `CharacterView` with only display fields and no back button, and focus on making it possible to navigate there from the main view

  * Hmm, I think I'll need to rethink the naming

    * Right now, I have a `MainView` that holds the `IncidentsOverview` and the `CharactersOverview`
    * The `MainView` is one one level with the `MessageBar`, `ToolBar` and `TimeBar`
    * So it's basically my main layout component
    * That means I can't just switch it with the `CharacterView`
    * However, I think it would be a good place to handle the switching logic, which means I need to encapsulate the `IncidentsOveview` and the `CharactersOverview` into a different view
    * I can't think of a better name than `OverviewView` right now, so let's go with that until I can think of something better

  * Mmmh, as I start working on it, I realize that my architecture wants me to add a  `ViewRepository` to keep track of which view is active

    * Specifically, I need something that the `ViewProcessor` may modify in order to change what is displayed in the `MainView`, and thus far I have held it in such a way that the controllers all listen to processors
    * Okay, this is tricky, but I think I'm making good progress thus far
    * But the character button is still giving me a hard time, cuz why can't buttons just be easy? =>,<=
    * Well, clicking on a character button and moving to the character view works now

  * However, when clicking the "Navigate Back" button afterwards, I get this lovely error again:

    * ````
      The following assertion was thrown while dispatching notifications for ViewProcessor:
      A IncidentOverviewController was used after being disposed.
      
      The following assertion was thrown while dispatching notifications for ViewProcessor:
      A CharacterOverviewController was used after being disposed.
      
      Once you have called dispose() on a CharacterOverviewController, it can no longer be used.
      ````

    * °sigh° I hate this one, but at least I know why it happens

      * This is precisely why I moved away from using Events for this project, but apparently it can still happen even so

    * We either need to cancel the listeners somehow on the controllers, or make it so that all controllers are singletons

      * Or was there another way to do that still? 

  * Also, another issue that became apparent is that navigating backwards does not work properly:

    * Navigate to another point in time, then open a character view
    * Try to navigate backward
      * Nothing will happen because the view navigator will attempt to evaluate the last navigation event, which was activating a point in time
      * What should happen is going back to the main view

* Uggh, what a mess! I am not committing this until I clean it up!

* This is as far as I'm getting with this today

[Time elapsed so far: 56.5 hours]

# 15-May-2024

* Now continuing with this

* Last time we closed on several issues that became apparent due to the introduction of the character screen

  * Navigation back does not work as intended
  * Changing views causes the "A * was used after being disposed" error

* First, let's address the "A * was used after being disposed" error

  * I *think* I can solve that by removing the listeners in the `dispose` function, which I can hopefully override
  * Yes, that's possible, and it works
  * With that, this issue is already resolved
  * However, since especially the listening to the `CommandProcessor` and `ViewProcessor` is very repetitive, I figure I'd better make an abstract superclass that takes care of that
    * That way, the inheriting classes only have to explicitly listen to any repositories important to them
  * Anyway, this seems to work now
  * HOWEVER, now many tests are failing because suddenly they all need a `ViewProcessor`, which in turn needs a `PointInTimeRepository`, which feels like things are starting to get ugly tangled here
    * So, WTF?
    * Okay, so , I *think* I can het the `PointInTimeRepository` out of the `ViewProcessor` by implementing the changes I have in mind to fix the navigation history issues
    * At the same time it still bothers me that the `CommandProcessor` depends on the `ViewProcessor`
      * Why does it do that?
        * The `CommandProcessor` needs the `ViewProcessor` for exactly one thing, and that is for resetting the histoy and indexes when a file is loaded, which makes sense
      * Why does the `CommandProcessor` contain the `load` function in the first place?
        * Saving and loading are not commands, because they should not go into the command history 
        * The calls for that come from the `ToolBarController`, which naturally has access to both the `CommandProcessor` and `ViewProcessor`
        * Maybe the `save` and `load` functions actually belong in the `ToolBarController`?
        * Or maybe, a simpler way would be for the `ToolBarController` to call `_viewProcessor.reset()` itself instead of having the `CommandProcessor` do that
          * Yes, that sounds like a good solution, let's try that
        * Right, that fixed a bunch of things
  * Now, tests are failing because they miss a `ViewRepository`, which may actually be justified, but I'd still like to fully wrap my head around this dependency after we just had a dependency issue
    * The controllers clearly need the `ViewProcessor`
    * However, currently the `ViewProcessor` needs the `ActivateInitialViewCommand`, which needs the `ViewRepository`
    * Since I wanted to rework how the `ViewProcessor` works anyway, let's do that instead

* Now, to reworking how the `ViewProcessor` works

  * I messed this up because I assumed that each `ViewCommand` is more or less the same, so that by executing the previous command you can undo a command
  * However, that only works as long as there's just one kind of command and it falls apart as soon as there are different kinds of commands
  * Like: `ActivatePointInTimeCommand` > `OpenCharacterViewCommand`
    * Undo should return to the previous view
    * Instead, nothing appears to happen because the Point in Time that is currently activated is activated again
  * Right, so how do we better handle this?
  * I think I now came up with a good approach:
    * The `ViewStateRepository` stores the active point in time as well as the main view state
      * This is collectively saved as `ViewState`
    * This is accessed by any controllers that need to know what the active point in time or the main view state is
      * Should we separate this?
    * A `ViewCommand` that is executed keeps track of what the `ViewState` at the point before its execution was, as well as after execution
      * That should give it good resilience against undo/redo
      * A `ViewCommand` can be undone, if the before `ViewState` is valid
      * Likewise, it can be redone if the after `ViewState` is valid
  * Okay, so much for the theory, now let's try and do this!
    * Turns out the `ViewStateRepository` needs to depend on the `PointInTimeRepository` since it needs to know the ID of the original `PointInTime`
      * Mhh, and that's a problem
        * Currently, if the active `PointInTime` is removed, the `PointInTimeRepository` handles the search for a new one
        * But I think I can handle that, since part of it is in the command already
      * Another issue is the `activatePointInTime` function
    * Okay, no, rollback
  * So, in this attempt I learned that the active `PointInTime` has a really strong affinity for staying inside the `PointInTimeRepository`
  * So a different approach is needed
  * And that approach needs to keep in mind that `ViewCommand`s can be skipped if they are not valid
  * Maybe stick with a history of `ViewState`s?
    * Then each `ViewCommand` would still have a before and after `ViewState` to check against for applicability, and only the application itself would change
    * The `ViewCommand`s would all have to address both the  `PointInTimeRepository` and the `ViewRepository`, which is a proper thing for commands to do
  * Okay, so let's try that
    * Let's think about this scenario:
      * I have a character named Paul and two Points in time Named AD1 and AD2
      * Default State: Overview@AD1
      * I change the Point in time to AD2
        * => Overview@AD2
      * I change the character to Paul
        * => Paul@AD2
      * I go back once
        * => Overview@AD2
      * I go back again
        * => Overview@AD1
      * Now I delete AD2
      * Then I go forward
      * What I would expect to happen is end up at Paul@AD1
        * ...never mind that this might be invalid, if Paul does not exist at AD1 (might have been created @ AD1.5)
    * With above logic, I can't do that
    * I think what we need is different tracks for Main View Changes and Active Point in Time Changes
    * So, bye-bye ViewState
  * I think I may be thinking entirely too complicated here
  * Let me try making the `ViewCommand`s simply like the normal `Command`s, maybe with some tweaks
    * The main difference I think is that I need to check for validity for both executing and undoing
  * Alright, that was a big batch, but I managed to get it into a stable float again
  * Now let's see if the tests that I wrote for the `ViewProcessor` are still passing
    * Most do, which is a start
    * Let's try and fix the ones that don't
    * I'll need a bit of writing space for that here
      * Navigating back should skip invalid commands
        * ActivatePointInTimeCommand for Old_Horse_Omicron
        * ActivatePointInTimeCommand for Jolly_Goat_Xi
        * Falsely tries to undo ActivatePointInTimeCommand for Jolly_Goat_Xi because the targetIndex is 1 instead of 0
        * Ah, I missed changing on `isExecutePossible` into `isUndoPossible`
    * Alright, after ironing these out, all of the tests for the `ViewProcessor` are working again, yay!

* Right, how about all the other tests?

  * Nope, still errors
  * I now managed to fix them

* Okay, next let me do a manual test of the chronicler to see if all this refactoring caused any errors that are not covered by tests yet

  * Okay, it would seem that the navigating back is not working yet
    * Ah, I think I forgot the `notifyListeners` there
  * And there's still some odd behavior when combining undo and redo:
    * Repro:
      * Starting Point: Have three points in time, 1, 2, 3, with 1 active
      * Navigate to 2
      * Navigate to 3
      * Delete 2
      * Navigate back
      * Navigate forward
      * Undo
      * Navigate back
    * Expected behavior:
      * 2 is selected
    * Actual behavior:
      * 1 is selected
    * And "back" is still active
      * If you click back, then forward twice, then back, 2 is selected, as expected, and everything works as intended again
    * So, it seems there's some funky behavior when navigating backwards
    * Debugging showed the issue:
      * When navigating forward, the `execute` method of the `ViewCommand` is used, which changes the `_previousActivePointInTimeId` and thus messes everything up
      * So it seems I need a separate function for redo
    * Now this works 
    * I also wrote a test for it to ensure that this or something like it doesn't happen again
  * Right, back to the manual test to see if I can find anything else that isn't working as expected
    * Okay, looks good! I can't find any other issues right now

* So, back on track

* Since I'm doing refactoring now, I might as well check if I can get rid of a few things that accumulated

  * For one, it occurs to me that I should not need any listeners for the repositories since literally every action in the program that triggers a UI update should now be handled by either the `ViewProcessor` or `CommandProcessor`
    * That means that the repositories should not have to be  `ChangeNotifier`s
    * At least that's the theory. Let's see what happens if I change that
    * Oh, looks like only the `PointInTimeRepository` was a `ChangeNotifier` in the first place anyway by now
    * Well, that worked, though I left the `PointInTimeButtonController` as a `ChangeNotifier` since it presently does not need the `CommandProcessor`, so this is simpler
    * I did manage to remove the `ChangeNotifier` from the `PointInTimeRepository` though

* While testing the above, I ran into an error while messing with incidents

  * I don't know the exact order, but it happened while having two incidents, moving them up and down, and then undoing stuff

  * The final state at which the error occurred is as follows:

    * One incident (the other is deleted)

    * Undo & Redo are possible

    * Error message:

      * ````
        Undo of command failed
        Command: Instance of 'MoveIncidentUpCommand'
        Cause: RangeError: Invalid value: Not in inclusive range 0..1: -1
        ````

  * In a second run, I was able to reproduce it in a few seconds, using 2 incidents, undo, redo, and deletion, though the exact order and cause is still a mystery

    * This time it notably was a `MoveIncidentDownCommand` though, but the rest of the error was the same
    * It would seem this happens because there's an invalid command in the command history

  * I'll try to create a repro:

    * Start with 2 Incidents
      * Incident1
      * Incident2
    * Move Incident1 down
      * Incident2
      * Incident1
    * Delete Incident2
      * Incident1
    * Undo
      * Incident1
      * Incident2 <= why is the order different?
    * Undo
      * Incident2
      * => Error Occurs

  * Okay, so it seems that the undoing of deleting incidents messes up the incident order, and that causes issues with the incident move commands

  * An easier repo for this is:

    * Start with 2 Incidents
      * Incident1
      * Incident2
    * Delete Incident1
      * Incident2
    * Undo
      * Incident2
      * Incident1 <= was moved down

  * I now fixed this

* This is as far as I'm getting with this today

* Welp, no new functionality, but at least I managed to clean up a whole lot of bugs and issues

[Time elapsed so far: 63.5 hours]



# 18-May-2024

* Now continuing with this
* Presently, I'm still in full-on refactoring-mode
* Next, I wanted to see if I can separate the `FileService` from the `CommandProcessor`
  * The first question that I have to ask is whether it makes sense
  * Saving and loading are not commands, which speaks in favor of removing them from the `CommandProcessor`
  * At the same time, both saving and loading affect the `CommandProcessor`, because saving sets the `savedAtIndex` and loading resets the command queue
  * The reason why I would like to decouple them is that presently everything that needs the `CommandProcessor` also needs the `FileService`, which in turn needs more stuff, even if saving and loading are not needed
  * Okay, I *think* I can achieve that by separating the `CommandHistory` form the `CommandController`, making the `FileService` a `FileController` (and thus adding it to the `ProcessorListener`), and having the `FileController` access the `CommandHistory` for the necessary changes
  * Also, the status message needs to go somewhere else
  * Well, I now managed to separate
  * I am not really sure if that made things simpler in the end, but at the very least, the responsibilities are now better separated
* Aaand, thanks to a really nasty headache, this was already as far as I got today

[Time elapsed so far: 65 hours]

# 20-May-2024

* Now continuing with this
* Before I finally start continuing with the `CharacterView`, I wanted to see if there's a good way to consolidate the various button classesthat I presently have
  * Specifically, the `CharacterButton`  currently extends `StatelessWidget`, but it basically is just a button with some text, so I'd want to abstract that since I'll probably need that functionality more often
  * Meanwhile, I also have a `SmallCircularButton` and a `MediumSquareButton`, both of which are pretty much the same, only using icons instead of text
    * These two have a lot of duplication, but it's also not all that easy to separate them, since they differ at a low level, namely the `shape` argument of the `FloatingActionButton`
    * I'll try consolidating these two first
    * I now did that, and it looks good
  * Right, so next, I want to enter the `CharacterButton`  into that abstraction by adding a `CealTextButton`
    * Note: It's actually really funny how I need to prefix a lot of these buttons with "Ceal" because classes like this already exist, but don't match my requirements
    * I now did that, and in doing so also reworked the logic of the buttons a little bit again
  * Now, there's only the question why the text button presently does not scale to the width of the text inside, which is how I would have expected it to behave
    * It behaved that way even before the consolidation, so that can't have been the cause
    * Okay, so it seems like that works via the constructor `FloatingActionButton.extended`, which is extremely annoying because it makes this quite tricky, since that's a change at the lowest level, and `FloatingActionButton.extended` also requires a label
    * But meh, I think I can still whip something up here
    * Okay, I think I now managed to get that looking alright
  * Now, I just realized that the `PointInTimeButton` is actually also a text button that currently has a custom implementation, so might as well consolidate that one too
    * I now did that, and in doing so I also managed to remove the `PointInTimeButtonController`, which it turns out is no longer needed
      * This is actually interesting, since I would have assumed that this would have caused changes of the active point in time to no logner do anything, but clearly it still works
        * My best guess is that this is because the `TimeBar` still features a `TimeBarController`, which gets notified if the active point in time changed, and then triggers a rebuild of the entire `TimeBar` which also updates all `PointInTime` buttons
* Anyway, that's the refactoring done
* Next, let's move on to prettifying the `CharacterView`, which presently looks like your average office worker on a Monday morning
  * The first question is how to get the column widths right
    * Basically, what I want is a table where the first column (containing the labels) takes up as much space as is needed to print all the labels, while the second column (containing the values) takes up all remaining space
    * Okay, I now got this to work using `IntrinsicColumnWidth`, which however does not appear to work with hot reload, so at first it appeared not to work at all
  * So, now the `CharacterView` looks much better already 
* Now that I have two `ViewCommand`s that open a view, I can see that there's lots of stuff between them that doesn't change, so let me try to extract a common superclass
  * Yes, I was now able to greatly simplify that
* Next, I noticed something a very slight bug:
  * If you create a character, open the character view, then return to the overview view with the button, and then delete the character, it is possible to navigate back and forth one step without that appearing to do anything
    * This is because what happens is that the view changes in either direction are valid "go to the overview view"-changes
    * And that's simply another tricky case that I did not yet cover in the view logic
    * I now fixed that, and in a way that should work generally no matter how many different `MainViewCandidate`s we're gonna have
  * However, we also have that same problem for changing points in time
    * Fortunately, though slightly different, that followed the same general logic, so it was pretty easy to fix
* Next is the very exciting question about what happens if you undo the creation of character while in that character's view
  * Presently, the answer to that is "nothing"
    * That is admittedly better than an error happening, but it doesn't quite seem like the correct behavior either
    * Instead, what I feel should happen is that the `OverviewView` is opened
      * Now, I can either do that as an `OpenCharacterViewCommand`, or by manipulating the `ViewRepository` directly
        * Using a `OpenCharacterViewCommand` would fully leverage the power of the `ViewProcessor`, but it would also mean adding a dependency to the `ViewProcessor` to the `CreateCharacterCommand`
        * Manipulating the `ViewRepository` directly would skip that extra dependency, but also mean you could not navigate backward to the deleted character if you restored it
        * Then again, I think it would feel weird to have an extra `ViewCommand` added to the history if you undid the character creation
        * So let's try with manipulating the `ViewRepository` directly and see how that feels
          * It feels more ore less okay, but I still can't shake the feeling that something is lurking in the depths here...
            * Yeah, the view history definitely becomes a bit unhealthy if we do it like this, getting entries that can no longer be reached
        * Okay, so, by contrast, what if we make the `CreateCharacterCommand` call an `OpenCharacterViewCommand` instead?
          * Nope, still gets stuck outside and with the "dead" entry in the view history
        * Right, if both of these result in the same behavior that both times feels basically right, then I suppose the one where we don't have to call a processor from a command is better
        * And the more I think about it, the more I am convinced that there's no real good solution for this anyway, and it probably won't matter anyway, so let's just leave it at that before we get bogged down here
        * Good enough, is, in fact, good enough
* As a last little thing today, I added some functionality to make the `OverviewView` display its contents vertically on mobile
* And I think that's a good point to call it a day at for today

[Time elapsed so far: 70.5 hours]

# 17-Jul-2024

* Now continuing with this

* Last time I added the character view and worked hard on getting the navigation right

* So now I need to finally start on the big thing: The time keys (or whatever I want to call it)

  * Basically, I want to be able to do changes to any data object (for now just characters) at any point in time, and then have the change be present from that point in time onwards, like the keys in video editing software

  * Since I'm gonna be using this logic all over the chronicler, I have to carefully think it through now

    * One question is where the keys are stored

      * Since the keys are always linked to a data object, I figure it makes sense for them to be stored as part of that object

    * As for how they should work, how about I make them something like `KeyField<T>`?

      * That would mean a character would look kinda like this currently:

        * ````dart
          class Character extends IdHolder<CharacterId> {
            KeyField<String> name;
            PointInTimeId firstAppearance;
          ````

      * The `KeyField<T>` would be a list wrapper that features functions for getting the value of the key at a certain point in time

        * That can be done via a map

        * However, it poses the question of how the `KeyField<T>` is supposed to know which value to return if the point in time is not in the map

        * | Point in Time | Character Name Key | Expected value of name | Value if read from map |
          | ------------- | ------------------ | ---------------------- | ---------------------- |
          | 1             | Cyrus              | Cyrus                  | Cyrus                  |
          | 2             | (no key)           | Cyrus                  | null                   |
          | 3             | Ozymandias         | Ozymandias             | Ozymandias             |

        * This problem is made even more tricky considering that the points in time are not fixed, and new points can be inserted between any existing ones

        * Logically, what I would do is to navigate back through the keys until I find the last one that is present

        * However, if the keys are a map, than they won't have a reliable order

        * However, what *has* a reliable order is the `PointInTimeRepository`

        * So, hypothetically, I could go back through that and check for each point in time if it is present as a key in the map

        * That may sound a bit tedious, but it's only something that needs to be done once every time a data object like this needs to be displayed

        * The repositories are on the top of my dependency tree, so it'll be alright for my Data Objects to rely on them

          * ...or will it? Aren't the Data Objects actually above the repositories? The `CharacterRepository` definitely has to depend on the `Character`
          * But I really don't see a better way

        * So let's just try it and see where it gets us

      * Next, let's think about how we want to handle the resolution of the keys

        * It would be easiest if we can just keep using the Character object as it is

        * Theoretically, that should be possible, so long as we hide the `name` field behind a getter that might look like this:

          * ````dart
            String get name => nameKey.currentValue;
            ````

        * That might seem like oversimplifying it, but if we allow the `KeyField<T>` to access the `PointInTimeRepository`, then this would work

        * Also, I don't foresee any situation where  we would need the value of a key not at the current point in time

        * What we will need is functions that allow us to see if there's a previous or next key, as well as get the respective `PointInTimeId` of these so we can create `ActivatePointInTimeCommand`s to jump to these

        * So, comprehensively summarized, what I *think* the `KeyField<T>` needs are the following functions:

          * `KeyField<T>(T initialValue)`
          * `<T> currentValue`
          * `boolean hasNext`
          * `boolean hasPrevious`
          * `PointInTimeId nextPointInTime`
          * `PointInTimeId previousPointInTime`
          * `void add(PointInTimeId pointInTimeId, T entry)`
          * `void delete(PointInTimeId pointInTimeId)`

        * One fundamental question is how to handle the initial value

          * The most straightforward way would be to add it to the key map with the current active point in time as its key, but I can already foresee that making trouble when we want to change the first appearance  of a character
          * Another option would be to make it so that the initial value is a separate field that is returned if no keys are found matching or before the current point in time
            * That sounds like it would be more failsafe, so let's try that

  * Right, with that it feels like I now at least have a good idea for the first approach

    * Let's try it out and see how it works out  
    * Okay, the decision with the initial value is showing some complications
      * Specifically the question is what `PointInTimeId previousPointInTime` should return if the current point in time is before the first key
      * And that is a really tricky thing considering that the `KeyField` does not know which object it is part of
      * However, I think I can make it work by saying that `hasPrevious` also returns true if there are no previous keys but the current value does not match the default value, while simultaneously making it so that `previousPointInTime` returns null in that case, and making the owning object handle that, because the owning object should know its own lifecycle
      * Or, I could pass the `previousPointInTime` function a parameter with the `PointInTimeId` of the lifecycle start
        * Yes, that sounds like a plan
    * Right, I think I've now got the basic logic of the  `KeyField` down

  * Next, I need to make them JSON Serializable so I can save and load them

    * Come to think of it, that could be interesting, what with the generic type and all...
    * I think it might be best to make that class abstract after all and create concrete implementations based on the types of `T` that I need, because like that I could just put the serialization logic into the concrete classes
    * Uggh, JSON serialization is a pain =>,<=
    * And while I was at it, my earlier decision to make the `KeyField` access the `PointInTimeRepository` lightly nipped my tail, because while writing the tests I now realized that I suddenly needed a `PointInTimeRepository` to test the JSON serialization logic, which is just wrong
    * So, re-thinking this, I think I put too much logic in the `KeyField`
    * That logic *probably* belongs in something like a `KeyFieldController`
    * Let's see if I can extract that
    * Yes looks good
    * Now the JSON Serialization seems to work

* This is as far as I'm getting with this today

* The next step will be putting the `KeyValue` into the `Character`, which will also entail reworking the `CharacterView` and  `CharacterViewController`


[Time elapsed so far: 76.75 hours]

# 24-Jul-2024

* Now continuing with this
* Today, I'll try making the name of the character into a `StringKeyField`
  * Okay, getting tricky there, again with the Key Fields
  * The idea of making it resolvable via a controller is proving to become a cumbersome dead end, so maybe I need a `KeyFieldResolver` utility class that can resolve Key Fields of any kind, and which requires only the `PointInTimeRepository`?
  * Yes, but I just realize how much annoying bother this all is
  * Because of all the keying, I suddenly can't access the character name anymore in all the places
    - What I really want to do, from a programming perspective, is be able to call `character.name.currentValue`
    - However, in order to do that, the `Character` would have to know about the `PointInTimeRepository`
    - And yet, if I could do it like that, it would make what I'm doing here SO MUCH easier
    - Is there another way?
    - Looking at the `KeyFieldResolver`, I'd say no, at least not without passing along the entire `PointInTimeRepository` at every call
    - The place where I have the issue right now is in the `CharacterButton`, where I suddenly can't call `character.name` again
    - If I allowed the `Character` to access the `PointInTimeRepository`, then I'd be able to call that here
    - Hm, but I suppose any alternate solution that I can think of is more difficult than simply calling the `KeyFieldResolver` at this time
    - Or is it?
    - Yes, I suppose it is, because I putting the `KeyFieldResolver` inside the character would just make it indirectly dependent from the `PointInTimeRepository` again
  * Okay, it took me some time, and it wasn't straightforward, but it looks like this works now
* Good, so next, let's add functionality to that `StringKeyField`
  * From a command perspective, I need the following three commands for this:
    * `CreateOrUpdateCharacterNameKeyCommand`
    * `DeleteCharacterNameKeyCommand`
  * Aaand, I'll need the same pair of commands for every other key that I introduce, so let's spend a moment to think about whether we can abstract this
    * My first thought is no, since these commands represent a specific combination of a data object and the field contained therein
    * However, they also all operate on the `KeyField<T>`, and the operations they need to perform on it are identical
    * It might be possible to just give them the  `KeyField` directly, and have them perform operations directly on it
    * In that case, I'd just need these three commands, and would be able to re-use them all over the place:
      * `CreateOrUpdateKeyCommand<T>(KeyField<T> keyField, PointInTimeId pointInTime, T value)`
      * `DeleteKeyCommand<T>(KeyField<T> keyField, PointInTimeId pointInTime)`
    * That would be useful, but let's see if it works
    * Well, I laid down the command infrastructure for that now, and that much works
    * I just really hope it also works in action
  * Right, so next, I'll finally get down to doing something on the UI again
    * Again, thanks to the abstractions thus far, I should be able to create a pretty flexible abstract widget for this
    * Oooh, dear, and it seems the earliest point in time ID is not going to survive this much abstraction
      * I can only get the previous point in time ID if I pass along the ID of the earliest possible point in time, which I do know if I have a concrete `Character`, but not an abstract thing
      * But let's see if I can somehow pass it through
      * Or should I just get rid of it?
      * I think it will be cleaner if I do. This whole functionality is for jumping between keys after all, that other thing would just have been confusing
    * I now managed to add the key navigation buttons to the character name field, and they work _almost_ as advertised
      * Toggling keys works, as does navigating back and forth between keys
      * What doesn't work properly yet is the `isEnabled` of the Next and Previous Key navigation buttons
        * Those are correctly inactive while there are no keys
        * However, as soon as there is at least one key, they both become permanently active, which of course is not the intended behavior
        * Okay, I now fixed that. It was due to two things: First a copy-paste error, and secondly a little logic lapse on my side
  * Okay, now the coup de grace will be finally editing the name
    * Wheeee! And it works just like that!
    * BREAKTHROUGH! We won!
* Right, so far, so good
* However, I just noticed that it's presently possible to delete a point in time even though it has a key, that shouldn't be the case
  * I'll have to look into that, but not now
* This is as far as I'm getting with this today

[Time elapsed so far: 83 hours]

# 25-Jul-2024

* Now continuing with this
* Today, I want to focus on making it so that points in time can't be deleted if a character has a key on them
  * I have no idea whether this is going to be easy or hard
  * It's probably good to do this test-driven, starting from the `time_bar_controller_test`, which already has a test case for "Point that is first appearance of character should not be deletable"
  * Well, it's probably gonna be easy, but it's hard to think of a way that won't require me to add logic there each time I add a new keyed field anywhere
    * And that's gonna get even harder if I consider how I want to have meaningful reasons why a point in time can't be deleted
      * For example, I want a message like "Can't delete point in time because the name of Character Ozymandias changed at this point"
    * The crux is that the keys are inside the Character (and later other) object, and only the objects with the keys know how their keyed fields are called
  * Okay, I think I now found a solution that works reasonably well
* This is as far as I'm getting with this today

[Time elapsed so far: 84.75 hours]

# 31-Jul-2024

* Now continuing with this
* Next, I want to make the First Appearance of a character editable
  * That should be a dropdown list
  * There's gonna be a lot of tail to both this and the last appearance, such as:
    * The first appearance can't be after the last appearance
    * While a character view is opened, only the points in time where that character is active should be selectable
    * How to deal with keys regarding which points in time are selectable
  * But one thing after the other
  * For starters, I'll focus on having a dropdown field for the First Appearance from where you can select a point in time
  * Fortunately, this is not gonna be a KeyValue, so at least that's gonna be easier
  * This looks like a good place to start:
    * https://api.flutter.dev/flutter/material/DropdownMenu-class.html
    * Oh dear, this looks complicated
    * Okay, but it turns out it was actually not all that complicated
  * Next, to enable jumping to that point in time
    * That was a bit tricky, but I now managed to do that
    * I think I really messed up with the buttons there =>,<=
  * Right, next I want to make it so that only points in time before which no keys happen are can be set to the first appearance
    * Aaand, I think the design choice to make the `CharacterView` depend on a `CharacterId` instead of a `Character` bit me once too often, so I'll try to change that now
      * I think that worked
    * And I now did that
  * Next, I want to make it so that if the first appearance is changed to a point in time that is past the currently selected point in time that new first appearance is selected
    * I now managed to do that
    * However, via "Go Back" it is still possible to go back to the previous view, and I don't really see a good way to get around that with the current logic since that will require the view commands to know about a lot more
    * But then again, I may need to rework that anyway to enable the requirement that points in time become unavailable based on which character is selected and what that character's first and last appearance is
* Anyway, this is more complicated, so I won't get it done today
* This is as far as I'm getting with this today

[Time elapsed so far: 88.75 hours]

# 26-Sep-2024

* Now continuing with this
* I'll now deal with some issues related to the characters and when they are active
* While in a character view, the points in time before the character's first appearance should be greyed out and unselectable in the time bar
  * That is actually kinda tricky
  * The issue is that this requirement suddenly means that the `PointInTimeButton` needs to know something about the state of the program that goes beyond the points in time
  * But I think it can work, because the `ViewRepository` is on a very base level, and I should be able to get the necessary information out of there
  * I could check if the `mainViewTemplate` is a `CharacterViewTemplate` and then  check against that, but I think I can also abstract that a bit
  * Okay, so far, so good, but now I am stuck at trying to create a `TimeBarPanelController` that the `PointInTimeButton` can use, but for some strange reason now the test 'Deleting first point in time should make remaining point in time active' fails, and I can also observe that strange behavior live
    * It would seem that for some strange reason, the `isButtonEnabled` method is not called for the remaining button, even though that should happen
    * `TimeBarPanelController` extends `ProcessorListener`, so the watched method should trigger when an update in the proecessors happens
    * But strangely, that only happens for the `TimeBarPanelController` of the disposed old `PointInTimeButton`
    * Ah, okay, I think I understand the problem, even though I don't really understand why it behaves like that
      * Apparently, the `PointInTimeButton` for the second point in time addresses the `TimeBarPanelController` from the first `PointInTimeButton`, which is really, really horrible behavior! =>,<=
      * Okay, I now solved this by putting the functionality into the `TimeBarController`, passing along the relevant Point in Time as a parameter, which is not ideal but at least it works
  * Okay, now that I have that in the `TimeBarController`, I can finally write a unit test for this
  * Annd, I basically got it to work, only the tooltip if the button is inactive still statically displays "This is already the active point in time"
    * I now did that
* Now I have the interesting "problem" that I can no longer discern which point in time is currently active, because the button for the active point in time looks the same as all other inactive buttons
  * I now managed to fix that by playing around with various effects
* Next issue...
* After changing the first appearance of a character to a point in the future (which causes the active point in time to be set to that point), it should not be possible to navigate back to the previous point in time
  * If I'm lucky, then the work above has already paved the way to fix this with relative ease
  * I think that needs to be done in the `ActivatePointInTimeCommand`
  * But before that, I can definitely first write a test for this
  * Okay, and building on that, I was actually able to get this working with relative ease
* And that's already as far as I'm getting today, but at least I managed to sort out all the open ends from July

[Time elapsed so far: 93.5 hours]

# 28-Sep-2024

* Now continuing with this
* Next, I want to add a "Last Appearance" field to the Character
  * That one is very similar to the First Appearance, so hopefully that'll be easier to do
  * The main difference is that this one can also be empty
  * Right, I got the basic functionality down now, but there's still a few things I need to implement:
    * Points in time past the last appearance should be unselectable, similar to first appearance
      * Thanks to the groundwork I laid down last time, that was very easy to implement
    * Currently it's still possible to select a point in time as first appearance that is after the last appearance 
      * I was able to get that to work too now
    * Removal of the last appearance is currently not yet implemented
      * I now implemented this via a button (because it didn't want to fit a "null" option into the dropdown)
      * However, that has still the little cosmetic bug that while removing the last appearance works for all logical purposes, it still stays in the dropdown box
        * I tried working around that, but it seems in order to fix that I'd need to do some major rework about that whole logic there, which is really not justifiable at this point, so I'll just leave it at this 
* This is as far as I'm getting with this today
* Now all that's left for V1-0 is implementing the deletion of characters

[Time elapsed so far: 96.75 hours]

# 19-Dec-2024

* Now continuing with this
* The current status is that we have characters and incidents done
* Next, I want to work on adding locations
* What does a location need?
  * ID
  * Name
  * First and last appearance
  * Connections to other locations
    * Adjacent locations (with directions)
    * Locations within a location
* In addition, characters need to be able to be at locations, and move between locations
* Looks like locations actually have a lot in common with characters, and I can foresee other types also sharing these similarities, so let's see if we can extract an abstract base class out of these
  * The likenesses are some sort of ID, name, first appearance and last appearance, which as of now are all the fields that a character has
  * Ugggh, easier said than done, because I need to figure out how to abstract garbage like    `CharacterId.fromString(json[IdHolder.idKey])`, because I can't just write `T.fromString(json[IdHolder.idKey])` =>,<=
  * Well, I got it to work now
* Right, now with that groundwork done, I hope adding locations in their simplest form should be pretty easy
  * Alright, so having locations in their most basic form works now
  * That means, they exist as data objects analogous to the Characters in the code now, and JSON parsing works, but I'm not doing anything with them yet
* Next will be saving and loading the locations, along with everything else
  * Right, that works now too
* Next, I'll start adding the UI elements for this, beginning with the Location Overview
  * Hmm, this is very similar to both the `CharacterOverview` and the `IncidentOverview`, so let's see if we can unify the common elements from them
    * Yes, and using Chatty to do so was really time-efficient too! 
  * Okay, so, the `LocationOverview` first needs the following components to be ready:
    * `LocationOverviewController`
    * `LocationButton`
    * `AddLocationButton`
    * Again, that's a lot of repetition from what I already have for the characters and incidents, so let's see what I can simplify
    * The `CharacterOverviewController` and the `IncidentOverviewController` are actually quite different, since you can re-order incidents, and incidents are not temporal entities
      * However, since locations *are* temporal entities, I should be able to create something like an `TemporalEntityOverviewController` that I can use as base for both `CharacterOverviewController` and `LocationOverviewController`
        * I now managed to do this again with relative ease through use of Chatty, but also uncovered a bug in the process that was already in but unnoticed before:
          * Characters still get displayed in the overview at points in time beyond their last appearance
            * I now fixed this
    * Right, now that I'm done getting sidetracked, the next thing is the `LocationButton`
      * And for that, I need the `OpenLocationViewCommand`
        * ...at least if I want to simplify it with the `CharacterButton` right away, which is something that I think I will pass upon for now in favor of simplicity
        * But I'll probably do it later
    * And finally, the `AddLocationButton`
      * That one definitely needs the `CreateLocationCommand`
        * Let's see if I can also just simplify this from the very similar `CreateCharacterCommand`
        * Aand, that one needs an `LocationViewTemplate` in turn 
          * And that one in turn needs the `LocationView` =>,<=
            * And that one in turn needs a `LocationViewController`
              * Alright, let's just copy all of that for now, and then worry about consolidating it in the next step, because I've just made the experience that Chatty is really good in consolidating if you feed it two cloned classes
      * Okay, no, wait, this is clearly getting too much, I need to pull an emergency break here somewhere
        * How about at the `LocationView`? I can probably just make that into a `Placeholder` for now
        * Yes, that should put me into a stable float
  * Okay, I now managed to add the `LocationOverview`, and it looks like that much works nicely, including saving and loading
* Now, time for some cleanup
  * I finished some cleanup now, but there's still more to do
* This is as far as I'm getting with this for today

[Time elapsed so far: 102.25 hours]

# 20-Dec-2024

* Now continuing with this
* First, I want to start with some leftover refactoring, consolidating classes that are very much alike
  * Aaand, I got caught up right away in an issue that I already had with the repositories, and for which I now created a help request:
    * https://stackoverflow.com/questions/79296839/dart-how-to-condense-connected-nested-generics
  * Anyway, I now managed to consolidate the `CharacterViewTemplate` and `LocationViewTemplate`
  * And I think that's enough refactoring for now
* Next, to try and get the location view to work
  * This works now with a placeholder view
  * Now to flesh it out
  * That requires a whole bunch of commands first for updating the last and first appearances of the location
    * I already got all that for the character, so is it possible to re-use them somehow?
      * Yes, looks like they work just as well with `TemporalEntity` instead of `Character`
  * Aaand, now it looks good
* Right, next I want to make it so that characters can be at locations
  * For that, I can either add a field to the location with the list of characters there, or add a field to the character with the location he is at
    * I think the latter makes more sense, since a single value is always easier to handle than a list, and that also implicitly results in the character not being able to be in two locations at the same time
    * Also, it makes keying easier
  * So, how did these Key Fields work again?
    * I think first of all, I need a new type of Key Field here, since thus far all I have is `StringKeyField`
    * And I need to slightly rework the `KeyField`, since the initial value of the location that a character is at can be null, if the character has not been assigned to a location yet
      * Aaaand, once again, that's not so easy
      * The problem is the Json serialization and deserialization which requires concrete types, but let's see...
      * Aaand, making that nullable cascades so hard =>,<=
      * But I think I now got it to work
  * Right, now let's try adding that to the Character
    * Now it's getting tricky biting through all the layers of abstraction that I introduced earlier
    * And JSON parsing, which is SO ugly and takes SO much time
      * I really miss Java, where there are well-tested frameworks for that
      * Here, I have to painfully hand-craft this every time, running into many amazing errors along the way
    * Okay, but I think I got this to work now, at least on a model level
  * Next, let's try adding that as a field to the `CharacterView`
    * Unfortunately, that has a number of time-related edge cases
      * For starters, only locations that exist at that point in time should be available
        * ...which immediately brings the problem of "what if a location becomes unavailable later" with it
      * At the same time, of course that also means that I need to work it into the checks for available first and last appearances of locations
      * Oh Dragon =>,<=
      * I'd better write some acceptance criteria for all that and then work on them one at a time
    * However, in a nutshell, the location functions a lot like the last appearance (which also means we'll probably get that known issue with dropdowns again, just great =>,<=)
      * Except it's of course different again, because the last appearance was not a `KeyField`, and the fact that the location's name is a `KeyField` falls on my tail at the very last moment =>,<=
      * And have I recently mentioned just how much I hate how the `DropdownMenu` is implemented in Flutter?
    * Okay, so the first step is done, I managed to put the dropdown in place, it gets populated with all locations right now and doesn't save anything on selection, but it is displayed and displays the right locations, plus an extra "unknown" location that is hard-coded into the controller (not super happy with that, but given how the `DropdownMenu` is implemented in Flutter, this might very well be the best way)
    * Good, next let's implement the functionality, which will involve a new command
      * Or wait, can I just use the `AddOrUpdateKeyCommand` for that?
        * Yes! Very convenient!
        * Looks like past me saved me a ton of work here
      * Now this works
    * Right, that is the very basic functionality of assigning locations to characters down
  * Alright, next up is the whole batch of temporal edge cases
    * Starting with "Characters can't be assigned to locations that do not presently exist"
      * I got that to work now, but also observed the following unintended behavior:
        * Repro:
          1. Create a location
          2. Create a second point in time
          3. Create a character
          4. Open the character view for that character
          5. Assign the character to the location at the first point in time
          6. Move to the second point in time while in the character view
          7. Try to make the character's location "unknown" for that point in time
        * Expected behavior:
          * The character's location is now "unknown"
        * Actual behavior:
          * The character's location remains unchanged
      * Fortunately, I know why this happens, I just did not fully think they keying behavior here through
        * So let's fix that now
        * Hm, okay, so this is apparently more complicated
        * The problem seems to be with adding null keys to a `KeyField`, which makes this troubling
        * I now got that to pass, but the changes I needed to do for that broke some other tests
          * Let's see if I can fix them
          * Okay, looks like what broke are some equality checks, let's see...
          * Okay, looks like my `MapUtils.areEqual` returns `false` because of a discrepancy with the `runtimeType`, let's see if I can figure out where that comes from
            * As expected, it fails because `_Map<PointInTimeId, String> != _Map<PointInTimeId, String?>`
            * But where does the first come from? I thought it should all be the second now...
            * Right, so for some strange reason, the decoded map runtime type is `_Map<PointInTimeId, String>`, even though according to the IDE, it should be `_Map<PointInTimeId, String?>`
            * Okay, I now found the two places where I needed to add extra `?` to get this to work, it was in the `decodeKeys` functions of the `LocationIdKeyField` and `StringKeyField` respectively
              * °sigh° this is getting uncomfortably rusty
          * Anyway, now all the tests pass again
        * And what about the functionality?
          * Most of it works, but loading a chronicle with a null key for locations causes an exception
            * Neat! I don't have a test case for that yet!
          * Okay, I now fixed that, and wrote a test for it while I was at it too
      * Right, now that much seems to work...
* Okay, so next I want to add proper keying behavior to the locations, which most notably means the three buttons that the name key fields already have
  * The name fields are `StringKeyFieldView`s with their own `StringKeyFieldController`s, which is great, only now I have a dropdown of course instead of a string field, which makes everything so much more complicated again =>,<=
  * For the name fields, this works pretty great, since apart from the field, they have no dependencies, but unfortunately, the dropdown brings so many dependencies with it...
  * But let's see what I can do
  * I now did that, and I am genuinely impressed that it was actually really easy to implement and seems to work without a hitch
    * This worries me
  * Ah, okay, I found some bugs
    * One I already fixed
    * Another is that trying the remove a null key causes an exception
      * Right, now I managed to fix that too
* Finally, I also noticed that I didn't implement it yet that locations that already had their last appearance can't be assigned 
  * Right, now that works too
* This is as far as I'm getting with this today

[Time elapsed so far: 111 hours] (nice! =^,^= )

# 23-Dec-2024

* Now continuing with this

* Right now, I need to take care of some temporal edge cases that come with the relation between characters and locations

  * Really though, I don't know if it's good to constrain things too much there
  * Maybe it's better to let the user manipulate character and location first and last appearances individually, and make a general behavior for when a location and/or character are not available
  * Let us think about the cases
  * Basically, the only situation that I have now is that a character can exist at a time when the location does not
    * In that case, the location should be displayed as "unknown"

* Let me take a step back here

* First, I should make it so you can jump between locations and characters

  * And for that, I need to change how the location is displayed in characters

    * Right now, it is a dropdown
    * But what I really want is for there to be a button that you can click on and jump to the location, if it exists
    * And you only need the dropdown while editing it
    * So really, the location field is much closer to the name field, except it contains a clickable button

  * Right, so since the editing functionality is kinda crucial to verify all this, maybe I should start with that

    * Basically, I want an edit button, and if that one becomes activated, I want a popup where you can select the location from the dropdown

    * So, I need a `DropdownDialog` that functions analogously to the `RenameDialog`

    * That's actually not so easy because of how all the things are interconnected...

    * It starts at the `LocationIdKeyFieldView`, where I need to put it

      * At this point, I have the `LocationIdKeyField`, and I already have functionality in place to get all valid locations from the controller there

      * That is specific functionality, since what is valid will be dependent on each use case

      * However, in the `DropdownDialogController`, I need two things:

        * The key field, which I can pass on no problem
        * A list of valid entries, including their display names, which is  a bit more complicated
          * This is because the key field is a `LocationIdKeyField`, which is a `KeyField<LocationId>`
          * So, if I make the `DropdownDialog` and it's controller extend something with the generic `LocationId`, then I won't be able to read the name from it there
          * I think the best solution for the time being will be to just make use of the  existing `List<DropdownMenuEntry<LocationId>> get validLocationEntries` in the `LocationIdKeyFieldController` and pass that along
        * At least that makes a sort of sense: By doing that I tell the `DropdownDialogController` what field should be modified, and also what entries should be in the dropdown and how to display them

      * And now I get fun errors when trying to hit the confirm button:

        * ````
          Tried to listen to a value exposed with provider, from outside of the widget tree.
          
          This is likely caused by an event handler (like a button's onPressed) that called
          Provider.of without passing `listen: false`.
          
          To fix, write:
          Provider.of<SelectKeyDropdownDialogController<dynamic>>(context, listen: false);
          
          It is unsupported because may pointlessly rebuild the widget associated to the
          event handler, when the widget tree doesn't care about the value.
          
          The context used was: Builder(dependencies: [_InheritedProviderScope<SelectKeyDropdownDialogController<LocationId>?>])
          'package:provider/src/provider.dart':
          Failed assertion: line 274 pos 7: 'context.owner!.debugBuilding ||
                    listen == false ||
                    debugIsInInheritedProviderUpdate'
          ````

        * I won't claim to in-depth understand what's going on here, nor will I try to, because I am already reasonably sure that the issue here is that I naively assumed that firing a command inside the popup would maybe just work =>,<=

        * But never mind, I can also just have the popup return the value that I need and fire the command on that, even if that means introducing yet another controller level =>,<=

        * Hmm, nope

        * Weird

        * And somehow the popup doesn't close either

        * It closes when I click the "X" though

        * Weird

        * Okay, I think I got it to work now

          * I *think* the issue might have been that it didn't like me access the controller inside the `onPressed` method of the `TextButton`, but I'm not sure

      * Right, it took some effort, but I now managed to make the location appear as a clickable button in the character view 

* And I think with that, I finally got the whole "assigning locations to characters" down

* This is as far as I'm getting with this today

[Time elapsed so far: 114.25 hours]

# 24-Dec-2024

* Now continuing with this
* First of all, I want to fix a bug that I came across while testing:
  * Trying to load a chronicle while a location is opened causes an `PointInTimeNotFoundException`
  * I could go into detail in analyzing this, but I'm fairly certain that the issue here (and it would probably also happen in the character view) is that loading a chronicle while inside a view presently does not return to the overview view, which naturally causes trouble if the loaded chronicle has different points in times, characters and locations
  * Yes, that was an easy fix!
* Okay, so, next I want a location to display the characters that are present at it and allow navigation to it
  * This is going to be similar to how the current location is displayed in the character view, only editable
  * Yesh! This was pretty straightforward to accomplish!
* Next, I want to tackle relations between locations
  * Parent-child relations are going to be the easiest, so it'll make sense to start with those
  * So, I definitely want these to be non-temporal, because temporality always causes pain, and I see no reason why relationships should be temporal that is important enough to justify this pain
  * I also definitely want to make it analogous to the way I linked characters and locations right now, so that you can click on the location to jump to it 
  * One question here is how nazi I should be about guarding against logical garbage here
    * For example, should I implement logic to prevent for locations to be their own parent? or the parent of their parent?
    * I think the answer is no, because while it makes no sense within a world, as soon as you enter Minayero, strange things like that suddenly become possible
    * So yeah, let's leave the control at an absolute minimum level here for now
  * Okay, the basic functionality works now
  * However, for some strange reason, jumping to the location by clicking its button does not work yet
    * That is actually really weird
    * Stupid view logic, why did I ever get it into my head to try and program something like this myself? =>,<=
    * I now added additional logging, and according to the logging, the location _should_ be opened
    * And I added even more logging, confirming that the internal program state says that the correct location view should be displayed
    * And yet it doesn't
    * How come?
    * Here's what I observe:
      * ✔️ Click `Child Location` in `Overview View` > `Child Location` "Opened Child Location"
      * ❌ Click `Parent Location` in `Child Location` > `Child Location` "Opened Parent Location"
      * ✔️ Click `Overview View` in `Child Location` > `Overview View` "Opened Overview View"
      * ✔️ Navigate back > `Parent Location` "Opened Parent Location"
      * ❌ Navigate back > `Parent Location` "Opened Child Location"
      * ✔️ Navigate back > `Overview View` "Opened Overview View"
    * So, from what I can tell, whatever the root cause is, it seems that the internal program structure is correct, and the issue is with the view not updating
    * Okay, turns out that this was because the `LocationView`s didn't have unique keys
      * I now fixed that by giving it the identifiers of the locations
    * Well, glad that fixed that, but still, that was an unnecessary waste of time for something that turned out so trivial
    * So I now also fixed that for the CharacterView, so I won't run into that there later
* This is as far as I'm getting with this today

[Time elapsed so far: 119 hours]

# 26-Dec-2024

* Now continuing with this
* Next, I want to add the equivalent "Child Locations" field to the other locations
  * Well, that went really nine and quick and easy
* Next, I want to make buttons of locations that do not presently exist are clicked-out and unclickable
  * Since that is something that affects all temporal entities, let's see if I can find an universal solution for that 
  * I now managed to do that
  * However, I noted that this has the issue that if an entity from the future is displayed, it is always displayed as "New Location" or "New character", because the name only changes via key once it appears
  * Maybe it's better not to display them at all after all
    * I now did that, and I think it looks better that way
* Next, before I continue with connected locations, I think I really want to add a location level, since even with only a few locations for testing presently, things are starting to get a bit messy
  * I'm not sure how much a location level will help there, but it'll definitely be better than not having one
  * I now did a considerable amount of work there that went so fluidly that I didn't pause to write about it here, and it's starting to look really good
  * Next, I want to add that you can't lower the location level to that of your children or below
    * That now works
  * And the inverse would be making it so that the level can't be equal or higher than that of its parents
    * And that works now too
* This is as far as I'm getting with this today

[Time elapsed so far: 125 hours]

# 27-Dec-2024

* Now continuing with this
* Today, I'll start with some cleanup related to the locations
* First, I want to try merging `EditParentLocationButton` and `EditLocationLevelButton`, since they are quite similar, and I can imagine needing more buttons like that in the future
  * That took some skill, and Chatty only produced suboptimal results when processing that, so I had to do it manually
  * However, the result is well worth it, because it works great and looks B E A utiful! =^,^=
* Next, I want to split the `LocationView` into two columns because it is already getting full with all the connected locations that I have, and it's only gonna get more
  * That will require modifying the `TemporalEntityView` in some way, but it can definitely be done
  * I now managed to do that
* Next, I still have to add that the parent location can be removed
  * Right, that now works too
* With that, I think I am now ready to proceed to sibling locations
  * This one is probably gonna require a new data object and a repository for connections, since clearly I can't save the sibling in just one of the two
  * I now managed to create the data structure for this
  * And I now managed to set up the layout for this as well
  * And the commands are working too
  * Next, I need to bring it all together in a nice way
    * That took a bit, but now it looks nice
  * Now all that's left is adding the functionality to break connections
    * That now works too
  * With that, sibling levels are now basically done
* However, I have still found some minor issues
* For one, it should now also not be possible to select a location level that is different from the adjacent locations (or not set)
  * I now fixed that
* Next, there's the issue that inactive adjacent locations should not be displayed 
  * Okay, that works now too!
* With that, the locations should all be good for now!
* As a bonus, let's see if I can get the locations sorted by level and alphabet in the `LocationOverview`
  * Well, sorting them by level works already
  * And sorting by name was a bit more complicated due to key fields, but ultimately still worked out
* It would be great to be able to implement location sorting everywhere, but before that I must address the lack of scrolling behavior, and the resulting overflows, especially when considering that adding many locations is a thing that will very likely happen
  * Alright, that works now too!
* This is as far as I'm getting with this today

[Time elapsed so far: 133.25 hours]

# 28-Dec-2024

* Now continuing with this
* I tried to install the Ceal Chronicler on my cellphone again, but got a weird error, which seems to stem from me using a Java version that is too new
  * Okay, this is getting ridiculous! I am just slipping from one error into the next here!
  * I now created a new flutter project, and can install that one on my cellphone just fine
  * Right, so maybe I can merge the parts that work from there in a sensible way
  * Okay, it took a lot of back and forth, but in the end I managed to get it working again
  * Looking at the git diff, here's what I changed:
    * `android/app/build.gradle` got a complete makeover; I pretty much copied it from the new flutter project
    * "package="com.tri_tail.ceal_chronicler_f"" was removed from the three files `android/app/src/*/AndroidManifest.xml` 
    * In the `android/build.gradle`, the "buildscript" block was dropped
    * In the `android/gradle.properties`, the first line was changed to `org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G -XX:+HeapDumpOnOutOfMemoryError`
    * In the `android/gradle/wrapper/gradle-wrapper.properties`, the `distributionUrl` versopm was changed to 8.3
    * `android/app/build.gradle` got a complete makeover; I pretty much copied it from the new flutter project
    * In the `pubspec.yaml`, I updated all dependencies to the latest version, and the environment to ^3.6.0
* Right, now back to the issue at hand: making the app usable on mobile too, because right now it overflows like dragon
  * Alright, now while it is still certainly not "designed for mobile", at the very least it doesn't overflow anymore (at least not in the most important places), so I can now show it to people wherever I go
  * Making a version that is actually mobile-friendly is not something that I have time for right now though, so I'll leave it at "mobile-passable"
* Since I don't want to start anything big today anymore since it's already late, let's take care of some minor issues that I found along the way
* First, locations should not be allowed to connect to themselves
  * While there might be edge cases where this makes sense, in most cases this just clutters up the selection menu with an extra unneeded option, so let's get rid of it
  * I now did that
* Next, I want to implement location sorting... well, ideally everywhere
  * The best location to do that would be the `LocationRepository`, but I'm actually not sure if that would have some weird and unintended side effect
  * Welp, let's just try it and see what happens! 
  * Mmh, yeah, I figured this wasn't going to work
  * The main issue is that I want to sort by name, and in order to get a location's current name, I need the `KeyFieldResolver`,, which depends on the `PointInTimeRepository`
  * So while it would probably work, putting it into the `LocationRepository` would start breaking the architecture
  * So let's not do that
  * Right then, how do I then do that in a way that does not break the architecture?
  * How about adding a `LocationSorter` class that is located below the repository level?
  * Yes, and while that requires me to add two extra lines (three if you count the import) everywhere that I want to sort the locations, I think all things considered, this is the most flexible approach
  * So this works now
* Next, status bar messages when deleting keys use the ID of the point in time instead of the name
  * That should be about the `DeleteKeyCommand`
  * Okay, this is a two-fold issue, because this not only refers the point in time, but also the deleted value, and while the former is always a `PointInTimeId`, the latter is a generic type, so it might be more complicates
  * I should definitely be able to name the point in time though
  * Okay, now that works nicely for the points in times, and it works great for string key fields like the name as well
  * However, present locations for example still return IDs for the value
    * Thinking about that, I don't think there's a lot that I can do about that, since what is saved in that key field is literally a location ID in this case, and may be literally anything else in other cases
    * I could theoretically write a massive resolver for that, but I don't think doing that just for the status message is worth it 
    * But at least I can somehow prettify it a little
* This is as far as I'm getting with this today

[Time elapsed so far: 137.5 hours]

# 30-Dec-2024

* Now for the grand finale

* There's really just one more big thing that I need to complete for the Ceal Chronicler to be really usable, and that is parties

  * Specifically, the point of this is being able to group characters and move them around as a group instead of having to move each character, because that is something that is going to happen a lot

* I wonder if I'll be able to finish this today, but I'll definitely try

* This is really a complex thing, so I'll do it one step at a time

* First step is making parties exist in the first place

  * In essence, they are just normal temporal entities without any special properties, so this part might be pretty easy
  * Right, that's done now
  * It was straightforward, but still took a bit of time

* Good, so after that now comes the more difficult part

  * The key point here is specifying how parties and characters should behave in interaction with one another
  * Basically, a party should allow characters to travel as a group
    * That means that a party should display all characters in it, and allow for a change in location which then affects all characters
    * This also means we need functionality to add or remove characters from a party
    * The tricky thing here is how it should work with regards to characters who already have a set of locations they travel around, and then are added to a party, and possibly removed from it
      * One way would be saying that the party location overrides the character locations, but I think that would result in unintuitive behavior where removing a character from a party would change its location
      * The alternate approach would be letting the party modify the character's locations directly
        * That would mean that the party itself has no location, which makes sense on a conceptual level since if no one is in a party, then the party is effectively nowhere, and as long as exactly one character is in a party, then the party is where that character is
        * That would mean also mean that all characters in a party are always in the same place, which is kinda the point of parties
      * That latter approach sounds like what we want here
    * Now let's see what that necessiates
      * First off, the party does not have a location field in its data model
        * The party's displayed location is determined by its characters
          * If no character is in a party, the party's location is unknown
          * If multiple characters are in a party, the locations of these characters should be in sync, so the party can just display the location of the first character that is presently within the party
      * Second, since a party dictates a character's location, it makes sense that a character can only be inside one party at a time, which means party affiliation is something that should be saved in the character
      * Character adding behavior:
        * When the first character is added to a party, nothing special needs to happen
        * When subsequent characters are added to the party, the locations of those characters starting from their joining the party should be overridden by the party's locations
          * Undoing this might be a bit tricky
      * When a character is removed from a party, nothing special needs to happen; its locations stay the way that the party modified them
      * Once a party has at least one active character, its location should become editable
        * Editing a party's location should edit it for all active characters 
  * Okay, that is pretty complex, but I think I can do it if I do it step by step

* First, let's focus on adding characters to parties without worrying about any of that location garbage

  * That should actually be very similar to adding characters to locations
  * ...except it is going to diverge when it comes to the standardized key fields and associated commands that I have, because adding characters to parties, as discussed above, requires some really sophisticated logic
  * But we'll worry about that when we get to it, and focus on the very basic functionality for now
  * Alright, so adding characters to parties in this most basic way works now, and so does removing them
  * And now the characters are also being displayed in the parties

* Now there's a bug that prevents me from loading my existing chronicle

  * I now fixed that

* Right, and this is the point where there's no more putting off the complicated stuff

  * On the upside, I have found out that the panels for displaying and editing the party ID are actually not standardized, which might make changing their behavior at least a little bit more easy

  * However, the button used for adding characters at locations is still a generic `SelectKeyButton`

  * So, how do I do this?

  * The point is I need something like an `AddCharacterToPartyCommand` that I can use here, but how do I get it all the way in there?

  * Hmm, the `ToggleKeyButton` is more customization friendly than the `SelectKeyButton`, because it allows me to pass a `KeyFieldController controller` inside

    * Let me see if I can make the `SelectKeyButton` work the same way
    * Looks like that works. That'll make things easier
    * Because like this, I can now override the methods in question inside the `PartyIdKeyFieldPanelController` to make them use the `AddCharacterToPartyCommand` (or whatever I'll call it)

  * That command is going to be the heart and soul of this whole thing, and it is going to be a bitch to write and test, but everything stands and falls with this one, so I gotta be extra thorough here

    * One more thing I need to keep in mind here is that if a character is assigned to another party at a future point in time, then of course the location keys should only be changed up until that point
    * I'd better write down a checklist for all that in the requirements below
    * I now created a `PartyLocationResolver` which also contains crucial logic here, which has the advantage that I can test that separately
      * Moreso, I can actually use that to to test that a party shows the correct location even without the  `AddOrUpdatePartyAffiliationCommand` up and running yet
      * Sadly, it isn't
      * Weird, it works in the tests though
      * Aaand, just realized something that makes it even more complicated:
        * If a character joins a party, and is already assigned to a location before joining the party, the party's location should be the character's location as soon as it joins the party
        * Oh dragon, this is gonna get so ugly...
      * Okay, it took some while, but now I'm reasonably certain that the `PartyLocationResolver` works as intended... probably

  * Right, now back to the `AddOrUpdatePartyAffiliationCommand`

    * I'll do this step by step

    * First, the basic functionality just for adding characters to parties, without touching the locations, so I have a solid base to build the more complex stuff on

      * That looks like it works now

    * Right, and now the more complicated location modification

      * I'm going to start with a test case here that specifies the behavior I want to see in the end

      * Here's how the locations should look like:

      * |                                   | Prologue                  | Chapter 1 | Chapter 2 | Chapter 3 | Chapter 4               |
        | --------------------------------- | ------------------------- | --------- | --------- | --------- | ----------------------- |
        | Sylvia                            | (before first appearance) | Aidenous  | <-same    | Vaught    | (after last appearance) |
        | Party with Sylvia                 | (null)                    | Aidenous  | <-same    | Vaught    | (null)                  |
        | Bokay                             | Fienyn                    | <-same    | Kiehlero  | <-same    | <-same                  |
        | Bokay added to party in chapter 3 | Fienyn                    | <-same    | Kiehlero  | Vaught    | <-same                  |
        | Party after adding Bokay          | (null)                    | Aidenous  | <-same    | Vaught    | <-same                  |

      * I wrote a test case for that that fails as expected, and DRAGON is that already looking vicious

      * Now to try and get it to pass

      * I think that works now

  * Right then, the last thing for this year will be adding that command to the `PartyIdKeyFieldPanelController`

    * Okay, that is regrettably not as easy, and I just had to revert a bunch of changes because they caused tests to fail in an incomprehensible way
    * The main problem is that I built the `AddOrUpdatePartyAffiliationCommand` in such a way that it requires a `Character` and a `Party` object each, but at the point it is executed we have neither
    * We should be able to fetch em though
    * I _think_ it now works?
    * Not really, no
    * Sadly, I'm out of time to debug this now
    * That's a shame. I really had hoped I could bring this to a clean finish this year

* This is as far as I'm getting with this this year

* Don't even have time for a retrospective =>,<=

[Time elapsed so far: 147.25 hours]

# 1-Jan-2025

* Now continuing with this
* I have thought about this, including how much pain the present approach to the party locations is causing, and how many twisted things result as a consequence of this, and have decided to make it different instead
  * Instead of how I planned it, I am gonna make it so that parties have their own set of present locations, and that those simply overrride the character locations while a character is inside a party
  * That's not gonna make it inherently worse than the original design during normal use of the chronicler, and it's gonna be just SO MUCH easier to implement since this effectively makes the Party a location of the Character
  * First, cleanup though
    * I now purged the old, messed-up approach to party locations from the code
* Next will be giving a present location field to the party
  * I was able to do that easily as well
* Next will be making it so that characters in parties are displayed to be at that location if they are in a party
  * That also goes for locations
* This is as far as I'm getting with this today

[Time elapsed so far: 147.75 hours]

# 2-Jan-2025

* Now continuing with this
* I am still in the middle of making it so that the party location is displayed in character instead of the character location if the character is in a party
  * That now kinda works, only that for some strange reason the `isPresentlyInParty` sometimes apparently returns true even if the character is not presently in a party, which is weird
  * Looks like I might be having an issue with the null party ID here
  * Found and fixed that
  * Now this works
* Next, let's work on making it so that in the location view, characters who are in parties are displayed at the locations of their parties, not at their overridden individual locations
  * That was surprisingly easy to accomplish
* With that, the parties are now up and working
* This is as far as I'm getting with this today
* And with this, the Ceal Chronicler f, after precisely one year of development, has reached a state that I would consider usable
  * Since it was a fragmented effort though, let's put it into perspective
  * The time I spent on this was less than half the time I spent on the AIG migration at work during the last time
  * It is roughly equal to the time I spend working at my job in a month
  * And it is roughly equal to the time I spend programming at my job in two months
  * So although it took me a year to get this far, the current state more likely represents about a month of focused work, or about two months of less focused work 

[Time elapsed so far: 148.5 hours]

# 6-Jan-2025

* Now continuing with this
* This is probably the last I'll work on this for a while, so let's try bringing this to a clean close today
* As it is, I have characters, incidents, locations and parties, which is good
* Something that really is still missing, however, is something versatile that I can use to bridge anything that I could not directly address yet, such as items, skills, knowledge, species, characteristics, etc...
  * I think I'll do that by giving each temporal entity a list of fixed and temporal attributes, that should provide a good amount of flexibility and also be easy to implement
  * The attributes are quite similar to the incidents, and yet a little different
  * It still took a while, but the permanent attributes work now
    * They are great for tracking things that don't change, such as species
    * And since I just realized I was mostly using them with labels in the value, I figure I can make it so that the labels are separate
      * I now did that
    * However, now I seem to have a weird bug when moving attributes up and down
      * Looks like `canAttributeBeMovedUp` and `canAttributeBeMovedDown` don't update correctly for some reason
      * Okay, that was due to the key bug again where Flutter treid to be overly efficient, and thus caused erratic behavior
        * Managed to fix that by assigning an attribute-dependent key to the `AttributePanel`
* Okay, that's that
* Next, temporal attributes
  * These now work too
* With that, I think I have the most important things down now
* As finishing touches, I want to try and make it so that characters, locations and parties can be deleted
  * At first thought that seems like a huge complicated tasks because of dangling references, but I think Flutter and my architecture actually forced me to program so that I already implemented handling for that along the way
  * Yes, looks good. For the characters this is now working nicely
  * For the location it worked nicely too
  * For the party, there's the thing with overriding the location that I need to bend a little bit more nicely, because right now the location is overridden even if the party doesn't exist, causing a false "unknown"
    * But I now fixed that too
  * With that, the deletion of characters, parties and locations now works
    * There's at least one tiny not-so-nice thing that you can do here by using undo and redo to worm your way into a deleted entity view, but that's okay for now
* At this point, I think this is good enough, and I'm going to release the Version 1.0.0 at this point
* And that is as far as I'm getting with this for this sprint

[Time elapsed so far: 154.75 hours]

# TODO

* Consolidate incident and attribute widgets
* Consolidate Temporal Attribute and Attribute
* If you delete a character/location/party, undo it, move into that entity, and then redo the deletion, you are now effectively inside a deleted entity; it would be better if in that case you got ejected to the `OverviewView`

# User Story

As a Game Designer and Author, I want a tool to help me keep track of characters, events, items, knowledge, locations, affiliations and other things that can change over the course of a story. For example, I want to be able to go back and forth in time to figure out who learned what at what time, or who was where at what time and with whom.

## Acceptance Criteria

### Time Bar

- [x] All screens have a time bar at the top, which allows going back and forth in time
- [x] By default, there is only one point in time 
- [x] Points in time can be given names
  - [x] These names have to be unique
- [x] Points in time can be added before or after any other point in time
- [x] Points in time can be deleted
  - [x] If something happens at a point in time, that point can't be deleted
    - [ ] There is a functionality that allows skipping to whatever blocks the deletion
  - [x] If there is only a single point in time, that point in time can't be deleted
- [x] Points in time can't be re-ordered

### Incidents

- [x] Incidents can be created at points in time
- [x] Incidents can be renamed
- [x] Incidents can be deleted
- [x] Incidents can be re-ordered

### Characters Overview

- [x] Contains an overview of all characters that exists at the current point in time
- [x] Allows creating new characters
- [x] Characters can be saved/loaded
- [x] Point in Time can't be deleted if it is the first appearance of a character 

### Character View

- [x] There is character screen which displays all the information related to a character at a given time
- [x] The character screen has the following editable fields:
  - [x] First Appearance
    - [x] By default contains the point in time at which the character was created
    - [x] Can be edited to other points in time
    - [x] Can't be changed to point in  time past last appearance  (if that is filled)
    - [x] Only Points in time before which no more changes happen to the character can be selected
    - [x] Allows jumping to that point in time
    - [x] Points in time before the character's first appearance become greyed out in the time bar
  - [x] Last appearance
    - [x] Is empty by default
    - [x] Can hold points in time, including the first appearance, but not before that
    - [x] Points in time can be selected from a menu (e.g. dropdown)
      - [x] Only Points in time after which no more changes happen to the character can be selected
    - [x] Allows jumping to that point in time
    - [x] Points in time after the character's last appearance become greyed out in the time bar
  - [x] Name 
- [x] Editing a field causes the contents to change from that point in time onward, until it is edited again
  - [x] The exceptions are First and Last Appearance, which are logically always the same within a character 
  - [x] It is possible to jump back and forth to points in time where a field's value has been edited
- [x] Allows complete deletion of existing characters
- [x] The character screen has a back button, which returns back to the main view
- [x] Characters can be assigned to locations
  - [x] Basic functionality
  - [x] If a character is not presently assigned to a location, it should be displayed as "unknown"
  - [x] Keying behavior (add, remove, forward, backward)
  - [x] Characters can't be assigned to locations that do not presently exist
- [x] Characters can be unassigned from locations
- [x] You can jump to the location from the character
  - [x] If a location does not exist at the current point, it is displayed as a greyed-out button
- [x] can be added to a party
- [x] can be removed from a party
- [x] location can't be edited while character is in party
- [x] if character is in party, the party's location should be displayed instead of the character's location
- [x] Characters should have editable permanent and temporal attributes
  - [x] permanent attributes
  - [x] temporal attributes



### Locations

- [x] have a name
- [x] have a first appearance
- [x] have a last appearance
- [x] can be added
- [x] can be connected to other locations
  - [x] adjacent locations
  - [x] by clicking on linked locations, you can jump to them
    - [x] Buttons of locations that do not presently exist should not be displayed
  - [x] parent and child locations
    - [x] parent location is being displayed
    - [x] parent location can be edited
    - [x] parent location can be removed
    - [x] child locations are being displayed
- [x] can be saved and loaded
- [x] Characters at a location at a time are displayed
  - [x] You can jump to these characters
  - [x] If a character is in a party, the character should be displayed at the location where the party is at that point, and not where the character is it at that point
- [x] should have an editable location level
  - [x] can only have parents of a higher level
  - [x] can only be connected to locations of the same level
  - [x] level editing should be restricted by connected, parent and child locations
- [x] can be deleted

### Parties

- [x] should exist as temporal entities
  - [x] have an editable name
  - [x] have a first appearance
  - [x] have a last appearance
  - [x] can be added
- [x] displays all characters in it
- [x] displays present location if at least one active character is in it
- [x] allows for a change in location
- [x] displays present location as unknown if no active characters are in it 
- [x] can be deleted

### Technical

- [x] A chronicle can be saved to a file
- [x] A chronicle can be loaded from a file
- [x] Actions can be undone
- [x] Actions can be re-done
- [x] You can navigate back to the last visited view
- [x] You can navigate forward, which undoes navigating backwards

# Known Issues

* (minor impact, difficult to solve) When a last appearance is deleted, the value in the "Last Appearance" dropdown does not get removed
  * That is because there's no way to directly change the selected value of a `DropdownMenu` from the outside, only the `initialSelection`
* (minor impact, very difficult to solve) Undoing and redoing moving of first and last appearances can sometimes end up with the active point of time being a point at which the character does not exist
  * This is because the active point of time changes as necessary if it the moving of a first or last appearance puts it out of bounds
    * That moving is done in the `CharacterViewController` and not the `UpdateFirstAppearanceCommand` or `UpdateLastAppearanceCommand` because commands should not contain other commands, so this is a logical conundrum