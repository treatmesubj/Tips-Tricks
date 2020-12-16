import regex  # conditional look-arounds
import json


# legit regex: (?<=var(.|\n)*?javascript_obj_name(.|\n)*?=(.|\n)*?)(?<!var(.|\n)*?javascript_obj_name(.|\n)*?=(.|\n)*?;(.|\n)*?)({((.|\n)*?)});

def json_from_script_to_dict(javascript_object_name, script):

	reggy = fr"(?<=var(.|\n)*?{javascript_object_name}(.|\n)*?=(.|\n)*?)(?<!var(.|\n)*?{javascript_object_name}(.|\n)*?=(.|\n)*?;(.|\n)*?)({{((.|\n)*?)}});"
	jaysean = regex.search(reggy, text)
	sanjay = json.loads(jaysean.group(8))
	return sanjay


text = """
<script>
var lunch = {
	"meal": "sammy",
	"drink": "milk"
};

var dummy_obj = {
	"id": "0001",
	"type": "donut",
	"name": "Cake",
	"ppu": 0.55,
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
