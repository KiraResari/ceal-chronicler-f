# 10-Jan-2023

* Now getting started with the Ceal Chronicler in Flutter

* It does already start with the project generation:

  * I did already create the GitHub repository for this, but Android Studio won't let be create the project in the `ceal-chronicler-f` folder, complaining that the module name is invalid and has to be snake_case

  * I now changed the "Project name" to snake case, but then it crashed, complaining that the character "-" is not allowed in Android package names, and losing all my configuration

  * I now changed the "Organization" to "com.tri_tail", although that naturally is not quite correct

  * Now I get a Project Creation Error:

    * ````
      Flutter create command was unsuccessful
      ````

  * After several tries, I was finally able to set up the base project

* After that, things went relatively smoothly, and I was able to set up a basic title screen with little problems

* Next, let's see if adding an image works

  * Okay, that seems to be more complicated

  * I followed the instructions here:

    * https://docs.flutter.dev/development/ui/assets-and-images

  * That is, I added the image path to the `pubspec.yaml` like this:

    * ````yaml
      flutter:
        uses-material-design: true
        assets:
          - assets/images/
      ````

  * The image is in `ceal-chronicler-f\assets\images\CealChroniclerLogo.png`

  * I tried to call it like this:

    * ````
      Image(image: AssetImage("CealChroniclerLogo.png"))
      Image(image: AssetImage("images/CealChroniclerLogo.png"))
      Image(image: AssetImage("assets/images/CealChroniclerLogo.png"))
      ````

  * That produces the following errors repsectively:

    * ````
      Unable to load asset: CealChroniclerLogo.png
      Unable to load asset: images/CealChroniclerLogo.png
      Unable to load asset: assets/images/CealChroniclerLogo.png
      ````

  * This tutorial said mostly the same, but it doesn't work that way either:

    * https://www.geeksforgeeks.org/how-to-add-images-in-flutter-app/
    * What this said was:
      * `Image.asset("assets/images/CealChroniclerLogo.png")`

  * Okay, I now figured out what was the issue

  * Apparently, for images, a hot reload is not enough: you need to perform a hot restart if resources have not been found

  * But anyway, with that, the title image now works too

  * And Dragon, that was just SO MUCH easier than what Kotlin Multiplatform made me go through

* Now, let's see if I can deploy the app onto the emulated android device too

  * Yay! Looks like it works
  * Although the font is definitely a bit too big there
  * I now fixed that while I was at it

