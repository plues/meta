# commands used to get a version of each repository to be used for building
current_branch=$(shell git rev-parse --abbrev-ref HEAD)
servercmd=git checkout origin/$(current_branch)
modelcmd=git checkout origin/$(current_branch)
frontendcmd=git checkout origin/$(current_branch)

# Use config.mk to override the commands above to build a specific branch, tag or revision
-include config.mk


run: clean server/prepare
	make -C server/ run

dist: clean server/dist
	@if [ ! -d dist ]; then mkdir dist; fi
	cp server/dist/* dist/

flavor=philfak
models/dist: models/checkout
	$(MAKE) dist flavor=$(flavor) -C models

frontend/dist: frontend/checkout
	$(MAKE) dist flavor=$(flavor) -C frontend

server/dist: server/prepare
	$(MAKE) dist flavor=$(flavor) -C server

server/prepare: server/checkout models/dist frontend/dist
	$(MAKE) clean -C server
	cp -r models/dist server/src/main/resources/models
	cp -r frontend/dist server/src/main/resources/www

# XXX This destroys local changes
models/checkout: models
	cd models; git fetch; $(modelcmd)

frontend/checkout: frontend
	cd frontend; git fetch; $(frontendcmd)

server/checkout: server
	cd server; git fetch; $(servercmd)

models:
	if [ ! -d models/.git ]; then git clone git@gitlab.cobra.cs.uni-duesseldorf.de:slottool/models.git; fi

frontend:
	if [ ! -d frontend/.git ]; then git clone git@gitlab.cobra.cs.uni-duesseldorf.de:slottool/frontend.git; fi

server:
	if [ ! -d server/.git ]; then git clone git@gitlab.cobra.cs.uni-duesseldorf.de:slottool/server.git; fi

clean:
	@rm -rf dist/*

ratherclean: clean
	$(make) clean -C frontend
	$(make) clean -C models
	$(make) clean -C server

veryclean: clean
	rm -rf models
	rm -rf fronted
	rm -rf server

.PHONY: models/dist frontend/dist server/dist dist models/checkout frontend/checkout server/checkout ratherclean veryclean clean
