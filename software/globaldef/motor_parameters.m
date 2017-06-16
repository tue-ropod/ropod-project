% Motor physical parameters
motor_physical_parameters.maxcurrent.value  =   25;
motor_physical_parameters.maxcurrent.units  =   '[A]';

motor_physical_parameters.maxvelocity.value  =   130;
motor_physical_parameters.maxvelocity.units  =   '[rad/s]';

motor_physical_parameters.torqueconstant.value  =   0.28;
motor_physical_parameters.torqueconstant.units  =   '[Nm/A]';

% Motor software parameters
motor_software_parameters.maxcurrent.value  =   5;
motor_software_parameters.maxcurrent.units  =   '[A]';

motor_software_parameters.maxvelocity.value  =   100;
motor_software_parameters.maxvelocity.units  =   '[rad/s]';

% Motor Input Interface Parameters

motor_in_interface_parameters.wheelvelcommandconversion.value  =   1/0.01; 
motor_in_interface_parameters.wheelvelcommandconversion.units  =   '[unit/rad/s]';

motor_in_interface_parameters.currentcommandconversion.value  =   1/0.01; 
motor_in_interface_parameters.currentcommandconversion.units  =   '[unit/A]';

% Motor Output Interface Parameters

motor_out_interface_parameters.currentreadconversion.value  =   0.01; 
motor_out_interface_parameters.currentreadconversion.units  =   '[A/unit]';

motor_out_interface_parameters.wheelvelreadconversion.value  =   0.01; 
motor_out_interface_parameters.wheelvelreadconversion.units  =   '[rad/sec/unit]';

motor_out_interface_parameters.inputvoltagereadconversion.value  =   0.01; 
motor_out_interface_parameters.inputvoltagereadconversion.units  =   '[V/unit]';

motor_out_interface_parameters.wheelposreadconversion.value  =   2*pi/65536; 
motor_out_interface_parameters.wheelposreadconversion.units  =   '[rad/unit]';

motor_out_interface_parameters.pivotposreadconversion.value  =   2*pi/65536; 
motor_out_interface_parameters.pivotposreadconversion.units  =   '[rad/unit]';

% Gyro Output Interface Parameters

gyro_out_interface_parameters.temperaturereadconversion.value  =   0.5; 
gyro_out_interface_parameters.temperaturereadconversion.units  =   '[C/unit]';

gyro_out_interface_parameters.accelerationreadconversion.value  =   9.8/512; 
gyro_out_interface_parameters.accelerationreadconversion.units  =   '[m/s^2/unit]';

gyro_out_interface_parameters.velocityreadconversion.value  =   pi/180/20000; 
gyro_out_interface_parameters.velocityreadconversion.units  =   '[rad/s/unit]';