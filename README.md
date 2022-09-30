# Bash script for making banners

Made for Bioinformatics introduction to computer science classes at MIMUW in the winter semester of 2021/2022.

## Usage
```
Usage: banner.sh [-h] [-w] [-c character] [filename]
 -w make banner out of every word
 -c change banner character
 -h help
```

If no `filename` is supplied, reads from standart input.

## Examples

```
echo "Ala ma kota" | ./banner.sh

.-----------.
|Ala ma kota|
'-----------'
```
```
echo "Ala ma kota" | ./banner.sh -c "#"

#############
#Ala ma kota#
#############
```
```
echo "Ala ma kota" | ./banner.sh -w

.---. .--. .----. 
|Ala| |ma| |kota| 
'---' '--' '----' 
```

