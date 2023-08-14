local SCLPIN = 1 -- pin 1 / D1 / GPIO5
local SDAPIN = 2 -- pin 2 / D2 / GPIO4
local TSL1_ADDR = 0x29 -- soldered to GND
local TSL2_ADDR = 0x39 -- not soldered (FLOAT)
local I2C_ID = 0 -- the only bus

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

speed = i2c.setup(I2C_ID, SDAPIN, SCLPIN, i2c.FAST)

-- light1
writebyte(I2C_ID, TSL1_ADDR, 0x80, 0x03) -- enable
writebyte(I2C_ID, TSL1_ADDR, 0x81, 0x02) -- set timing 402ms & gain 1x
writebyte(I2C_ID, TSL1_ADDR, 0x80, 0x00) -- disable
tmr.delay(1000)
writebyte(I2C_ID, TSL1_ADDR, 0x80, 0x03) -- enable
tmr.delay(500000)
c = readbyte(I2C_ID, TSL1_ADDR, 0x8C) -- read 0 channel (fullspectrum low)
d = readbyte(I2C_ID, TSL1_ADDR, 0x8D) -- read 0 channel (fullspectrum high)

lux1=c+d*256

-- light2
writebyte(I2C_ID, TSL2_ADDR, 0x80, 0x03) -- enable
writebyte(I2C_ID, TSL2_ADDR, 0x81, 0x02) -- set timing 402ms & gain 1x
writebyte(I2C_ID, TSL2_ADDR, 0x80, 0x00) -- disable
tmr.delay(1000)
writebyte(I2C_ID, TSL2_ADDR, 0x80, 0x03) -- enable
tmr.delay(500000)
c = readbyte(I2C_ID, TSL2_ADDR, 0x8C) -- read 0 channel (fullspectrum low)
d = readbyte(I2C_ID, TSL2_ADDR, 0x8D) -- read 0 channel (fullspectrum high)

lux2=c+d*256

print(lux1)
print(lux2)
