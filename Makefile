
.POSIX:

BUILDDIR=./build

all: options pdf

options:
	@echo thesis build options:
	@echo "BUILDDIR = $(BUILDDIR)"
	@echo

pdf:
	mkdir -p $(BUILDDIR)
	pandoc thesis.md \
		--filter pandoc-crossref \
		--filter pandoc-citeproc \
		--output $(BUILDDIR)/thesis.pdf \
		--pdf-engine=xelatex

precommit:
	jupyter nbconvert \
		--ClearOutputPreprocessor.enabled=True \
		--inplace *.ipynb

.PHONY: all options pdf precommit
