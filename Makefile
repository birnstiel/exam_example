NUMBER=01
TARGET=exam_$(NUMBER).tex
REVISION=HEAD^
LATEXDIFFARGS= --append-textcmd=captionof

.PHONY: clean clobber everything exam solution formulas compare

all: exam

everything: exam solution formulas

exam:
	latexmk -pdf $(TARGET)

solution:
	latexmk -g -jobname=solution_$(NUMBER) -pdf -pdflatex='pdflatex %O -interaction=nonstopmode "\PassOptionsToClass{answers}{exam}\input{%S}"' $(TARGET)

formulas:
	latexmk -pdf formulae_sheet.tex

clean:
	latexmk -c
	latexmk -c -jobname=solution_$(NUMBER) $(TARGET)
	-rm $(TARGET:.tex=.fdb_latexmk)
	-rm $(TARGET:.tex=.aux)
	-rm $(TARGET:.tex=.fls)

clobber: clean
	latexmk -C
	latexmk -C -jobname=solution_$(NUMBER) $(TARGET)

compare:
	git show $(REVISION):$(TARGET) > old_$(TARGET)
	-latexdiff $(LATEXDIFFARGS) old_$(TARGET) $(TARGET) > changes.tex
	-latexmk -pdf changes.tex
	-mv changes.pdf $(TARGET:.tex=.pdf)
	-latexmk -c changes.tex
	-rm changes.tex old_$(TARGET)
