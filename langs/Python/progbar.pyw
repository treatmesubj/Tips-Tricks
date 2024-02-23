from pywin.mfc import dialog
import win32ui
import win32con
import time


def DlgTemplate():
    style = (win32con.DS_MODALFRAME |
             win32con.WS_POPUP |
             win32con.WS_VISIBLE |
             win32con.WS_CAPTION |
             win32con.WS_SYSMENU |
             win32con.DS_SETFONT)

    w = 215
    h = 36

    dlg = [["Progress bar",
            (0, 0, w, h),
            style,
            None,
            (8, "Comic Sans MS")],
           ]

    return dlg


class TestDialog(dialog.Dialog):
    def OnInitDialog(self):
        rc = dialog.Dialog.OnInitDialog(self)
        self.pbar = win32ui.CreateProgressCtrl()
        self.pbar.CreateWindow(win32con.WS_CHILD |
                               win32con.WS_VISIBLE,
                               (10, 10, 360, 24),
                               self, 1001)
        # self.pbar.SetStep (5)
        self.progress = 0
        self.pincr = 10
        return rc


def demo(modal=0):
    d = TestDialog(DlgTemplate())
    if modal:
        print(d.DoModal())
    else:
        d.CreateWindow()
        for i in range(100):
            time.sleep(1)
            d.pbar.SetPos(i)


demo(0)
