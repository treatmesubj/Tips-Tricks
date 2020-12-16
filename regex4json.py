import regex  # conditional look-arounds

javascript_obj_name = "obj_name"

# legit regex: (?<=var(.|\n)*?javascript_obj_name(.|\n)*?=(.|\n)*?)(?<!var(.|\n)*?javascript_obj_name(.|\n)*?=(.|\n)*?;(.|\n)*?){((.|\n)*?)};

reggy = fr"(?<=var(.|\n)*?{javascript_obj_name}(.|\n)*?=(.|\n)*?)(?<!var(.|\n)*?{javascript_obj_name}(.|\n)*?=(.|\n)*?;(.|\n)*?){{((.|\n)*?)}};"

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
