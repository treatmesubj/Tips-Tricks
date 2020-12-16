import regex  # conditional look-arounds

reggy = r"(?<=var(.|\n)*?obj_name(.|\n)*?=(.|\n)*?)(?<!var(.|\n)*?obj_name(.|\n)*?=(.|\n)*?;(.|\n)*?){((.|\n)*?)};"

text = """
var breakfast = {
	{
		meal: "pancake",
		drink: "oj"
	}
};
var obj_name = { blah: "blah",
	hey: "hey" 
};
var breakfast = {
	{
		meal: "pancake",
		drink: "oj"
	}
};
{
}
"""

jaysean = regex.search(reggy, text)

print(jaysean.group(0))
