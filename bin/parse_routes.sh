#!/bin/bash
roda-parse_routes -f routes.json app.rb modules/*.rb modules/**/*.rb -p
