#!/bin/bash

stack exec blog rebuild 
stack exec blog watch -- -p 9000
