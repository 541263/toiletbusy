
SDAPIN = 4
SCLPIN = 5
TSL_ADDR = tsl2561.ADDRESS_FLOAT -- tsl2561.ADDRESS_GND || tsl2561.ADDRESS_VDD depends on witch gap soldered

function getlux()
  toilet = nil

  -- toilet
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
