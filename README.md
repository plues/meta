# SlotTool Meta

This is a meta-repository for the timetable validation tool
[PlüS](https://github.com/plues). It contains instructions on how to clone,
checkout and build all the sub-projects associated to the this project.

This project is composed of three sub-projects, the
[frontend](https://github.com/plues/frontend), the [server or main
application](https://github.com/plues/server) and the B models, each developed
(more or less) independently.

## Building

Building is done using `make`.  To create a distributable package run

```
make dist flavor=<FACULTY>
```

where `<FACULTY>` is either `philfak` or `wiwi`

The resulting `.zip` file is placed in __`dist/`__

### Customizing the Build

Some options of the build are configured with variables that can be overriden
in the `config.mk` file that is included (if present) in the
[`Makefile`](Makefile).

#### Repositories
The URLs of the repositories have the following default values:

```
modelsrepo=git@tuatara.cs.uni-duesseldorf.de:slottool/models.git
frontendrepo=https://github.com/plues/frontend.git
serverrepo=https://github.com/plues/frontend.git
datarepo=https://github.com/plues/data.git
```

#### Branches
By default the current branch of the meta repository is used to build the
artifacts in each sub-project (e.g. `develop` or `master`). To customize which
state of the repositories is used for building use the `config.mk` file and
define following variables to the required command for each repository. The
configuration to build `origin/feature-1` instead of `origin/develop` would
look like this:

```
servercmd=git checkout origin/feature-1
modelcmd=git checkout origin/feature-1
frontendcmd=git checkout origin/feature-1
```

## Running

Extract the zip file (`dist/<FACULTY>-server-<VERSION>.zip`) and run `bin/server` to
start the application. Visit [http://localhost:8080/](http://localhost:8080/)
to use the application.


## Conventions

Each sub-project provides a Makefile that defines a `dist` rule and accepts
a flavor paramter to customize the build. This rule runs everything that is
needed to build the project and places the result in `dist` directory. The
top-level `Makefile` will take the results out of each `sub-project/dist`
and place them in the correct location to build the final artifact.

## License

This project is distributed under the terms of the [ISC License](LICENSE).
