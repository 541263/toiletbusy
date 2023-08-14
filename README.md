# toiletbusy

Sometimes the toilet is somewhere far away from your workplace and you can't realize when it's free or occuped until you get close.
This project helps to cope with it.

You need a NodeMCU (ESP8266) with Lua support. Ambient light sensor TSL2561. A little soldering and so one.

First of all, take an firmware from https://nodemcu-build.com with pointed these modules (plus to default) ![b7c8af05-fb3b-4247-ba90-553f1fc5300e](https://github.com/541263/toiletbusy/assets/31769013/d395bdb0-9c61-4601-b73a-3be648db9b67)

Upload firmware with ESP8266Flasher.exe 
Don't forget to write INTERNAL://BLANK page to 0x3FC000 and make format() after flashing.

Change timer timings and URL of your website in application.lua, wi-fi credentials in credentials.lua and save all of *.lua with ESPlorer on the NodeMCU flash.

Solder scheme like on the ![ESP8266-TSL2561-scheme](https://github.com/541263/toiletbusy/assets/31769013/ceafc48f-efa5-4e81-afa6-a5fdb22f1822)

And it should work.
