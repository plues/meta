# commands used to get a version of each repository to be used for building
current_branch=$(shell git rev-parse --abbrev-ref HEAD)
servercmd=git checkout -f origin/$(current_branch)
modelcmd=git checkout -f origin/$(current_branch)
frontendcmd=git checkout -f origin/$(current_branch)

modelsrepo=git@tuatara.cs.uni-duesseldorf.de:slottool/models.git
frontendrepo=https://github.com/plues/frontend.git
serverrepo=https://github.com/plues/server.git

# Use config.mk to override the commands above to build a specific branch, tag or revision
-include config.mk


run: clean server/prepare
	make -C server/ run flavor=$(flavor)

dist: clean server/dist
	@if [ ! -d dist ]; then mkdir dist; fi
	cp -rv server/dist/* dist/

flavor=philfak
server/dist: server/prepare
	$(MAKE) dist flavor=$(flavor) -C server

models/dist: models/checkout
	$(MAKE) dist flavor=$(flavor) -C models

frontend/dist: frontend/checkout
	DISABLE_MIRAGE=1 $(MAKE) dist flavor=$(flavor) -C frontend

server/prepare: server/checkout models/dist frontend/dist
	$(MAKE) clean -C server
	cp -r frontend/dist server/src/main/resources/www
	cp -r models/dist/models.zip server/src/main/resources/models.zip

# XXX This destroys local changes
models/checkout: models
	cd $(dir $@); git fetch; $(modelcmd)

frontend/checkout: frontend
	cd $(dir $@); git fetch; $(frontendcmd)

server/checkout: server
	cd $(dir $@); git fetch; $(servercmd)

models:
	if [ ! -d models/.git ]; then git clone $(modelsrepo); fi

frontend:
	if [ ! -d frontend/.git ]; then git clone $(frontendrepo); fi

server:
	if [ ! -d server/.git ]; then git clone $(serverrepo); fi

clean:
	@rm -rf dist/*

ratherclean: clean
	$(make) clean -C frontend
	$(make) clean -C models
	$(make) clean -C server

veryclean: clean
	rm -rf frontend
	rm -rf models
	rm -rf server

.PHONY: models/dist frontend/dist server/dist dist models/checkout frontend/checkout server/checkout ratherclean veryclean clean
