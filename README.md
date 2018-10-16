## Information

Pet-app with Roda and Mongoid.

## Run

```bash
rackup
```

## Run console

```bash
./bin/console
```

## Seeds

```bash
./bin/seeds
```

## Generate routes

```bash
./bin/parse_routes.sh
```

## API Documentation

```
# run server
rackup
# see swagger documenation
open http://localhost:9292/swagger_ui
```

Also routes-list are inside: routes.json

## Folder Structure

- docs/ - swagger documentation
- handlers/ - handlers for modules
- models/ - here is models
- modules/ - here is parts of main app
- services/ - here is services
- app.rb - Main application
- init.rb - initializations file
