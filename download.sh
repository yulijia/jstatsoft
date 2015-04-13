#!/bin/bash

address=http://www.jstatsoft.org/v

for tag in `seq 1 64`
do
wget $address$tag;
done
