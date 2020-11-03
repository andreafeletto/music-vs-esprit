
.POSIX:

all: thesis.pdf

thesis.pdf:
	mkdir -p build
	pandoc thesis.md \
		--variable citation-style=assets/dsp.csl \
		--include-in-header assets/head.tex \
		--include-before-body assets/firstpage.tex \
		--listings \
		--filter pandoc-crossref \
		--citeproc \
		--pdf-engine=xelatex \
		--output build/thesis.pdf

precommit:
	jupyter nbconvert \
		--ClearOutputPreprocessor.enabled=True \
		--inplace examples/*.ipynb

clean:
	rm -rf ./build
