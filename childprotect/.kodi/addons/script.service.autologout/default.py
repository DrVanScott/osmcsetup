import xbmc
import os
from subprocess import call

class MyMonitor(xbmc.Monitor):

    request = 0
    sentinel = "/tmp/.heyYouLetMeIn"
    loadkinder = "/tmp/.loadkinder"

    def __init__(self):
        self.request = 1
        xbmc.Monitor.__init__(self)

    def onScreensaverActivated(self):
        if xbmc.getInfoLabel('System.ProfileName') != "Kinder":
            self.request = 1

monitor = MyMonitor()

while not xbmc.abortRequested:
    xbmc.sleep(1000)
    if monitor.request == 1:
        monitor.request = 0
        #xbmc.executebuiltin('ActivateWindow(home)')
        xbmc.executebuiltin("Dialog.Close(all, true)")
        xbmc.sleep(1000)
        xbmc.executeJSONRPC( '{"jsonrpc":"2.0","method":"Input.Home","id":1}' )
        xbmc.sleep(2000)
        xbmc.executebuiltin("System.Logoff()")
        xbmc.sleep(5000)
        call("/home/osmc/.kodi/addons/script.service.autologout/updateKinder.sh")
        xbmc.executebuiltin("XBMC.LoadProfile(Kinder)")

    if os.path.exists(monitor.sentinel):
        if xbmc.getInfoLabel('System.ProfileName') != "Master user":
            xbmc.executebuiltin("Dialog.Close(all, true)")
            xbmc.sleep(1000)
            xbmc.executeJSONRPC( '{"jsonrpc":"2.0","method":"Input.Home","id":1}' )
            xbmc.sleep(2000)
            xbmc.executebuiltin("System.Logoff()")
            xbmc.sleep(5000)
            xbmc.executeJSONRPC( '{"jsonrpc":"2.0","method":"Profiles.LoadProfile","params":{"profile":"Master user","password":{"value":"7815696ecbf1c96e6894b779456d330e","encryption":"md5"}},"id":1}' )
            while xbmc.getInfoLabel('System.ProfileName') != "Master user":
                xbmc.sleep(100)
            xbmc.sleep(5000)
        os.remove(monitor.sentinel)

    if os.path.exists(monitor.loadkinder):
        os.remove(monitor.loadkinder)
	monitor.request=1
