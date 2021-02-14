Create a new project in Firebase. Download the config file provided by Firebase and
add it to the project directory.

In terminal, cd into the project directory and type 'pod init'

In the podfile, add:
> Firebase/Analytics
> Firenase/Auth
> Firebase/Core
> Firebase/Firestore

Save and close the podfile.

In terminal, run 'pod install'

An xcode workspace will be generated in the project folder. Open it.
