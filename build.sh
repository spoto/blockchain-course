#!/bin/sh

cd Introduction
pdflatex Introduction.tex
cd ../Bitcoin
pdflatex Bitcoin.tex
cd ../Ethereum
pdflatex Ethereum.tex
cd ../Tendermint
pdflatex Tendermint.tex
cd ../Hotmoka
pdflatex Hotmoka.tex
cd ..

