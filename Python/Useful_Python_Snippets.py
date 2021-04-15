"""Modules and Libraries to Import"""

# make a Graphical User Interface to Log in or Select a File
from tkinter import *  # import all of tkinter
from tkinter import filedialog

# Interact with a Web browser
from selenium import webdriver  # import all of Selenium Webdriver
# wait for elements on a page
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC  # conditions
from selenium.webdriver.common.by import By  # shortcut for selecting elements
from selenium.webdriver.support.ui import Select  # choose options from dropdown
from selenium.common.exceptions import *  # handle exceptions
from selenium.webdriver.firefox.options import Options  # options

"""Selenium things"""

# set up headless browser
options = Options()
options.headless = True
driver = webdriver.Firefox(options=options)

# set up browser with no annoying geckologs
driver = webdriver.Firefox(service_log_path=os.path.devnull)
driver.maximize_window()

# Click an element on a page as soon as possible, within a given time limit
WebDriverWait(driver, 10).until(EC.element_to_be_clickable(
    (By.CSS_SELECTOR, '#popupPolicy'))).click()
"""
element = WebDriverWait(driver, <tolerance in seconds>).until(EC.<expected condition>(
    (By.<locating method>, <locator>)))
element.click()
element.send_keys('text to be sent to this element')
"""

# continue to click a button until you can make sure it's actually clicked by checking for the next expected element
while True:
    try:
        WebDriverWait(driver, 10).until(EC.presence_of_element_located(
            (By.NAME, 'Blah'))).click()
        elem2 = driver.find_element_by_css_selector('#idk')
        break  # elem2 was found, therfore we clicked successfully and can continue
    except NoSuchElementException:
        pass  # elem2 wasn't found, keep clicking
# click this thing now that we're where we need to be
driver.find_element_by_css_selector('.thing').click()

"""A log-in GUI class"""
# This LoginGUI class is a type of object with 2 methods
# method1: GUI() creates the actual GUI
# method2: Login() logs in using the GUI's textbox values


class LoginGUI:

    def GUI(self):
        self.root = Tk()
        self.root.attributes("-topmost", True)
        self.root.geometry('280x110')
        self.root.title("Please Log In")
        self.guiuser = StringVar()
        self.guipass = StringVar()
        Label(self.root, text="Username").pack(side=TOP)
        Entry(self.root, textvariable=self.guiuser).pack(
            side=TOP)  # Username
        Label(self.root, text="Password").pack(side=TOP)
        Entry(self.root, show="*",
              textvariable=self.guipass).pack(side=TOP)  # Password
        Button(self.root, text="Submit",
               command=self.Login).pack(side=BOTTOM)
        self.root.bind('<Return>', self.Login)
        self.root.mainloop()

    def Login(self, event=None):
        WebDriverWait(driver, 20).until(EC.presence_of_element_located(
            (By.CSS_SELECTOR, '#j_username'))).send_keys(self.guiuser.get())
        driver.find_element_by_css_selector(
            '#j_password').send_keys(self.guipass.get())
        driver.find_element_by_css_selector('.ibm-btn-arrow-pri').click()
        self.root.destroy()


# Using this LoginGUI class is this easy:
# loginform is an instance of the LoginGUI class; it has the class' abilities
loginform = LoginGUI()
loginform.GUI()  # call the GUI method to bring up the GUI, the GUI will call the Login method
# that's it
