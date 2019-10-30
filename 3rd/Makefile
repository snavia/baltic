REPO_BASE = git@github.com:

PWD = $(shell pwd)
DATE_SUF = $(shell date +%Y.%m.%d.%H.%M.%S)


# ###########################
# MAIN AREA
# ###########################
.PHONY: init fini clean install uninstall sync export
init:
	for x in `cat repo.lst`; do \
	  echo $$x; \
	  dname=$$(dirname $$x); \
	  fname=$$(basename $$x); \
	  [ ! -d "$$dname" ] && mkdir -p "$$dname"; \
	  [ ! -d "$$x" ] && git clone "${REPO_BASE}$${x}.git" "$$x"; \
	  echo "$$x done"; \
	done;
	@echo ALL DONE;
fini:
	echo "$@ - PASS"
clean:
	-rm -rvf *.log *.bak

install:
uninstall:
sync:
	find . -type d -name ".git" | xargs -n1 -I _ git -C _/.. pull
export:
	@echo TODO-RESERVED


# ###########################
# SUB AREA
# ###########################



# ######################
# 自定义 utils
# ######################
# usage: $(call verifyLink, src-file-or-dir, dst-link[, sudo])
define verifyLink
	[ -h $(2) ] && $(3) unlink $(2) || >/dev/null
	[ -e $(2) ] && $(3) mv $(2) $(2)-$(DATE_SUF) || >/dev/null
	[ ! -h $(2) ] && $(3) ln -s $(1) $(2) || >/dev/null
endef
