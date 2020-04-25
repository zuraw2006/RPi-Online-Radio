#!/bin/bash
mocp -S
redis-server --daemonize yes
ruby server.rb
