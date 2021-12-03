
awk '
BEGIN { FS = "x" }
{
	l = $1 * $2
	w = $2 * $3
	h = $1 * $3
	min = l > w ? w : l
	min = min > h ? h : min
	total += 2*l + 2*w + 2*h + min
}
END{
	print total
}
'
