# commands used to get a version of each repository to be used for building
servercmd=git checkout origin/develop
modelcmd=git checkout origin/develop
frontendcmd=git checkout origin/develop

# Use config.mk to override the commands above to build a specific branch, tag or revision
include config.mk

dist: clean server/dist
	@if [ ! -d dist ]; then mkdir dist; fi
	cp -v server/dist/* dist/

models/dist: models/checkout
	$(MAKE) dist -C models
	cp -rv models/dist server/src/main/resources/models

frontend/dist: frontend/checkout
	$(MAKE) dist -C frontend
	cp -rv frontend/dist server/src/main/resources/www

server/dist: server/checkout models/dist frontend/dist
	$(MAKE) dist -C server

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
	rm -rf dist/*

veryclean: clean
	rm -rf models 
	rm -rf fronted 
	rm -rf server 

.PHONY: models/dist frontend/dist server/dist dist models/checkout frontend/checkout server/checkout veryclean clean
