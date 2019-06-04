# Contributing Guide

Reading this document must mean that you are interested in making a contribution to this project. Welcome!

This document aims to give you enough information to get started on contributing as well as some guidelines on submitting your contribution.

Before we begin, here are some important reminders:

- Please discuss your idea before going through with it by [creating an issue](https://github.com/tipidapp/mobile/issues/new) and put in as much detail as possible. Other people may be able to offer additional information or advice on how to implement your idea. At the very least, you won't get the frustration of being immediately rejected or ignored if you submit an unsolicited pull request.
- By participating in this project, you are agreeing to abide by our [code of conduct](CODE_OF_CONDUCT.md).

## Getting Started

We'll walk you through on how to setup this project on your local machine so you can get started on contributing.

### Installing Flutter

This project runs on [Flutter](https://flutter.io), so you need to install that before you get to do anything. Fortunately, it is very easy to do so:

- [Official guide on how to install Flutter](https://flutter.dev/docs/get-started/install)

### Running the Project Locally

After you've installed Flutter, [fork this project](https://help.github.com/en/articles/fork-a-repo), clone the resulting repository, and go inside that directory on your terminal:

```shell
git clone git@github.com:<your-username>/mobile.git
cd mobile
```

Next, install the dependencies and try running the project on your device.

```shell
flutter packages get
flutter run
```

If you're using [Visual Studio Code](https://code.visualstudio.com/), instead of `flutter run`, you can press F5 inside VSCode to run the project.

### Choosing a Test Device

If you want to test the project on Android, you can use the official [Android Emulator](https://developer.android.com/studio/run/emulator) or [Genymotion](https://www.genymotion.com/fun-zone/).

If you're on a Mac, you can test the app on iOS using the [Xcode Simulator](https://developer.apple.com/library/archive/documentation/IDEs/Conceptual/iOS_Simulator_Guide/GettingStartedwithiOSSimulator/GettingStartedwithiOSSimulator.html).

Testing on a real device is always preferrable since you can see the actual performance of the app. You can do this on an Android phone by [enabling Developer Options](https://developer.android.com/studio/debug/dev-options) and connecting it directly to your computer via USB. On iOS, just connecting the device directly on a Mac should suffice.

## Coding Guidelines

I, myself, am very new to Flutter, so the standards for this project will not be that high.

At the very least, pull requests must pass these 2 criteria in order to be considered for merging:

- It should pass `flutter analyze`
- It should be formatted using `flutter format .`

We don't have any strict rules when it comes to how code should look, but it should at least pass Flutter's linter and formatter to keep everyone's code somewhat consistent.

## Committing Guidelines

### Commit Message Format

We are strictly following [Conventional Commits](https://www.conventionalcommits.org/) when it comes to writing our commit messages. This leads to more readable messages that are easy to follow when looking at `git log`. Also, we use the commit messages to generate [this project's change log](CHANGELOG.md).

Each commit message consists of a **header**, a **body** and a **footer**. The header has a special
format that includes a **type**, a **scope** and a **subject**:

```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

The **header** is mandatory and the **scope** of the header is optional.

Any line inside the body of the commit message cannot be longer 100 characters! This allows the message to be easier to read on GitHub as well as in various git tools.

The footer should contain a [closing reference to an issue](https://help.github.com/articles/closing-issues-via-commit-messages/) if any.

Samples:

```
feat: add user sign up screen

This adds a new screen for allowing new users to sign up for an account in our platform.
```

```
feat: make sign up screen actually work

This adds the needed functionality by the sign up screen to actually talk to the API and register new users.

This is a follow up to #123
```

```
fix: replace regex for validating email

This fixes the previously broken regex for validating email addresses.

It can now reject actual invalid formats.

Closes #123
```

### Reverting Previous Commits

If the commit reverts a previous commit, it should begin with `revert: `, followed by the header of the reverted commit. In the body it should say: `This reverts commit <hash>.`, where the hash is the SHA of the commit being reverted.

### Types

Must be one of the following:

- **build**: Changes that affect the build system or external dependencies
- **ci**: Changes to our CI configuration files and scripts
- **docs**: Documentation only changes
- **feat**: A new feature
- **fix**: A bug fix
- **perf**: A code change that improves performance
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: Adding missing tests or correcting existing tests

### Subject

The subject contains a succinct description of the change:

- Use the imperative, present tense: "change" not "changed" nor "changes"
- Don't capitalize the first letter
- No dot (.) at the end

### Body

The body should include the motivation for the change and contrast this with previous behavior. You can also add some additional lines if you need to provide more information about your commit.

### Footer

The footer should contain references to Github issues and/or other pull requests it may be involved in.

### One Commit Per Pull Request

This is borderline mandatory, but each pull request should contain only one (1) commit. This is enforced for the following reasons:

- To discourage large pull requests. Reviewing large pull requests is hard and time consuming which makes the reviewer want to skim over the changes instead of doing it meticulously. This usually results in unknowingly allowing sloppy code to slip through the review process.
- To encourage dividing a large unit of work into multiple units. This constraint forces you, the developer, to think about how to approach a problem in stages and know when a good stopping point is before you proceed any further. A good example would be dividing a feature into 2 parts: creating the screen and then adding in the functionality.
- To encourage you to give more thought into the commit message. By default, Github uses the header and the subsequent content of the commit message as the title and body of the pull request. This means that a good commit message would mean less work into crafting the title and description of the pull request. It also provides better context to other people when looking at your commit through `git log --pretty`.

## Project Walkthrough

### File Structure

As mentioned above, this project is built using [Flutter](https://flutter.io). As such, we will only be covering the relevant parts that are not provided by Flutter out of the box when creating a new project through `flutter create`.

- `assets`: Located at the root of the project, this folder contains the static assets that are used inside the app.
  - `assets/fonts`: All font files must be imported to this folder. After adding the files, you can tell Flutter about its existence by adding a new font definition inside [pubspec.yaml](pubspec.yaml). See [this guide](https://flutter.dev/docs/cookbook/design/fonts) for more information.
  - `assets/images`: Images that are used to build the app such as icons or backgrounds should be imported to this folder. You can then use `Image.asset()` to call the image inside your widgets. See [this guide](https://flutter.dev/docs/development/ui/assets-and-images) for more information.
- `lib/models`: Contains classes that represent real world objects or shape specific API responses to help with building the business logic inside the app.
- `lib/screens`: Each file represents a screen inside the app. Widgets that are used exclusively by the respective screen must be placed alongside the screen class.
- `lib/services`: Contains service classes that are called by widgets to do the actual heavy lifting (aka business logic). A service class usually connects a state mutation (found in `lib/state`) and an API call (found in `lib/utils/api.dart`) to a widget.
- `lib/state`: Provides a central location for the state which can be accessed anywhere inside the app. It contains the initial value of the state upon app load as well as some mutation functions to change the current value of the state.
- `lib/utils`: Contains utility classes that are used all throughout the app.
- `lib/widgets`: Contains widgets that can be reused by more than one screen.

### State Management

Flutter provides [multiple ways](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options) of doing state management, This project uses the [Provider package](https://pub.dev/packages/provider) along with [ChangeNotifier](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) as our preferred way of managing state for the following reasons:

- This is the latest endorsed method by the Flutter team. You can check out their Google I/O 2019 talk about Provider here: https://www.youtube.com/watch?v=d_m5csmrf7I
- Compared to BLoC, it is simple enough to learn easily, but flexible enough to be able to handle complex situations and implementations. You can even integrate Provider with the BLoC pattern if you choose to do so.
- Compared to Redux, the boilerplate code involved is significantly less.

In this project, this is how we use the Provider package:

- A widget can access the value of a specific part of the state by calling either `Provider.of<StateClass>()` or `Consumer<StateClass>()`. If a widget wishes to do a mutation on the state, it should call a service class (found inside `lib/services`) that corresponds to the specific part of the state it wants to change.
- The service class provides a function that does some business logic as well as the actual mutation of the state. This means that only service classes have direct access to state classes.
- The state class (found inside `lib/state`) provides a function that does the actual mutation of the state. Only service classes should have access to these mutation functions to keep the concerns across the various classes separate.
- Once a mutation function has been invoked, the change in the value of the state will propagate to all the widgets that are listening to it via `Provider.of()` of `Consumer()`.