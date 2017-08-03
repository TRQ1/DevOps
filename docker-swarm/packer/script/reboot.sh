#!/bin/bash

sudo ifdown -a
sudo ifup -a
sudo shutdown -r now
sudo sleep 60
