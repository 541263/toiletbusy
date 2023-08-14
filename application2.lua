local SCLPIN = 1 -- pin 1 = D1 = GPIO5
local SDAPIN = 2 -- pin 2 = D2 = GPIO4
local TSL1_ADDR = 0x39
local I2C_ID = 0

speed = i2c.setup(I2C_ID, SDAPIN, SCLPIN, i2c.FAST)
print(speed)

-- enable
i2c.start(I2C_ID)
i2c.address(I2C_ID, TSL1_ADDR, i2c.TRANSMITTER)
i2c.write(I2C_ID, 0x80)
i2c.write(I2C_ID, 0x03)
i2c.stop(I2C_ID)

-- set timing 402ms & gain 1x
i2c.start(I2C_ID)
i2c.address(I2C_ID, TSL1_ADDR, i2c.TRANSMITTER)
i2c.write(I2C_ID, 0x81)
i2c.write(I2C_ID, 0x02)
i2c.stop(I2C_ID)

-- disable
i2c.start(I2C_ID)
i2c.address(I2C_ID, TSL1_ADDR, i2c.TRANSMITTER)
i2c.write(I2C_ID, 0x80)
i2c.write(I2C_ID, 0x00)
i2c.stop(I2C_ID)

-- 
tmr.delay(1000)

-- enable
i2c.start(I2C_ID)
i2c.address(I2C_ID, TSL1_ADDR, i2c.TRANSMITTER)
i2c.write(I2C_ID, 0x80)
i2c.write(I2C_ID, 0x03)
i2c.stop(I2C_ID)

-- 
tmr.delay(500000)

-- read 0 channel (fullspectrum low)
i2c.start(I2C_ID)
i2c.address(I2C_ID, TSL1_ADDR, i2c.TRANSMITTER)
i2c.write(I2C_ID, 0x8C)
i2c.stop(I2C_ID)
i2c.start(I2C_ID)
i2c.address(I2C_ID, TSL1_ADDR, i2c.RECEIVER)
c = i2c.read(I2C_ID, 1)
i2c.stop(I2C_ID)

-- read 0 channel (fullspectrum high)
i2c.start(I2C_ID)
i2c.address(I2C_ID, TSL1_ADDR, i2c.TRANSMITTER)
i2c.write(I2C_ID, 0x8D)
i2c.stop(I2C_ID)
i2c.start(I2C_ID)
i2c.address(I2C_ID, TSL1_ADDR, i2c.RECEIVER)
d = i2c.read(I2C_ID, 1)
i2c.stop(I2C_ID)

-- read 1 channel (infrared low)
i2c.start(I2C_ID)
i2c.address(I2C_ID, TSL1_ADDR, i2c.TRANSMITTER)
i2c.write(I2C_ID, 0x8E)
i2c.stop(I2C_ID)
i2c.start(I2C_ID)
i2c.address(I2C_ID, TSL1_ADDR, i2c.RECEIVER)
e = i2c.read(I2C_ID, 1)
i2c.stop(I2C_ID)

-- read 1 channel (infrared high)
i2c.start(I2C_ID)
i2c.address(I2C_ID, TSL1_ADDR, i2c.TRANSMITTER)
i2c.write(I2C_ID, 0x8F)
i2c.stop(I2C_ID)
i2c.start(I2C_ID)
i2c.address(I2C_ID, TSL1_ADDR, i2c.RECEIVER)
f = i2c.read(I2C_ID, 1)
i2c.stop(I2C_ID)

fullspectrum=string.byte(c)+(string.byte(d)*256)
infrared=string.byte(e)+(string.byte(f)*256)
print(fullspectrum)
