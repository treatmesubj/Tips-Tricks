import win32gui
import win32con
import win32process
import os
import subprocess
import time
import pygetwindow
import win32ui
import win32com.client


def get_hwnds_for_pid(pid):
    '''pid => subprocess.Popen("file.ext").pid'''
    '''pid needs time delay for window to open'''
    def callback(hwnd, hwnds):
        if win32gui.IsWindowVisible(hwnd) and win32gui.IsWindowEnabled(hwnd):
            _, found_pid = win32process.GetWindowThreadProcessId(hwnd)
            if found_pid == pid:
                hwnds.append(hwnd)
        return True
    hwnds = []
    win32gui.EnumWindows(callback, hwnds)
    return hwnds


#mywindow = subprocess.Popen("notepad.exe")
# time.sleep(2)

# for hwnd in get_hwnds_for_pid(mywindow.pid):
    #print("subprocess hwnd: ", hwnd, "- title: ", win32gui.GetWindowText(hwnd))
    #win32gui.MessageBox(hwnd, "Hello", "Wow", win32con.MB_OK)
    #  win32gui.SendMessage(hwnd, win32con.WM_CLOSE, 0, 0)


openhwnds = pygetwindow.getAllWindows()
opentitles = pygetwindow.getAllTitles()
windowinfo = zip(openhwnds, opentitles)
for window, windowname in windowinfo:
    # print("hwnd: ", window._hWnd, "- title: ", windowname)
    if "IBM Notes" in windowname:
        window.activate()
        notes = (window._hWnd, windowname)
        print(notes)
        # win32gui.SendMessage(notes[0], win32con.WM_CLOSE, 0, 0)
        break

x = win32com.client.Dispatch('Lotus.Notessession')

# print(notes)
# notesSession = win32com.client.Dispatch(notes[1])
# x = win32ui.FindWindow(None, "IBM Notes")
# x.activate()
