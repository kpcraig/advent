identification division.
program-id. p1.

environment division.
input-output section.
file-control.
 select input-file
 	assign to 'input'
	organization is line sequential.

data division.
file section.
fd input-file.
01 word.
	88 input-file-end value high-values.
	02 letters pic x(16).
working-storage section.
01 letter-count pic 99.
01 current-letter pic x.
01 prev-letter pic x.
01 good-word-count pic 9999 value 0.
01 bad-combo-count pic 9 value 0.
01 double-letter-count pic 9 value 0.
01 vowel-count pic 9 value 0.

procedure division.
	open input input-file
	read input-file
		at end set input-file-end to true
	end-read
	perform until input-file-end
		set letter-count to 1
		set vowel-count to 0
		set bad-combo-count to 0
		set double-letter-count to 0
		perform until letter-count=17
			set current-letter to letters(letter-count:1)
			if current-letter = 'a' or current-letter = 'e' or current-letter = 'i' or current-letter = 'o' or current-letter = 'u' then
				add 1 to vowel-count
			end-if
			if letter-count > 1 then
				if prev-letter = current-letter then
					add 1 to double-letter-count
				end-if
				if (current-letter = 'b' and prev-letter = 'a') or (current-letter='d' and prev-letter = 'c') or (current-letter='q' and prev-letter='p') or (current-letter='y' and prev-letter='x') then
					add 1 to bad-combo-count
				end-if
			end-if
			set prev-letter to current-letter
      add 1 to letter-count
		end-perform
		if vowel-count > 2 and double-letter-count > 0 and bad-combo-count = 0 then
			add 1 to good-word-count
		end-if
		read input-file
			at end set input-file-end to true
		end-read
	end-perform
	close input-file
	display good-word-count
	stop run.
