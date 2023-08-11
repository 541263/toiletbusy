local tsl2561 = require "tsl2561" -- ???
local i2cID = 0 -- ???
local SDAPIN = 2 -- pin 2 = D2 = GPIO4
local SCLPIN = 1 -- pin 1 = D1 = GPIO5
local TSL_ADDR = tsl2561.ADDRESS_FLOAT -- tsl2561.ADDRESS_GND || tsl2561.ADDRESS_VDD depends on witch gap soldered
i2c.setup(i2cID, SDAPIN, SCLPIN, i2c.SLOW) -- i don't know if this line is needed
tsl2561.init(SDAPIN, SCLPIN, TSL_ADDR, tsl2561.PACKAGE_T_FN_CL)

function getlux()
  toilet = nil

  status = tsl2561.init(SDAPIN, SCLPIN, TSL_ADDR, tsl2561.PACKAGE_T_FN_CL)
  if status == tsl2561.TSL2561_OK then
    toilet = tsl2561.getlux()
  end
  
  return toilet
end

function sendlux(lux)
  http.get("http://host/lights.php?lux="..lux, nil, function(code, data)
      if (code < 0) then
        print("-")
      elseif (code == 200) then
        print("+")
      else
        print(code, data)
      end
    end)
end

function loop()
  sendlux(getlux())
  print(".")
end

print("set dns")
net.dns.setdnsserver("8.8.8.8",1)

print("start infinite loop ")

-- mytimer = tmr.create()
-- mytimer:register(5000, tmr.ALARM_AUTO, loop)
-- mytimer:start()

-- OR

tmr.create():alarm(5000, tmr.ALARM_AUTO, loop)

-- sendlux(0, 65535)
