# ZiNC-Compiler-with-Flex-Bison
A simple compiler made with Flex and Bison configured to translate the ZiNC language

## Installaltion

### Prerequisites

Flex
Bison
MinGW or Dec-Cpp

### Flex and Bison

#### Option 1
Download winflexbison 2.5.16 from [sourceforge] (https://sourceforge.net/projects/winflexbison/)

Watch this [installation tutorial](https://www.youtube.com/watch?v=WuXT_5SXR8g)
*No need to follow __custom installation__ instructions on that video

#### Option 2
Download both from [GNU](http://gnuwin32.sourceforge.net/packages.html) *(these will be older versions)

Watch this [installation tutorial](https://www.youtube.com/watch?v=0MUULWzswQE)

*For Windows make sure to add binaries to 'path' environment variable"
1. For winflexbison folder for winflexbison OR
1. For GNUwin32/bin for flex and bison
1. Also add binaries to path for MinGW OR Dev-Cpp for 'gcc' commands

## Usage

### cmd.exe commands to setup the compiler

`>cd path/to/repo/location`

`>flex zinc.l`

`>bison -y -d zinc.y` for regular bison OR `>win_bison -y -d zinc.y` for winflexbison

`>gcc -o myCompiler.exe lex.yy.c y.tab.c`

`>myCompiler.exe < t1.znc`

..output should look like this..

```
Section .data
N:      word
SQRT:   word
Section .code
LVALUE  N
READINT
STO
LVALUE  SQRT
PUSH 0
STO
LABEL   0000
RVALUE SQRT
RVALUE SQRT
MPY
RVALUE N
LE
GOFALSE 0001
LVALUE  SQRT
RVALUE SQRT
PUSH 1
ADD
STO
GOTO    0000
LABEL   0001
LVALUE  SQRT
RVALUE SQRT
PUSH 1
SUB
STO
RVALUE SQRT
PRINT
HALT
```