default:
	cat parable.coffee pre.coffee > a.coffee
	coffee -bc a.coffee
	cat script-header a.js > pre
	chmod +x pre
	rm a.js a.coffee
