# iiif-firefox-annotation-extract
Ruby script to extract Mirador-created annotations from Firefox local storage

To install: clone this repo and run ```bundle install```

To run: 

- Create some annotations using Mirador in Firefox
- Discover your current Firefox profile directory by visiting ```about:profiles```. Set an environment variable ```FIREFOX_PROFILE``` containing the full path (ending with ```.default```)
- Run ```./extract-annotations.rb <canvasURI selector> [<scope>]```
  - the canvasURI selector is the beginning of the uri for the canvases you're interested in
  - the scope is the domain of the Mirador instance you used to make the annotations (default: ```projectmirador.org```)
- An annotation list is written to stdout
