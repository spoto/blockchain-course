#!/bin/sh

cd Introduction
pdflatex Introduction.tex
cd ../Bitcoin
pdflatex Bitcoin.tex
cd ../Ethereum
pdflatex Ethereum.tex
cd ..

