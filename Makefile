CC=/usr/bin/env python
CFLAGS=

.PHONY: all clean dev

RESOURCES=resources
RESULT=result
INPUT=data

BASE=task_1 task_2 task_3

CSV=$(BASE:%=$(INPUT)/%.csv)
HTML=$(BASE:%=$(RESULT)/%.html)
JSON=$(BASE:%=$(RESOURCES)/%.json)

INDEX=$(RESULT)/index.html

all: generate publish

publish:

generate: $(INDEX) $(HTML) $(JSON)

$(INDEX): $(HTML) $(JSON)
	cp $< $@

$(RESULT)/task_%.html: generate.py $(INPUT)/task_%.csv $(RESOURCES)/task_%.json resources/template.html
	mkdir -p $(@D)
	$(CC) $(CFLAGS) $< --input_csv $(word 2,$^) --input_json $(word 3,$^) --template_file $(word 4,$^) --output_file $@ --task_number $*

clean:
	rm $(HTML) $(INDEX)

dev:
	echo $(JSON)
