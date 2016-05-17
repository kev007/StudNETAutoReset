$name=$args[0]
$guid=$args[1]

$file = "StudNETAutoReset"

# Grabs filecontent, line by line, into an array named strings
$strings = Get-Content $file

# creates output-variable as an array
$results = @()

# for each line do ...
foreach ($string in $strings)
{
	# Add line to results after replacing the name
	$results += $string.Replace("REPLACEGUID",$guid)
}


# Write result to file, overwriting previous values
Set-Content -Value $results -Path $file".x"

$file = "StudNETAutoReset.x"

# Grabs filecontent, line by line, into an array named strings
$strings = Get-Content $file

# creates output-variable as an array
$results = @()

# for each line do ...

foreach ($string in $strings)
{
	# Add line to results after replacing the name
	$results += $string.Replace("REPLACENAME",$name)
}


# Write result to file, overwriting previous values
Set-Content -Value $results -Path $file"ml"

