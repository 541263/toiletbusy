local SCLPIN = 1
local SDAPIN = 2
local TSL1_ADDR = 0x29
local TSL2_ADDR = 0x39
local I2C_ID = 0
local state_lux1 = -1
local state_lux2 = -1
local threshold = 5000 -- 0..2000 ambient, ~12000 low light, ~49000 high light

function writebyte(bus, device, reg, val)
    i2c.start(bus)
    i2c.address(bus, device, i2c.TRANSMITTER)
    i2c.write(bus, reg)
    i2c.write(bus, val)
    i2c.stop(bus)
end

function readbyte(bus, device, reg)
    i2c.start(bus)
    i2c.address(bus, device, i2c.TRANSMITTER)
    i2c.write(bus, reg)
    i2c.stop(bus)
    i2c.start(bus)
    i2c.address(bus, device, i2c.RECEIVER)
    b = i2c.read(bus, 1)
    i2c.stop(bus)
    return string.byte(b)
end

function sendlux(lux1, lux2)
    print(lux1, lux2) -- just for debug
    http.get("http://host/lights.php?lux1="..lux1.."&lux2="..lux2, nil, function(code, data)
        if (code ~= 200) then
            print(code, data) -- just for debug
        end
    end)
end

function loop()
	local changed = 0
	local cur_lux1 = 0
	local cur_lux2 = 0

    -- light1
    writebyte(I2C_ID, TSL1_ADDR, 0x80, 0x03)
    writebyte(I2C_ID, TSL1_ADDR, 0x81, 0x02)
    writebyte(I2C_ID, TSL1_ADDR, 0x80, 0x00)
    tmr.delay(1000) -- guard interval
    -- light2
    writebyte(I2C_ID, TSL2_ADDR, 0x80, 0x03)
    writebyte(I2C_ID, TSL2_ADDR, 0x81, 0x02)
    writebyte(I2C_ID, TSL2_ADDR, 0x80, 0x00)
    tmr.delay(1000) -- guard interval
    -- light1
    writebyte(I2C_ID, TSL1_ADDR, 0x80, 0x03)
    tmr.delay(1000) -- guard interval
    -- light2
    writebyte(I2C_ID, TSL2_ADDR, 0x80, 0x03)
    tmr.delay(500000) -- time to accumulation
    -- light1
    c = readbyte(I2C_ID, TSL1_ADDR, 0x8C)
    d = readbyte(I2C_ID, TSL1_ADDR, 0x8D)
    cur_lux1 = c+d*256
	tmr.delay(1000) -- guard interval
    -- light2
    c = readbyte(I2C_ID, TSL2_ADDR, 0x8C)
    d = readbyte(I2C_ID, TSL2_ADDR, 0x8D)
    cur_lux2 = c+d*256

	if (cur_lux1>threshold) and (state_lux1~=1) then -- lux1 turned ON
		state_lux1 = 1
		changed = 1
	elseif (cur_lux1<threshold) and (state_lux1~=0) then -- lux1 turned OFF
		state_lux1 = 0
		changed = 1
	end

	if (cur_lux2>threshold) and (state_lux2~=1) then -- lux2 turned ON
		state_lux2 = 1
		changed = 1
	elseif (cur_lux2<threshold) and (state_lux2~=0) then -- lux2 turned OFF
		state_lux2 = 0
		changed = 1
	end
	
	if (changed == 1) then -- any change
		sendlux(cur_lux1, cur_lux2)
	end	
end

print("start i2c")
i2c.setup(I2C_ID, SDAPIN, SCLPIN, i2c.FAST)

print("set dns")
net.dns.setdnsserver("8.8.8.8",1)

print("start infinite loop ")
tmr.create():alarm(1000, tmr.ALARM_AUTO, loop) -- every second