* Next, I want to add a basic character selector

  * Okay, so while I tried to do that, I got this error:

    * ````
      ======== Exception caught by foundation library ====================================================
      The following assertion was thrown while dispatching notifications for AppState:
      setState() or markNeedsBuild() called during build.
      
      This _InheritedProviderScope<AppState?> widget cannot be marked as needing to build because the framework is already in the process of building widgets. A widget can be marked as needing to be built during the build phase only if one of its ancestors is currently building. This exception is allowed because the framework builds parent widgets before children, which means a dirty descendant will always be built. Otherwise, the framework might not visit this widget during this build phase.
      The widget on which setState() or markNeedsBuild() was called was: _InheritedProviderScope<AppState?>
        value: Instance of 'AppState'
        listening to value
      The widget which was currently being built when the offending call was made was: TitleView
        dirty
        dependencies: [_InheritedProviderScope<AppState?>, _InheritedTheme, _LocalizationsScope-[GlobalKey#52b2a]]
      When the exception was thrown, this was the stack: 
      #0      Element.markNeedsBuild.<anonymous closure> (package:flutter/src/widgets/framework.dart:4549:11)
      #1      Element.markNeedsBuild (package:flutter/src/widgets/framework.dart:4564:6)
      #2      _InheritedProviderScopeElement.markNeedsNotifyDependents (package:provider/src/inherited_provider.dart:577:5)
      #3      ChangeNotifier.notifyListeners (package:flutter/src/foundation/change_notifier.dart:351:24)
      #4      AppState.openCharacterSelectionView (package:ceal_chronicler_f/app_state.dart:15:5)
      #5      TitleView._buildStartButton (package:ceal_chronicler_f/title_view.dart:43:27)
      #6      TitleView.build (package:ceal_chronicler_f/title_view.dart:20:11)
      #7      StatelessElement.build (package:flutter/src/widgets/framework.dart:4949:49)
      #8      ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:4878:15)
      #9      Element.rebuild (package:flutter/src/widgets/framework.dart:4604:5)
      #10     ComponentElement._firstBuild (package:flutter/src/widgets/framework.dart:4859:5)
      #11     ComponentElement.mount (package:flutter/src/widgets/framework.dart:4853:5)
      ...     Normal element mounting (281 frames)
      #292    Element.inflateWidget (package:flutter/src/widgets/framework.dart:3863:16)
      #293    MultiChildRenderObjectElement.inflateWidget (package:flutter/src/widgets/framework.dart:6435:36)
      #294    MultiChildRenderObjectElement.mount (package:flutter/src/widgets/framework.dart:6447:32)
      ...     Normal element mounting (422 frames)
      #716    _InheritedProviderScopeElement.mount (package:provider/src/inherited_provider.dart:411:11)
      ...     Normal element mounting (7 frames)
      #723    SingleChildWidgetElementMixin.mount (package:nested/nested.dart:222:11)
      ...     Normal element mounting (7 frames)
      #730    Element.inflateWidget (package:flutter/src/widgets/framework.dart:3863:16)
      #731    Element.updateChild (package:flutter/src/widgets/framework.dart:3592:18)
      #732    RenderObjectToWidgetElement._rebuild (package:flutter/src/widgets/binding.dart:1195:16)
      #733    RenderObjectToWidgetElement.mount (package:flutter/src/widgets/binding.dart:1164:5)
      #734    RenderObjectToWidgetAdapter.attachToRenderTree.<anonymous closure> (package:flutter/src/widgets/binding.dart:1111:18)
      #735    BuildOwner.buildScope (package:flutter/src/widgets/framework.dart:2605:19)
      #736    RenderObjectToWidgetAdapter.attachToRenderTree (package:flutter/src/widgets/binding.dart:1110:13)
      #737    WidgetsBinding.attachRootWidget (package:flutter/src/widgets/binding.dart:945:7)
      #738    WidgetsBinding.scheduleAttachRootWidget.<anonymous closure> (package:flutter/src/widgets/binding.dart:925:7)
      (elided 4 frames from class _RawReceivePortImpl, class _Timer, and dart:async-patch)
      The AppState sending notification was: Instance of 'AppState'
      ====================================================================================================
      ````

    * Hm, I'm not quite sure why that happens

* This is as far as I'm getting with this today

[Total time elapsed: 3.75 hours]



# 12-Jan-2023

* Now continuing with this

* Last time, I tried implementing the Character Selection screen, only to arrive at this error message when trying to build the project:

  * ````
    The following assertion was thrown while dispatching notifications for AppState:
    setState() or markNeedsBuild() called during build.
    
    This _InheritedProviderScope<AppState?> widget cannot be marked as needing to build because the framework is already in the process of building widgets. A widget can be marked as needing to be built during the build phase only if one of its ancestors is currently building. This exception is allowed because the framework builds parent widgets before children, which means a dirty descendant will always be built. Otherwise, the framework might not visit this widget during this build phase.
    The widget on which setState() or markNeedsBuild() was called was: _InheritedProviderScope<AppState?>
      value: Instance of 'AppState'
      listening to value
    The widget which was currently being built when the offending call was made was: TitleView
      dirty
      dependencies: [_InheritedProviderScope<AppState?>, _InheritedTheme, _LocalizationsScope-[GlobalKey#03b17]]
    When the exception was thrown, this was the stack: 
    #0      Element.markNeedsBuild.<anonymous closure> (package:flutter/src/widgets/framework.dart:4549:11)
    #1      Element.markNeedsBuild (package:flutter/src/widgets/framework.dart:4564:6)
    #2      _InheritedProviderScopeElement.markNeedsNotifyDependents (package:provider/src/inherited_provider.dart:577:5)
    #3      ChangeNotifier.notifyListeners (package:flutter/src/foundation/change_notifier.dart:351:24)
    #4      AppState.openCharacterSelectionView (package:ceal_chronicler_f/app_state.dart:15:5)
    #5      TitleView._buildStartButton (package:ceal_chronicler_f/title_view.dart:43:27)
    #6      TitleView.build (package:ceal_chronicler_f/title_view.dart:20:11)
    #7      StatelessElement.build (package:flutter/src/widgets/framework.dart:4949:49)
    #8      ComponentElement.performRebuild (package:flutter/src/widgets/framework.dart:4878:15)
    #9      Element.rebuild (package:flutter/src/widgets/framework.dart:4604:5)
    #10     ComponentElement._firstBuild (package:flutter/src/widgets/framework.dart:4859:5)
    #11     ComponentElement.mount (package:flutter/src/widgets/framework.dart:4853:5)
    ...     Normal element mounting (281 frames)
    #292    Element.inflateWidget (package:flutter/src/widgets/framework.dart:3863:16)
    #293    MultiChildRenderObjectElement.inflateWidget (package:flutter/src/widgets/framework.dart:6435:36)
    #294    MultiChildRenderObjectElement.mount (package:flutter/src/widgets/framework.dart:6447:32)
    ...     Normal element mounting (422 frames)
    #716    _InheritedProviderScopeElement.mount (package:provider/src/inherited_provider.dart:411:11)
    ...     Normal element mounting (7 frames)
    #723    SingleChildWidgetElementMixin.mount (package:nested/nested.dart:222:11)
    ...     Normal element mounting (7 frames)
    #730    Element.inflateWidget (package:flutter/src/widgets/framework.dart:3863:16)
    #731    Element.updateChild (package:flutter/src/widgets/framework.dart:3592:18)
    #732    RenderObjectToWidgetElement._rebuild (package:flutter/src/widgets/binding.dart:1195:16)
    #733    RenderObjectToWidgetElement.mount (package:flutter/src/widgets/binding.dart:1164:5)
    #734    RenderObjectToWidgetAdapter.attachToRenderTree.<anonymous closure> (package:flutter/src/widgets/binding.dart:1111:18)
    #735    BuildOwner.buildScope (package:flutter/src/widgets/framework.dart:2605:19)
    #736    RenderObjectToWidgetAdapter.attachToRenderTree (package:flutter/src/widgets/binding.dart:1110:13)
    #737    WidgetsBinding.attachRootWidget (package:flutter/src/widgets/binding.dart:945:7)
    #738    WidgetsBinding.scheduleAttachRootWidget.<anonymous closure> (package:flutter/src/widgets/binding.dart:925:7)
    (elided 4 frames from class _RawReceivePortImpl, class _Timer, and dart:async-patch)
    The AppState sending notification was: Instance of 'AppState'
    ````

  * That started happening after I tried to concretely implement the `CharacterSelectionView`, which previously contained just a `Placeholder`

  * However, even reverting that back to the `Placeholder` did not fix this

  * I am not _entirely_ sure, but from studying the call stack and error message, I might assume that the issue here is that it doesn't like that the `onPressed` field of the `ElevatedButton` calls a method of the `AppState` that then calls `notifyListeners()` 

    * That is a bit confusing, since to me it feels like the `onPressed` field should only get evaluated once the button is pressed

  * I dunno if Events can fix this, but since I've been wanting to implement an Event system anyway, I figure I'll try that now

    * This looks like a good place to read up on that:
      * https://pub.dev/packages/event
      * Hmm, no, for that to work it looks like the class listening to the events must know the class posting the events, which makes it kinda useless because then it's not decoupled
    * Maybe that looks better?
      * https://pub.dev/packages/event_bus
      * Maybe, but I still have to get the `EventBus` into the components somehow

  * Maybe I should look into dependency injection first

    * Whew, that seems to be more complicated

    * Okay, this seems to be usable:

      * https://levelup.gitconnected.com/dependency-injection-in-dart-flutter-apps-3332f1a61041

      * I think I'll try to get the `get_it` to run

      * Okay, so my first attempt to get it to run failed like this:

        * ````
          The following assertion was thrown building MainView(dirty, dependencies: [_InheritedProviderScope<AppState?>]):
          Object/factory with  type EventBus is not registered inside GetIt. 
          (Did you accidentally do GetIt sl=GetIt.instance(); instead of GetIt sl=GetIt.instance;
          Did you forget to register it?)
          'package:get_it/get_it_impl.dart':
          Failed assertion: line 372 pos 7: 'instanceFactory != null'
          ````

        * I looked up the setup here:

          * https://pub.dev/packages/get_it

        * There were a few little that had changed, so I implemented those

        * And now it works, yay!

    * Looking back now, I realize that the basic problem that I had was probably simply that I used the `onPressed` field wrong, assining a value to it instead of a function

      * What I did (I think) was:

        * ````dart
          onPressed: appState.openCharacterSelectionView()
          ````

      * What I should have used (I think) would have been:

        * ````
          onPressed: () {appState.openCharacterSelectionView();}
          ````

      * That stuff with the braces is a bit confusing. I hope I'll get used to it

      * But anyway, now it also works, and as a bonus to figuring out what the error was I got DI and an EventBus

* Okay, so next I want to polish up the character selection screen a bit

  * I now did that

* So, next will be the character screen

* I did also consider adding tests now, but currently the app pretty much just displays hard-coded data, so I don't think it makes sense to add testing before I add the functionality to add new characters

* So, character screen it is for now

  * Again, doing that was crazy simple

* Okay, so let me now try to make the `Character` object a bit more complex and see what happens then

  * My primary reason for doing so is that right now, I need to hand-code each field by hand in the `CharacterView`
  * That is redundant because really I just have a number of fields, each with a title and a value that can be expressed as a string, so I should be able to simplify it
  * Okay, so this looks good now

* Next, I'll add the "Add Character" button

  * That will be a good opportunity to add tests too

  * Actually, it looks like the default Flutter app already came with a preconfigured UI test, which is freaking awesome!

  * Let me see if I can adjust that one for how the app looks now 

  * Yes, and without a problem too!

  * How great is that?

  * For reference, here's the reference:

    * https://docs.flutter.dev/cookbook/testing/widget/introduction

  * Cool, now how about unit tests?

  * While I was at it, I also ran into a problem with the GetIt context in tests, and was easily able to resolve it

  * There doesn't seem to be a way to generate test classes though

  * Okay, so now I added a `CharacterSelectionModel` along with a unit tests that asserts that adding characters works in the model

  * Now let's see if I can also get it to work in the UI

    * Mmmh, as I expected, the updating is the tricky thing here

    * I did manage to get it to add a new character, but the view is not automatically updated when that happens

    * How did that go again?

    * Ah yes, the magic word here was `setState`

    * Okay, so will it work like this?

      * ````
            return ElevatedButton(
              style: ButtonStyles.confirm,
              onPressed: () {
                eventBus.fire(AddCharacterEvent());
                setState(
                  () {
                    characters = CharacterSelectionView.model.characters;
                  },
                );
              },
              child: Text(
                CharacterSelectionView.addCharacterButtonText,
                style: buttonTextStyle,
              ),
            );
        ````

      * Yes! Success! It works!

  * I now added a few additional widget tests

    * Interesting, they all pass individually, but if run in sequence, all but the first fail
    * I didn't find any solutions for this one on the net, but plenty of unanswered questions about exactly that
    * I suppose I will leave this to when we get our Flutter expert 

* This is as far as I'm getting with this today

[Total time elapsed: 11.5 hours]



# 13-Jan-2023

* Now continuing with this

* I started out by creating a lovely bug report about the widget tests failing when run as a group here:

  * https://github.com/flutter/flutter/issues/118433

* Next, I'll get started on the long and rocky road towards editing the characters, which is something that caused me much pain when I tried to do it in Kotlin Multiplatform

  * However, I have also learned about some pitfalls to avoid that way, so this should be easier this time around

  * One thing that caused me much pain was that due to the fact that the repository is currently memory-mapped, changes to characters outside of the repository affected characters inside the repository

    * That is something I now know to guard against by writing some tests upfront 

    * Okay, I now wrote the test, and it fails as expected

    * To get it to pass, I need to copy the object

      * Turns out that copying is not something that Dart is big on either

      * The best I could find, again, is the encode/decode option

      * Aaaaand, even that is horrible, since there's no default serialization logic, and the one in https://pub.dev/packages/json_serializable doesn't really work

      * I think for now I'll just manually implement copy, though I'm not happy about that

      * And now the equality check causes issues:

        * ````
          test\characters\character_repository_test.dart 26:7  main.<fn>
          
          Expected: <Instance of 'TestCharacter'>
            Actual: <Instance of 'Character'>
          Returned character did not equal original character
          ````

        * Okay, so what's wrong here?

        * I implemented the custom equality check in the `Character` class like this:

          * ````
            @override
            bool operator ==(Object other) =>
                identical(this, other) ||
                other is Character &&
                    id == other.id &&
                    name == other.name &&
                    weapon == other.weapon &&
                    species == other.species;
            ````

          * I checked, and that override gets executed

          * Stepping deeper into detail, I noted that apparently `id == other.id` returns false

            * Makes sense, that one is a custom object after all, so if needs a custom equals as well
            * °sigh° I want Lombok from Java. Doing all of this manually is just a pain
              * But I checked, and while there was at one point a Lombok for Dart, it has been discontinued 3 years ago...

  * Okay, so now the tests are passing

  * But somehow, I can't add more than one character now

    * Okay, so apparently, adding a character twice only causes it to be added once right now
    * Mmm, looks like the issue right now is that two blank generated characters are equal, which is not the intended behavior 
      * The issue seems to be that the ID of both Characters is the same
      * And I tracked that down to the fact that two independently generated `ReadableUuid`s evaluate to be equal, which is not the point
      * Oookay, so after some searching I figured that apparently the `Uuid` that I imported is not, in fact, an actual UUID, but actualy an UUID _Generator_, so of course using it as an UUID does not work

  * Okay, so adding characters works again now

    * Only that it only works delayed, that is, the first character is only displayed after the second has been added, the secodn after the third, and so on (opening and leaving a character screen works too)
    * Okay, so apparently for some reason, the `AddCharacterEvent` only gets evaluated after the state of the view has been updated, so maybe I need to add some sort of return event there
    * Yes, looks like the idea with the Event Ping-Pong worked

  * Now, the app works again like it last did in the morning

  * Riight, and that was only the first of the dreaded character repository tests

  * But if I'm lucky, what I did now laid the groundwork for what I still need to do

    * Okay, yes, fortunately the second part was much easier than the first part

  * So much for the groundwork

  * Now I can hopefully finally implement the editable fields without too much trouble

    * Okay, no, this seems to be more complicated

    * Okay, this is actually a royal pain in the tail

    * By now my attempt looks like this:

      * ````dart
        import 'package:flutter/material.dart';
        
        import 'display_field.dart';
        
        class DisplayFieldWidget extends StatefulWidget {
          final DisplayField displayField;
        
          const DisplayFieldWidget({super.key, required this.displayField});
        
          @override
          State<DisplayFieldWidget> createState() => _DisplayFieldWidgetState();
        }
        
        class _DisplayFieldWidgetState extends State<DisplayFieldWidget> {
          TextEditingController textController = TextEditingController();
        
          @override
          Widget build(BuildContext context) {
            var theme = Theme.of(context);
            TextStyle fieldNameStyle = theme.textTheme.bodyLarge!;
            TextStyle fieldValueStyle = theme.textTheme.bodyMedium!;
            textController.text = widget.displayField.getDisplayValue();
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${widget.displayField.fieldName}: ",
                  style: fieldNameStyle,
                ),
                SizedBox(
                  width: 100,
                  height: 20,
                  child: TextField(
                    controller: textController,
                    style: fieldValueStyle,
                  ),
                ),
              ],
            );
          }
        }
        ````

    * And for starters, the text fields are empty

    * And if I click them, I get this error:

      * ````
        ======== Exception caught by widgets library =======================================================
        The following assertion was thrown building _FocusMarker(dirty):
        'package:flutter/src/widgets/framework.dart': Failed assertion: line 5472 pos 14: '() {
                // check that it really is our descendant
                Element? ancestor = dependent._parent;
                while (ancestor != this && ancestor != null) {
                  ancestor = ancestor._parent;
                }
                return ancestor == this;
              }()': is not true.
        
        
        Either the assertion indicates an error in the framework itself, or we should provide substantially more information in this error message to help you determine and fix the underlying cause.
        In either case, please report this assertion by filing a bug on GitHub:
          https://github.com/flutter/flutter/issues/new?template=2_bug.md
        
        The relevant error-causing widget was: 
          MaterialApp MaterialApp:file:///C:/projects/ceal-chronicler-f/lib/ceal_chronicler_f.dart:14:14
        When the exception was thrown, this was the stack: 
        #2      InheritedElement.notifyClients (package:flutter/src/widgets/framework.dart:5472:14)
        [...]
        ````

    * Okay, looks like this was only a hicup

    * Anyway, after restarting the app, I now get the initial values displayed and can edit them (even though the editing does not get saved yet)

  * Anyway, it looks like this will be a piece of work yet, and I don't think I'll be able to finish this today

  * For reference, this was the most helpful site about `TextField` that I found thus far:

    * https://blog.logrocket.com/the-ultimate-guide-to-text-fields-in-flutter/

