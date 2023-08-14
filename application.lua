local tsl2561 = require "tsl2561"
local SCLPIN = 1 -- pin 1 = D1 = GPIO5
local SDAPIN = 2 -- pin 2 = D2 = GPIO4
local TSL_ADDR = tsl2561.ADDRESS_FLOAT -- or tsl2561.ADDRESS_GND or tsl2561.ADDRESS_VDD depends on which gap is soldered

function getlux()
  toilet = nil

  status = tsl2561.init(SDAPIN, SCLPIN, TSL_ADDR, tsl2561.PACKAGE_T_FN_CL)
  if status == tsl2561.TSL2561_OK then
    toilet = tsl2561.getlux()
  end
  
  return toilet
end

function sendlux(lux)
  http.get("http://3221.ru/lights.php?lux="..lux, nil, function(code, data)
      if (code < 0) then
      elseif (code == 200) then
      else
        print(code, data) -- just for debug
      end
    end)
end

function loop()
  sendlux(getlux())
end

print("set dns")
net.dns.setdnsserver("8.8.8.8",1)

print("start infinite loop ")
tmr.create():alarm(10000, tmr.ALARM_AUTO, loop)
