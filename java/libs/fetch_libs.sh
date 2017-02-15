#! /bin/bash

WGET="wget -nc"

# Soot software and dependencies
$WGET http://www.sable.mcgill.ca/software/sootclasses-2.5.0.jar
$WGET http://www.sable.mcgill.ca/software/jasminclasses-2.5.0.jar
$WGET http://www.sable.mcgill.ca/software/polyglotclasses-1.3.5.jar

# JUnit (for unit tests)
$WGET https://github.com/junit-team/junit4/releases/download/r4.12/junit-4.12.jar
