    #include p18f87k22.inc
    
#define LSM9DS1_ADDRESS_ACCELGYRO          (0x6B)
#define LSM9DS1_ADDRESS_MAG                (0x1E)
#define LSM9DS1_XG_ID                      (0b01101000)
#define LSM9DS1_MAG_ID                     (0b00111101)


// Linear Acceleration: mg per LSB
#define LSM9DS1_ACCEL_MG_LSB_2G (0.061F)
#define LSM9DS1_ACCEL_MG_LSB_4G (0.122F)
#define LSM9DS1_ACCEL_MG_LSB_8G (0.244F)
#define LSM9DS1_ACCEL_MG_LSB_16G (0.732F) 
    
// Angular Rate: dps per LSB
#define LSM9DS1_GYRO_DPS_DIGIT_245DPS      (0.00875F)
#define LSM9DS1_GYRO_DPS_DIGIT_500DPS      (0.01750F)
#define LSM9DS1_GYRO_DPS_DIGIT_2000DPS     (0.07000F)
    
acs0    udata_acs   ; reserve data space in access ram
    xlo	    res 1;
    xhi	    res 1;
    ylo	    res 1;
    yhi	    res 1;
    zlo	    res 1;
    zhi	    res 1;
    
    
    code
    
Read
    call    readAccel
    call    readGyro
    
Adafruit_LSM9DS1::readAccel() 
    
    end
    


