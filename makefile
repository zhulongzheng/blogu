# VERY HACKY
GIT = $(shell cat config.json | grep -o \"git.*\" | cut -d"\"" -f4)
BRANCH = $(shell cat config.json | grep -o \"branch.*\" | cut -d"\"" -f4)
REPOTYPE = $(shell cat config.json | grep -o \"repotype.*\" | cut -d"\"" -f4)
DOMAIN = $(shell cat config.json | grep -o \"domain.*\" | cut -d"\"" -f4)
TESTBR = $(shell ls dist/.git/refs/heads | grep "$(BRANCH)")
NOW = $(shell date "+%Y-%m-%d %H:%M:%S")
init:
	if [ ! -d "dist" ]; then mkdir dist; fi && \
	cp example/deploy_readme.md dist/readme.md && \
	cp -R example/asset/source source && \
	cd dist && \
	if [ ! -z "${DOMAIN}" ]; then echo ${DOMAIN} > CNAME; fi && \
	if [ ! -d ".git" ]; then git init; fi && \
	if [ ! -z "${GIT}" ] && [ -z "$(shell cd dist && g remote -v)" ]; then \
		git remote add origin ${GIT}; \
	fi && \
	if [ ! -z "${BRANCH}" ] && [ ! -z "${TESTBR}" ]; then \
		git checkout ${BRANCH}; \
	fi && \
	if [ ! -z "${BRANCH}" ] && [ -z "${TESTBR}" ]; then \
		git checkout -b ${BRANCH}; \
	fi && \
	cd .. && npm install

addgit:
	cd dist && \
	if [ ! -z "${GIT}" ]; then git remote add origin ${GIT}; fi

editgit:
	cd dist && \
	if [ ! -z "${GIT}" ]; then git remote set-url origin ${GIT}; fi

editbr:
	cd dist && \
	if [ ! -z "${BRANCH}" ] && [ ! -z "${TESTBR}" ]; then \
		git checkout ${BRANCH}; \
	fi && \
	if [ ! -z "${BRANCH}" ] && [ -z "${TESTBR}" ]; then \
		git checkout -b ${BRANCH}; \
	fi

adddomain:
	if [ ! -d "dist" ]; then mkdir dist; fi && \
	cd dist && \
	if [ ! -z "${DOMAIN}" ]; then echo ${DOMAIN} > CNAME; fi

post:
	gulp new --name "${name}" --silent

server:
	gulp server

s:
	gulp server --silent

gen:
	gulp gen

g:
	gulp gen --silent

GITST = $(shell git status | grep "working directory clean")
deploy:
	cd dist && git add --all && \
	if [ -z "${GITST}" ]; then \
		git commit -a -m "Site Update: ${NOW}"; \
	fi && \
	if [ ! -z "${BRANCH}" ]; then \
		git push -f origin "${BRANCH}"; \
	else \
		git push -f origin master; \
	fi

d:
	cd dist && git add --all && git commit -a -m "Site Update: ${NOW}" && \
	if [ ! -z "${BRANCH}" ]; then \
		git push -f origin "${BRANCH}"; \
	else \
		git push -f origin master; \
	fi

dev:
	gulp dev
