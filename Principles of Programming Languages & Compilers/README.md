#### Principles of Programming Languages & Compilers

This repository contains the project of the course Principles of Programming Languages & Compilers and was executed in collaboration with [George Kaffezas](https://github.com/gkffzs). The goal was the implementation of a parser for an imaginary object-oriented language called "Simon", created using [Flex](https://www.gnu.org/software/flex/flex.html) & [Bison](https://www.gnu.org/software/bison/).

Assuming you are running a GNU/Linux distribution and that you have those two installed, you can test the parser by typing the following commands in a terminal:
- `bison -y -d bison_file.y`
- `flex flex_file.l`
- `gcc -c y.tab.c lex.yy.c`
- `gcc y.tab.o lex.yy.o -o parser`
- `./parser input_file.txt`

Note that the `output_file.txt` includes the output you're expecting, and the `included_file.txt` is the file that, as its name suggests, is included in the beginning of `input_file.txt`.