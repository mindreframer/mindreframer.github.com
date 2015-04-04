run:
		rm -rf public && hugo server --buildDrafts -w


gen:
		ruby doc/generate_files.rb
