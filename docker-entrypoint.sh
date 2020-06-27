#!/bin/bash
mocp -S -O ALSAMixer1=Headphone
redis-server --daemonize yes
ruby server.rb
