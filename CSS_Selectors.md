# CSS Selectors
```
#ID
.class
tag
[attr]
[attr='value']
[attr*='txt in value']
[attr^='txt starting in value']
[attr$='txt ending in value']
```
# CSS Combinators
```
+ adjacent sibling, right after
~ sibling 
> direct children, not grand children
descendent
```

# Example Locator
```
$("tag.class[attr*='txt in value']~#siblingId")
// Attribute Contains Two Substrings
$("[href*='select'][href*='.FCFH']")
```

# JS Parent Element (Python Selenium)
```
parent = driver.execute_script("return arguments[0].parentNode;", elem)
```

# JS Fill text Box (Python Selenium)
```
my_string = "nonsense"
my_elem = driver.find_element_by_css_selector("#sup")
driver.execute_script(f"arguments[0].value=\"{my_string}\";", my_elem)
```

# HTML Quick Tricks
```
<html style="overflow: hidden;">
    ***"overflow: hidden": prevents scrolling***
<input id="loginPassword" class="AnimatedForm__textInput" name="password" placeholder="Password" data-empty="false" type="password">
    ***"type='password'": *s & prevents copying text***
```
