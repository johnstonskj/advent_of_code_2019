PACKAGENAME=adventofcode
COLLECTS=$(PACKAGENAME)
TESTS=$(COLLECTS)/test
SCRBL=./scribblings/$(PACKAGENAME).scrbl

all: setup test

clean:
	find . -name compiled -type d | xargs rm -rf
	rm -rf htmldocs

setup:
	raco setup --tidy $(COLLECTS)

link:
	raco pkg install --link -n $(PACKAGENAME) $$(pwd)

unlink:
	raco pkg remove $(PACKAGENAME)

test:
	raco test -c $(COLLECTS)

coverage:
	raco cover -b -f coveralls -p $(PACKAGENAME)

htmldocs: $(SCRBL)
	raco scribble \
		--html \
		--dest $(COLLECTS)/doc \
		--dest-name index \
		++main-xref-in \
		--redirect-main http://docs.racket-lang.org/ \
		\
		$(SCRBL)

viewdocs:
	raco docs
