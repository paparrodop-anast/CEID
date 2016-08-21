#### Languages Technology

This repository contains the project of the course Languages Technology and was executed in collaboration with [Giannis Giannoudakis](https://github.com/giannoudak) and Fotis Hantzis.

The main goal of the project was to develop an end-to-end text analysis pipeline for text analysis on a dataset containing 1000 articles taken from the Wikipedia. For that purpose, we implemented some basic NLP tasks (cleanup/tokenization, morphosyntactic analysis, PoS tagging, lemmatization) over the text collection, in order to build an inverted index (in a XML format). The index contains all resulted lemmas with their weight - calculated using the TF-IDF metric - for each text, in a way that it can be easily queried.