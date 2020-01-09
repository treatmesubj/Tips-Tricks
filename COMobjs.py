import win32com.client as win32
import win32api
import pythoncom
from inspect import getmembers
from tkinter import *
from tkinter import filedialog


def get_hwnds_for_pid(pid):
    '''pid => subprocess.Popen("file.ext").pid'''
    def callback(hwnd, hwnds):
        if win32gui.IsWindowVisible(hwnd) and win32gui.IsWindowEnabled(hwnd):
            _, found_pid = win32process.GetWindowThreadProcessId(hwnd)
            if found_pid == pid:
                hwnds.append(hwnd)
        return True
    hwnds = []
    win32gui.EnumWindows(callback, hwnds)
    return hwnds


def print_members(obj, obj_name="placeholder_name"):
    """Print members of given COM object"""
    try:
        fields = list(obj._prop_map_get_.keys())
    except AttributeError:
        print("Object has no attribute '_prop_map_get_'")
        print("Check if the initial COM object was created with"
              "'win32com.client.gencache.EnsureDispatch()'")
        raise
    methods = [m[0] for m in getmembers(obj) if (
        not m[0].startswith("_") and "clsid" not in m[0].lower())]

    if len(fields) + len(methods) > 0:
        print("Members of '{}' ({}):".format(obj_name, obj))
    else:
        raise ValueError("Object has no members to print")

    print("\tFields:")
    if fields:
        for field in fields:
            print(f"\t\t{field}")
    else:
        print("\t\tObject has no fields to print")

    print("\tMethods:")
    if methods:
        for method in methods:
            print(f"\t\t{method}")
    else:
        print("\t\tObject has no methods to print")


def printrunningcoms():
    """Print active COM objects"""
    context = pythoncom.CreateBindCtx(0)
    running_coms = pythoncom.GetRunningObjectTable()
    monikers = running_coms.EnumRunning()
    for moniker in monikers:
        print('-' * 100)
        print(moniker.GetDisplayName(context, moniker))
        print(moniker.Hash())
        


def select_file():
    root = Tk()
    root.attributes("-topmost", True)
    root.filename = filedialog.askopenfilename(
        initialdir="/", title="Select the file please")
    root.destroy()


# xl = win32.gencache.EnsureDispatch("Excel.Application")
# print_members(xl, 'xl')
# # xl.Visible = 1
# xl.Workbooks.Open(root.filename)
# mywb = xl.ActiveWorkbook
# for sheet in mywb.Sheets:
#     print(sheet.Name)

printrunningcoms()

# window = subprocess.Popen("file.ext")
# for hwnd in get_hwnds_for_pid(window.pid):
#    print(hwnd, "=>", win32gui.GetWindowText(hwnd))

# close it out
# for i in range(1, 4):
#     win32api.Beep(i * 1000, 700)
#     win32api.Beep(i * 700, 700)
# win32api.Beep(1000, 3000)
# username = win32api.GetUserName()
# s = win32.Dispatch('SAPI.SpVoice')
# voices = [i for i in s.GetVoices()]
# s.Voice = voices[1]
# s.Rate = 1
# s.Speak(f"Yes, this is working nicely. {username}, you have done well.")
