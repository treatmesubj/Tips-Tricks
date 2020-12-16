import re
import regex  # conditional look-arounds
import json
# legit regex: (?<=var(.|\n)*?javascript_object_name(.|\n)*?=(.|\n)*?)(?<!var(.|\n)*?javascript_object_name(.|\n)*?=(.|\n)*?;(.|\n)*?)({((.|\n)*?)});





def remove_comments(string):
	"""
	removes comments from JS source
	"""
	pattern = r"(\".*?\"|\'.*?\')|(/\*.*?\*/|//[^\r\n]*$)"
	regex = re.compile(pattern, re.MULTILINE|re.DOTALL)
	def _replacer(match):
	    if match.group(2) is not None:
	        return ""
	    else:
	        return match.group(1)
	return regex.sub(_replacer, string)


def json_from_script_to_dict(javascript_object_name, script):
	"""
	parses Javascript for an object and returns it as a dictionary
	"""
	reggy = fr"(?<=var(.|\n)*?{javascript_object_name}(.|\n)*?=(.|\n)*?)(?<!var(.|\n)*?{javascript_object_name}(.|\n)*?=(.|\n)*?;(.|\n)*?)({{((.|\n)*?)}});"
	jaysean = regex.search(reggy, remove_comments(text))
	sanjay = json.loads(jaysean.group(8))
	return sanjay


text = """
<script>
var lunch = {
	/* some dumb 
		comment */
	"meal": "sammy",
	"drink": "milk"
};

var dummy_obj = {
	"id": "0001",
	"type": "donut",
	"name": "Cake",
	"ppu": 0.55,
	// hey, I've got something to say
	"batters":
		{
			"batter":
				[
					{ "id": "1001", "type": "Regular" },
					{ "id": "1002", "type": "Chocolate" },
					{ "id": "1003", "type": "Blueberry" },
					{ "id": "1004", "type": "Devil's Food" }
				]
		},
	"topping":
		[
			{ "id": "5001", "type": "None" },
			{ "id": "5002", "type": "Glazed" },
			{ "id": "5005", "type": "Sugar" },
			{ "id": "5007", "type": "Powdered Sugar" },
			{ "id": "5006", "type": "Chocolate with Sprinkles" },
			{ "id": "5003", "type": "Chocolate" },
			{ "id": "5004", "type": "Maple" }
		]
};

var breakfast = {
	"meal": "pancake",
	"drink": "oj"
};

</script>
"""

print(json_from_script_to_dict("breakfast", text))
print(json_from_script_to_dict("lunch", text))
print(json_from_script_to_dict("dummy_obj", text))
