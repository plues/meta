# SlotTool Meta

This is a meta-repository for the timetable slot planning tool. It contains
instructions on how to checkout, clone and build all the sub-projects associated
to the this project.

This project is composed of three sub-projects, the frontend, the server and the
B models, each developed (more or less) independently.

## Building

Building is done using ```make```.  To create a distributable package run

```
make dist
```

The resulting ```.zip``` file is placed in __```dist/```__

### Customizing the Build

By default the state of ```origin/develop``` in each sub-project is used to
build the artifact. To customize which state of the repositories is used for
building use the ```config.mk``` file and define following variables to the
required command for each repository. The configuration to build
```origin/master``` instead of ```origin/develop``` would look like this:

```
servercmd=git checkout origin/develop
modelcmd=git checkout origin/develop
frontendcmd=git checkout origin/develop
```

## Running

Extract the zip file (```dist/server-1.0.zip```) and run ```bin/server``` to
start the application. Visit
[```http://localhost:8080/#/course```](http://localhost:8080/#/course) to use
the application.


## Conventions

Each sub-project provides a Makefile that defines a ```dist``` rule This rule
runs everything that is needed to build the project and places the result in
```dist``` directory. The top-level ```Makefile``` will take the results out of
```sub-project/dist``` and place them in the correct location to build the
final artifact.