* This is as far as I'm getting with this today

[Total time elapsed: 18.75 hours]



# 16-Jan-2023

* Now continuing with this

* First of, the guys from where I posted the bug about tests failing when run together to wanted to have a code sample despite me having provided a repository link, so I whipped one up by just pasting everything into a single file

* Now, what I was actually working on was text fields

  * There, I had last gotten to the point where I could enter things into the fields, but not yet save the values

  * Now this might be a bit more complicated

  * The one which knows if the text input has changed is the `DisplayFieldWidget`

  * However, that one is definitely not the one that should make any changes

  * Instead, the `DisplayFieldWidget` has to communicate to whichever object owns it that the input has changed

  * Events are out of the question for this too, since the `DisplayFieldWidget` needs to communicate to its parent component and it alone

  * I think with that we're in callback territory, if that's what it is called

  * Basically, I think this needs to work the same as the `onPressed` Parameter with a button, so maybe I can copycat that, if I can view the implementation

    * So, assuming that's what I need, this is `final VoidCallback? onPressed;`

    * Hmmm, not sure a `VoidCallback` will do

    * Let's think this through

    * The callback will be handled somewhat like this:

      * ````dart
            var fieldWidget = DisplayFieldWidget(
              displayField: displayField,
              onChanged: (){
                _handleInputFieldChange();
              },
            );
        ````

    * That means the callback handler won't know the new value, but I can pass it the field so I know which field was changed

    * It should have to know the new value though, so let's see if there's other kinds of callbacks, and if I can get them to work

    * The `TextField` fortunately uses just such a callback by employing `ValueChanged<String>`, so maybe I can copycat that

    * Okay, so...

      * (+) I got the values to be saved
      * (-) They should not be saved yet
      * (-) The character name is not updated in real time yet

    * Let's take them on one by one

      * First, that the character name is not updated in real time on the character screen yet

        * That is probably just because of a missing state update or something

        * Hmm, I now converted it to a stateful widget and added `setState(() {});`, but now that causes the cursor to jump to the beginning of the text field whenever I enter something, which is not what I want

        * And alternative errors fail either due to flutter not letting me, or me getting NUPEs

        * For instance, this is what Flutter let me do without complaining, but it causes a NUPE

          * ````
            class CharacterView extends StatefulWidget {
              static const backButtonText = "↩ Back";
            
              final Character character;
            
              const CharacterView({super.key, required this.character});
            
              @override
              State<CharacterView> createState() => _CharacterViewState();
            }
            
            class _CharacterViewState extends State<CharacterView> {
              late String title;
            
              _CharacterViewState() {
                title = widget.character.getDisplayValue();
              }
            ````

          * That is because `widget` is apparently null at that time

        * Ugggh, this is ugly =>,>=

        * Maybe this will help?

          * https://stackoverflow.com/questions/65903355/flutter-cursor-of-textfield-moves-to-position-0-after-setstate
          * I already instantiated the controller outside, but the text is being set inside the build function because it needs to be populated from the widget

        * Okay, so I now got it to work like this:

          * ````dart
            @override
            Widget build(BuildContext context) {
              ThemeData theme = Theme.of(context);
              setInitialText();
              [...]
            }
            
            void setInitialText() {
              if(textController.text.isEmpty && widget.displayField.getDisplayValue().isNotEmpty){
                textController.text = widget.displayField.getDisplayValue();
              }
            }
            ````

  * Next, I have the issue that the changes are saved even though there isn't even a "save" button yet

    * How does that come?
    * Maybe the `CharacterSelectionView` does not get the latest state of the characters from the repository as I intended
    * Or maybe the `CharacterRepository` does not hand out copies of the characters yet
    * Oh great, apparently I broke some tests in the `CharacterRepositoryTest` along the line 
      * Okay, so apparently the characters put into the repository lose their fields now, which is bad
      * Mmmh, no, looks like the `Character` does not take the values from the `TestCharacter` anymore, which is another kind of bad
        * Okay, I think I fixed that now, though it was not as easy as I had hoped
    * And now I fixed the `CharacterRepository` so it also hands out copies when all characters are retrieved
    * Now the changes don't get saved prematurely

* Next, let's add the functionality to save them explicitly

  * I got the save button to be displayed

  * However, on clicking it, I now got this error:

    * ````
      [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: setState() called after dispose(): _CharacterSelectionViewState#68fff(lifecycle state: defunct, not mounted)
      This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.
      The preferred solution is to cancel the timer or stop listening to the animation in the dispose() callback. Another solution is to check the "mounted" property of this object before calling setState() to ensure the object is still in the tree.
      This error might indicate a memory leak if setState() is being called because another object is retaining a reference to this State object after it has been removed from the tree. To avoid memory leaks, consider breaking the reference to this object during dispose().
      #0      State.setState.<anonymous closure> (package:flutter/src/widgets/framework.dart:1078:9)
      #1      State.setState (package:flutter/src/widgets/framework.dart:1113:6)
      #2      _CharacterSelectionViewState._updateCharacterSelectionView (package:ceal_chronicler_f/characters/character_selection_view.dart:130:5)
      #3      new _CharacterSelectionViewState.<anonymous closure> (package:ceal_chronicler_f/characters/character_selection_view.dart:30:7)
      #4      _RootZone.runUnaryGuarded (dart:async/zone.dart:1586:10)
      [...]
      ````

  * That's weird

  * Okay, seems like that for some strange reason, clicking the "Save" button currently attempts to run an update on the `CharacterSelectinView`

  * The help text in the error message seems to mention something like that, so let's see... 

  * Mmmh, I see

  * It's because the `CharacterModel` fires an `UpdateCharacterSelectionView` event once it is done, and that naturally does not work

  * So I definitely need different models for the views

  * Anyway, now it works

* Next, the reset button

  * There, the issue is that the text inside the text fields is not updated

  * Ahhrgh!

  * Okay, so I thing the fix that I implemented to prevent the cursor to jump back to the beginning is biting myself here

  * Yes, without that it works, but the cursor is reset

  * So it looks like I need to implement some clever logic to keep the cursor where it is supposed to be

  * Maybe I'm doing something wrong too

  * Let's have another look at this:

    * https://stackoverflow.com/questions/65903355/flutter-cursor-of-textfield-moves-to-position-0-after-setstate

  * Okay, so now it works, but now I get this error:

    * ````
      The following assertion was thrown while dispatching notifications for TextEditingController:
      setState() or markNeedsBuild() called during build.
      
      This CharacterView widget cannot be marked as needing to build because the framework is already in the process of building widgets. A widget can be marked as needing to be built during the build phase only if one of its ancestors is currently building. This exception is allowed because the framework builds parent widgets before children, which means a dirty descendant will always be built. Otherwise, the framework might not visit this widget during this build phase.
      The widget on which setState() or markNeedsBuild() was called was: CharacterView
        dependencies: [_InheritedTheme, _LocalizationsScope-[GlobalKey#40860]]
        state: _CharacterViewState#5bbe9
      The widget which was currently being built when the offending call was made was: DisplayFieldWidget
        dirty
        dependencies: [_InheritedTheme, _LocalizationsScope-[GlobalKey#40860]]
        state: _DisplayFieldWidgetState#635ee
      When the exception was thrown, this was the stack: 
      #0      Element.markNeedsBuild.<anonymous closure> (package:flutter/src/widgets/framework.dart:4549:11)
      #1      Element.markNeedsBuild (package:flutter/src/widgets/framework.dart:4564:6)
      #2      State.setState (package:flutter/src/widgets/framework.dart:1134:15)
      #3      _CharacterViewState._handleInputFieldChange (package:ceal_chronicler_f/characters/character_view.dart:94:5)
      #4      _CharacterViewState._buildFields.<anonymous closure> (package:ceal_chronicler_f/characters/character_view.dart:76:11)
      #5      _DisplayFieldWidgetState.initState.<anonymous closure>.<anonymous closure> (package:ceal_chronicler_f/fields/display_field_widget.dart:24:25)
      #6      State.setState (package:flutter/src/widgets/framework.dart:1114:30)
      #7      _DisplayFieldWidgetState.initState.<anonymous closure> (package:ceal_chronicler_f/fields/display_field_widget.dart:23:7)
      #8      ChangeNotifier.notifyListeners (package:flutter/src/foundation/change_notifier.dart:351:24)
      #9      ValueNotifier.value= (package:flutter/src/foundation/change_notifier.dart:456:5)
      #10     TextEditingController.value= (package:flutter/src/widgets/editable_text.dart:156:11)
      #11     TextEditingController.text= (package:flutter/src/widgets/editable_text.dart:141:5)
      #12     _DisplayFieldWidgetState.setText (package:ceal_chronicler_f/fields/display_field_widget.dart:48:22)
      #13     _DisplayFieldWidgetState.build (package:ceal_chronicler_f/fields/display_field_widget.dart:33:5)
      #14     StatefulElement.build (package:flutter/src/widgets/framework.dart:4992:27)
      [...]
      The TextEditingController sending notification was: TextEditingController#7cc8b(TextEditingValue(text: ┤Unnamed Character├, selection: TextSelection.invalid, composing: TextRange(start: -1, end: -1)))
      ````

    * Okay, I now fixed that by going back to the old logic and applying only the working changes there

* Now the character view behaves like it shoul

* However, it looks like there's still some background runtime errors

  * Here's the error:

    * ````
      [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: setState() called after dispose(): _CharacterViewState#bcb15(lifecycle state: defunct, not mounted)
      This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.
      The preferred solution is to cancel the timer or stop listening to the animation in the dispose() callback. Another solution is to check the "mounted" property of this object before calling setState() to ensure the object is still in the tree.
      This error might indicate a memory leak if setState() is being called because another object is retaining a reference to this State object after it has been removed from the tree. To avoid memory leaks, consider breaking the reference to this object during dispose().
      #0      State.setState.<anonymous closure> (package:flutter/src/widgets/framework.dart:1078:9)
      #1      State.setState (package:flutter/src/widgets/framework.dart:1113:6)
      #2      _CharacterViewState._updateView (package:ceal_chronicler_f/characters/character_view.dart:40:5)
      #3      new _CharacterViewState.<anonymous closure> (package:ceal_chronicler_f/characters/character_view.dart:34:7)
      #4      _RootZone.runUnaryGuarded (dart:async/zone.dart:1586:10)
      #5      CastStreamSubscription._onData (dart:_internal/async_cast.dart:85:11)
      #6      _RootZone.runUnaryGuarded (dart:async/zone.dart:1586:10)
      #7      _BufferingStreamSubscription._sendData (dart:async/stream_impl.dart:339:11)
      #8      _BufferingStreamSubscription._add (dart:async/stream_impl.dart:271:7)
      #9      _ForwardingStreamSubscription._add (dart:async/stream_pipe.dart:123:11)
      #10     _WhereStream._handleData (dart:async/stream_pipe.dart:195:12)
      #11     _ForwardingStreamSubscription._handleData (dart:async/stream_pipe.dart:153:13)
      #12     _RootZone.runUnaryGuarded (dart:async/zone.dart:1586:10)
      #13     _BufferingStreamSubscription._sendData (dart:async/stream_impl.dart:339:11)
      #14     _DelayedData.perform (dart:async/stream_impl.dart:515:14)
      #15     _PendingEvents.handleNext (dart:async/stream_impl.dart:620:11)
      #16     _PendingEvents.schedule.<anonymous closure> (dart:async/stream_impl.dart:591:7)
      #17     _microtaskLoop (dart:async/schedule_microtask.dart:40:21)
      #18     _startMicrotaskLoop (dart:async/schedule_microtask.dart:49:5)
      ````

  * I'm still unsure what exactly I need to do to make it happen though

  * I think it happens if I try to save something for the second time

  * Mmmh, maybe it's got something to do with event listeners

  * Yes, when I unsubscribe those in the dispose method like this the errors no longer occur:

    * ````dart
      late final StreamSubscription<UpdateCharacterSelectionViewEvent> _subscription;
      
      _CharacterSelectionViewState() {
        _subscription = _eventBus.on<UpdateCharacterSelectionViewEvent>().listen((event) {
          _updateCharacterSelectionView();
        });
      }
      
      @override
      dispose() {
        super.dispose();
        _subscription.cancel();
      }
      ````

* Now for the finishing touches, aka making the buttons a bit more adaptive

* Okay, with that, I am now at the point to where I made it with the Ceal Chronicler in Kotlin, and in only half the time

[Total time elapsed: 24.75h]



# 17-Jan-2023

* Now continuing with this

* Regarding the bug report about the tests failing in sequence that I posted here:

  * https://github.com/flutter/flutter/issues/118433#issuecomment-1381517837

  * They are not content with the fact that I gave them a link to the state of my whole freaking project where the bug was reproducable and demanded a code sample that reproduces the bug

  * So I prepared one for them, which pretty much just involved me pasting the whole thing into a single file, omitting stuff that I knew was not important

  * And then they next complained that my code is not minimal enough to suit their needs, so they asked me to further refine that

  * I am very annoyed about that. Here I found a bug in their software and wanted to help them fix it, and they offload the work on me! How valicious is that?

  * But anyway, I suppose I will do it anyway since it will also help me if this works, even though my base instinct is to avoid valicious people like that

  * Now, how do I best go about that?

  * I think I'll try removing unneeded parts from what I know reproduces the error

  * So, what is the minimum?

  * The three tests that I have are:

    * ​    "Character Selection View should have Add button",
    * ​    "Clicking Add Button should add a character",
    * ​    "Clicking Character Button should open character view",

  * Of these three, two fail when run in sequence

  * So I think the first thing I can do to minimize that is try to remove one of those tests, because then I'll need fewer dependencies

  * Yes, even with just two tests the second one still fails

  * So now I only have these two tests:

    * ​    "Character Selection View should have Add button",
    * ​    "Clicking Add Button should add a character",

  * So, what I basically need for those is:

    * The Title View
    * The Character Selection View
    * And their dependencies

  * For comparison, here's the error so that I can make sure what I remove does not change the error:

    * ````
      ══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
      The following TestFailure was thrown running a test:
      Expected: exactly one matching node in the widget tree
        Actual: _TextFinder:<zero widgets with text "Unnamed Character" (ignoring offstage widgets)>
         Which: means none were found but one was expected
      
      When the exception was thrown, this was the stack:
      #4      main.<anonymous closure> (file:///C:/projects/ceal-chronicler-f/test/code_sample.dart:674:7)
      <asynchronous suspension>
      <asynchronous suspension>
      (elided one frame from package:stack_trace)
      
      This was caught by the test expectation on the following line:
        file:///C:/projects/ceal-chronicler-f/test/code_sample.dart line 674
      The test description was:
        Clicking Add Button should add a character
      ════════════════════════════════════════════════════════════════════════════════════════════════════
      ````

  * I now managed to get it down to 256 lines, and the error is still happening as above

  * It would be great if I could somehow get rid of getIt and/or the eventBus, because those two are likely culprits, and it would be great to figure out which one, but I'm not sure if my architecture supports that

    * Mmmh, no, I don't think so. Those two are just too central aspects of my app

  * So I'll leave it at that for now, and if they ask for more, they won't get it

  * In the end, I still managed to get it down to 252 lines, but that's about it

* Okay, so next, I want to get my app Title Safe

  * Currently, when I run it on Android, the android title bar overlays the top part of my app, which is suboptimal

  * I tried replacing the `Material` of the `MainView` with a `Scaffold`, but that only served to add a weird white sidebar to the `Characters` screen, which I imagine is an effect caused by that area lacking a background color

    * Anyway, it didn't do anything about the overlay issue at the top of the screen

  * I could probably fix it by wrapping the entire app in sufficiently large Padding, but I wonder if there's a better way for that

  * Maybe this will help?

    * https://stackoverflow.com/questions/64873410/how-to-get-status-bar-height-in-flutter

  * Okay, so based on what Fabi showed during the daily, I got back to the basics, and investigated my very first sample flutter app again, where this seems to work 

  * I think it's because this uses `Scaffold` in conjunction with an `AppBar`

  * Okay, so I now got the desired behavior on Windows and Android like this:

    * ````dart
          return Scaffold(
            appBar: AppBar(toolbarHeight: 0),
            body: Material(child: appState.activeView),
          );
      ````

  * Well, more or less, the views still no longer expand to fill the screen

    * Only the `CharacterView` does that, so let's see if I can copycat a fix from that 

    * Uuuuh, no? I have no idea why it works there and not in the other view? It looks more or less the same?

    * Okay, but this one helped:

      * https://stackoverflow.com/questions/54988368/flutter-how-to-get-container-with-children-to-take-up-entire-screen

      * Pretty much, all I had to do was wrap my entire body in `SizedBox.expand` like this, and it worked:

        * ````dart
              return Scaffold(
                appBar: AppBar(toolbarHeight: 0),
                body: SizedBox.expand(
                  child: Material(child: appState.activeView),
                ),
              );
          ````

* Next, I want to see if I can do something to prevent the overflow of the text fields in the `CharacterView`

  * This issue is pretty certainly housed in the `DisplayFieldWidget`

  * I'm unhappy with that for a variety of reasons anyway

    * For one, I don't like that the `width` value for the name field is hard-coded, but I did that because several such rows displayed beneath one another should line up nicely even if their names are of different length

      * Thinking into this, I could _probably_ resolve that by putting them into a `DisplayFieldTable` widget
      * But that's not the main issue for now

    * The main issue is that the text input field overflows, so I'll try to solve that first

    * I tried `SizedBox.expand` here, but that only caused this error, which I already ran into when first dealing with the `TextField`s:

      * ````
        BoxConstraints forces an infinite width and infinite height.
        ````

    * Maybe this post will help?

      * https://stackoverflow.com/questions/52442724/boxconstraints-forces-an-infinite-width
      * Yes, that does work nicely
      * `Flexible` is the charm here

  * Right, so next I can maybe try to get the other thing working, namely wrapping this in a `DisplayFieldTable` or something

    * That will among other things require me to think how to handle the callbacks thrown from the various different `DisplayFieldRow`s

      * Currently, I am still somehow handling that, because I do something only if the name changes

      * Okay, so right now this is easier because the `DisplayFieldRow`s just live directly in the `CharacterView`, so the `CharacterView` can just directly map it like this:

        * ````dart
              var fieldWidget = DisplayFieldRow(
                displayField: displayField,
                onChanged: (inputValue) {
                  _handleInputFieldChange(inputValue, displayField);
                },
              );
          ````

      * If I extract that into a `DisplayFieldTable`, then I'll need an additional callback with two parameters for that

        * Is that even possible?
        * Looks like I can't do it with `ValueChanged<T, S>`, but `Function(T, S)`  was proposed as an alternative, so I'll try that out

      * Roughly 30 hours in, Dart has now corrupted me to the point where I started using nullable variables =>,<=

    * Okay, so I now got that to work too, only the text styles appear to have gotten lost somewhere down the line

      * Ah, I think I see where

    * Now it works fine

* So now, the next big topic is Persistence

  * Right now, all things that I do last only for as long as the app is open

  * However, I want to be able to save them between sessions 

  * On the desktop app, I know I want to save the data in a json file

  * As for mobile, I'm really not sure how I want to save the data there

  * But let me first read up on persistence in Flutter, maybe that will give me some ideas

  * This looks like a good place to start reading:

    * https://docs.flutter.dev/cookbook/persistence/reading-writing-files
    * Okay, that looks pretty good, and conveniently easy too

  * As a prerequisite, I need to be able to encode my data to JSON however

  * I already tried that once while trying to copy a character, but failed miserably

  * Now for round two

    * This article deals with that:

      * https://docs.flutter.dev/development/data-and-backend/json

    * Okay, so based on what I read in that, the means of auto-serializing files to JSON is severely curtailed in Flutter due to its apparent lack of runtime reflection

    * With that in mind, it is *probably* easier to just manually implement the `fromJson` and `toJson` objects for every object that I want to be serializable

    * Okay, so based on what I read there, I now came up with my own little streamlined flavor of that:

      * ````dart
        static const String _uuidFieldName = "uuid";
        
        ReadableUuid();
        
        ReadableUuid.fromJson(Map<String, dynamic> json)
            : uuid = json[_uuidFieldName];
        
        ReadableUuid.fromJsonString(String jsonString)
            : this.fromJson(jsonDecode(jsonString));
        
        Map<String, dynamic> toJson() => {
              _uuidFieldName: uuid,
            };
        
        String toJsonString() => jsonEncode(toJson());
        ````

    * And continuing to work on it, I streamlined it further by creating half of an abstract `JsonSerilaizable` class to minimize repetition

      * However, I could not entirely eliminate repetitions because Dart does not allow for the abstract constructors that I'd need for that (and I don't think any other language I know has such a feature either)

      * So I ended up posting a help request for that here:

        * https://stackoverflow.com/questions/75148047/flutter-abstract-constructor-workaround-for-json-serialization

      * I then tried around for a while, but was not able to come up with anything useful

      * My best approach was simply turning all the objects' fields into entries in a `Map<String, dynamic> values` that was stored inside the abstract `JsonSerializable` class and exposing them to the outside via getters and setters, but that failed when unpacking nested objects because the sub-surface objects were not translated back into their original selves

      * That is, before encoding I had:

        * ````
          CharacterId extends JsonSerializable{
          	values{
          		id: ReadableUuid extends JsonSerializable{
          			values{
          				uuid: SomeUuuid
          			}
          		}
          	}
          }
          ````

      * ...and after decoding I had:

        * ````
          CharacterId extends JsonSerializable{
          	values{
          		id: values{
                  	uuid: SomeUuuid
                  }
          	}
          }
          ````

      * I tried to figure out a way to get around that for some time, but eventually had to give up

      * I _could_ probably save the class name somewhere, but since we already established that Flutter does not have Runtime Reflection, I don't see how that would help me

      * Though I _might_ try if it would be possible to let abstract methods that are implemented in the concrete classes specify the unpacking

        * The requirement for that is that I can call (abstract) methods from constructors, and I don't think I've tried that in Dart yet

* This is as far as I'm getting with this today

[Time elapsed thus far: 31.5h]



# 19-Jan-2023

* Now continuing with this

* I got some feedback regarding this error:

  * https://github.com/flutter/flutter/issues/118433

  * Annoyingly, after all the time that I spent creating the minimal code sample, they did not need it at all, and just gave me some adivce that they could have given me from the first post I made

  * However, let's see if it works

  * Hmm, I can't really make head or tails of that:

    * > Looks like the first test is navigating to the `CharacterSelectionView` and the second test fails because the app is not on the home page.  Running the second test first, and the first, second, makes the tests  pass, confirming my hypothesis. You should use `tester.pumpWidget` to pump the widget you want to test in isolation. Since this is a logical error, and not an issue with Flutter or `flutter_test`, I am closing this issue. Thank you

  * I think this comment does not really contain an answer

  * Also, I think it's wrong

  * I now re-commented on that, but since they already closed that issue, I think the odds of them looking at it again are low

* Anyway, next, back to the Serialization

  * It took a bit, but I think I am now correctly Serializing the character

* Next to see if I can persist it

  * That was described here:

    * https://docs.flutter.dev/cookbook/persistence/reading-writing-files

  * Come to think of it, I think for that I need to be able to serialize the entire repository, now don't I?

    * I now did that

  * However, now I am in future and asynchronity hell, and I am not quite sure how to get the tests to handle that

    * Maybe this will help?
      * https://stackoverflow.com/questions/13678993/how-should-i-test-a-future-in-dart

    * Okay, so now I've got it to the point where it compares two characters, but the IDs are still different

  * And now it looks like I got it to work!

  * For reference, here's how I had to write that test to make sure it waits for completions:

    * ````dart
      test("Exported and then imported CharacterRepository should be equal", () {
        var firstRepository = CharacterRepository();
        addTestCharacterToRepository(firstRepository);
        
        var futureFile = firstRepository.exportToFile();
        expect(futureFile, completes);
        var secondRepository = CharacterRepository();
        var futureRepository = secondRepository.importFromFile();
        
        expect(futureRepository, completion(firstRepository));
      });
      ````

* This is as far as I'm getting with this today

* Further testing should be performed, but the unit tests work

[Total time elapsed: 37.5h]



# 20-Jan-2023

* Now continuing with this

* Last time, I got file saving to work in theory

  * That is, the one test that I wrote for that is now passing as expected

  * However, I still want to test that a bit more thoroughly

  * I now added another test, which again was a bit tricky:

    * ````dart
        test("Loading should reset character count to last saved state", () {
          var repository = CharacterRepository();
          addTestCharacterToRepository(repository);
      
          saveRepository(repository);
          addTestCharacterToRepository(repository);
          var futureRepository = repository.importFromFile();
      
          futureRepository.then((resolvedFuture) {
            expect(resolvedFuture.characters.length, 1);
          });
        });
      ````

    * And it works

* Okay, so next I'll try to implement buttons for saving and loading

* Interestingly, when I tried to run the app now, I got this error:

  * ````
    Exception: Building with plugins requires symlink support.
    
    Please enable Developer Mode in your system settings. Run
      start ms-settings:developers
    to open settings.
    ````

  * The cause is very likely the `path_provider: ^2.0.11` plugin, but I definitely need that

  * Fortunately, it still works on the Android emulator

  * Aaand, I got the save and load buttons to work there, how rad is that?

* Let this be v0-6-0 [Total time elapsed: 39.5h]

* Next, I wanted to see if I can get the app icon working

  * I called Markus about that
  * He told me that what I did thus far was already right, but apparently I still need to run the command `flutter pub run flutter_launcher_icons` from the project directory
  * Okay, looks like it worked for Android, at least that's what the command output says
  * Cute! Looks like it worked!

* And now I also added some keys (=IDs) for debugging

* Let this be v0-7-0, which is also the final version for the evaluation [Total time elapsed: 41h]



# ⚓



TODO: 

* Figure out why app icons are not working



# Notable learnings

* Dependency management with Flutter (`flutter pub get`) seems to be a problem with our firewall

# Useful links

* Beginner's Tutorial: https://codelabs.developers.google.com/codelabs/flutter-codelab-first
* Cheat Sheet code lab: https://dart.dev/codelabs/dart-cheatsheet
* Further tutorials: https://dart.dev/tutorials

# Benchmarks

## Framework

* Overall: Kinda Bad (-)
* Flutter x Dart
* (+) easy and straightforward to use at first
  * (-) but becomes more complicated later on, if you for example want to add editable text fields
  * (-) especially the event system causes a lot of trouble
    * That is because for some strange reason, Flutter does not destroy disposed widgets but keeps them lying around, and thus they might still listen to events
* (+) hot reload functionality
* (-) Dart does not support basic functionalities for objects, like copying, serialization or equals
  * Nothing like Lombok means there's a lot of boilerplate code

* (+) Can view the contents of imported packages
* (-) Flutter does not support runtime reflection

## IDE

* Overall: Kinda Bad (-)
* Android studio
* (+) mostly works without problems
  * (-) In test files, the buttons to run tests are sometimes misplaced, and then do not run the tests near which they appear, but all tests in the file
    * That can be fixed by inserting and deleting a line
* (+) refactoring works without major issues
  * (-) lacking some refactoring options though, like "extract as constant"
  * (-) moving files to different folders causes errors and broken imports


## Project setup

* Overall: Kinda Good (+)
* (+) Easy
* (+) Fast
* (-) Crashes if you use "-" in folder or package names

## Multiplatform Support

* Overall: Good (++)
* (+) easy to set up
* (+) works like a charm

## Dependency Injection

* Overall: Good (++)
* Package: get_it (https://pub.dev/packages/get_it)
* (+) easy to set up
* (+) works like a charm

## Persistence

* Not benchmarked yet

## Testing

* Overall: Neutral (0)
* (+) Widget Tests work out of the box
  * (-) sometimes widget tests fail if run in sequence though
  * (-) not possible with UI though

* (+) Unit tests work too

* (-) Tests are not classes
  * That means you can't for example have a repository test where the repository is set up for each test in the setup block, because the test will then complain that the repository has not been set (aka, you need to set the repository in each test)


## Project Load Times

* Overall: Kinda Good (+)
* (0) Starting up a previously opened project takes less than a minute
* (+) Creating a new project takes less than a minute too

## File Size

* Overall: Kinda Bad (-)
* (-) basic program file size is 22MB

## Deployment

* Overall: Good (++)
* (+) Easily deployed on Android
* (+) Easily deployed on Desktop

## Community

* Overall: Neutral (0)
* (+) Can easily find answers for most topics
* (-) Bug reports made to flutter try to load their burden on the user

## App Icons

* Overall: Mostly good (+)
* (+) Easy with plugin