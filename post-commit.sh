#!/bin/bash

while ! pass git push origin master
do
    sleep 1s &&
	true
done &&
    true
