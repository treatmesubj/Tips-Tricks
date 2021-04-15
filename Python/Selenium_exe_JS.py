from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
import os

driver = webdriver.Firefox(service_log_path=os.path.devnull)
driver.maximize_window()

JScommands = (
    "window.open('https://www.google.com/');",
    "window.scrollTo(0, 0);",
    "window.open('', '', 'width=400, height=400').document.write('<p>A new window!</p>');"
)

for command in JScommands:
    driver.execute_script(command)

    
# selecting parent element by child's CSS selector with JS
child_elem = driver.find_element_by_css_selector("#child")
parent_elem = driver.execute_script("return arguments[0].parentNode;", child_elem)
