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

procedure division.
	open input input-file.
	read input-file
		at end set input-file-end to true
	end-read.
	perform until input-file-end
		display letters
		read input-file
			at end set input-file-end to true
		end-read
	end-perform.
	close input-file.
	stop run.
