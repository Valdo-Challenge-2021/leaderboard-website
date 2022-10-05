CC=/usr/bin/env python
CFLAGS=

.PHONY: all clean dev

RESOURCES=resources
RESULT=results
INPUT=data

BASE=task_1 task_2 task_3

CSV=$(BASE:%=$(INPUT)/%.csv)
HTML=$(BASE:%=$(RESULT)/%.html)
JSON=$(BASE:%=$(RESOURCES)/%.json)

ASSETS=$(shell find $(RESOURCES)/web -mindepth 1 -maxdepth 1)
WEBASSETS=$(ASSETS:$(RESOURCES)/web/%=$(RESULT)/web/%)

INDEX=$(RESULT)/index.html

CSS=$(RESOURCES)/style.css
WEBCSS=$(RESULT)/style.css

ROOT_LICENCE=LICENCE
LICENCE=$(RESULT)/LICENCE

COMMIT_MSG="Update leaderboard"

all: generate publish

publish:
	git -C $(RESULT) add .
	git -C $(RESULT) commit -m $(COMMIT_MSG)
	git -C $(RESULT) push
	git add .
	git commit -m $(COMMIT_MSG)
	git push

generate: $(INDEX) $(HTML) $(JSON) $(WEBASSETS) $(LICENCE) $(WEBCSS)

$(INDEX): $(HTML) $(JSON)
	cp $< $@

$(RESULT)/task_%.html: generate.py $(INPUT)/task_%.csv $(RESOURCES)/task_%.json resources/template.html
	mkdir -p $(@D)
	$(CC) $(CFLAGS) $< --input_csv $(word 2,$^) --input_json $(word 3,$^) --template_file $(word 4,$^) --output_file $@ --task_number $*

$(RESULT)/web/%: $(RESOURCES)/web/%
	mkdir -p $(@D)
	cp $< $@

$(LICENCE): $(ROOT_LICENCE)
	mkdir -p $(@D)
	cp $< $@

$(WEBCSS): $(CSS)
	mkdir -p $(@D)
	cp $< $@

clean:
	rm $(HTML) $(INDEX)
