// includes
#require "Si702x.class.nut:1.0.0"

// configure the hardware
hardware.i2c89.configure(CLOCK_SPEED_400_KHZ)

// init sensor
local sensor = Si702x(hardware.i2c89)

// listen to the agent
agent.on("saytemp", function(userName) {
    
    server.log("Data from server:" + userName);
    
    // read the weather
    sensor.read(function(reading) {
        // send the temperature back to agen
        agent.send("heartemp", { 
                user = userName,  
                temperature = reading.temperature
        });
        
    });
 
});
// TODOs
// error conditions
