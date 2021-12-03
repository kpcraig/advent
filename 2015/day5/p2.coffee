fs = require('fs')

good_words = 0
rule1 = /([a-z][a-z])[a-z]*\1/ #(a two letter combo)(any number of letters)(same combo)
rule2 = /([a-z])[a-z]\1/ #(any letter)(exactly one letter)(same as first letter)

do ->
	for word in fs.readFileSync("input").toString().split('\n') # Most efficient ever.
		if rule1.test(word) && rule2.test(word)
			good_words++

console.log good_words
