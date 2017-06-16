% Smart Wheel parameters
wheel_physical_parameters.diameter.value  =   0.073;
wheel_physical_parameters.diameter.units  =   '[m]';

wheel_physical_parameters.width.value  =   0.0545;
wheel_physical_parameters.width.units  =   '[m]';

wheel_physical_parameters.singlewheel_mass.value  =   0.3;
wheel_physical_parameters.singlewheel_mass.units  =   '[kg]';

wheel_physical_parameters.separation.value  =   0.0893;
wheel_physical_parameters.separation.units  =   '[m]';

wheel_physical_parameters.middleaxis_mass.value  =   0.5;
wheel_physical_parameters.middleaxis_mass.units  =   '[kg]';

wheel_physical_parameters.caster_offset.value  =   0.01;
wheel_physical_parameters.caster_offset.units  =   '[m]';

wheel_physical_parameters.casteraxis_mass.value  =   0.15;
wheel_physical_parameters.casteraxis_mass.units  =   '[kg]'; 

% Inertia of the wheel's main axis around z-axes. Rough estimation using the formula of a solid cube
% For now we suppose a connecting bar of 0.05m by 0.2m by 0.1m
wheel_physical_parameters.casteraxis_inertia.value  = (0.05^2+0.2^2)/12* wheel_physical_parameters.middleaxis_mass.value; 
wheel_physical_parameters.casteraxis_inertia.units  = '[kg m^2]';

% Inertia of the caster offset axis around z-axes. Rough estimation using the formula of a solid cube. 
% For now we suppose a connecting bar of 0.05m by 0.2m by 0.1m
wheel_physical_parameters.casteraxis_inertia_zaxis.value    = (0.1^2+0.2^2)/12 * wheel_physical_parameters.casteraxis_mass.value;  
wheel_physical_parameters.casteraxis_inertia_zaxis.units    = '[kg m^2]';

% Inertia of an individual wheel around z-axes (around diameter)
wheel_physical_parameters.singlewheel_inertia_zaxis.value   = 1/12*( wheel_physical_parameters.width.value^2 + 3*( 0.5*wheel_physical_parameters.diameter.value )^2 )* wheel_physical_parameters.singlewheel_mass.value;    
wheel_physical_parameters.singlewheel_inertia_zaxis.units   = '[kg m^2]';

% Inertia of an individual wheel around y^W-axis (rolling)
wheel_physical_parameters.singlewheel_inertia_rolling.value  = 0.5*( 0.5*wheel_physical_parameters.diameter.value )^2 * wheel_physical_parameters.singlewheel_mass.value;    
wheel_physical_parameters.singlewheel_inertia_rolling.units  = '[kg m^2]';

% ropod parameters

ropod_physical_parameters.base_width.value  =   0.4;
ropod_physical_parameters.base_width.units  =   '[m]';

ropod_physical_parameters.base_depth.value  =   0.4;
ropod_physical_parameters.base_depth.units  =   '[m]';

ropod_physical_parameters.wheel_symmetric_distribution.value    =   0.15;
ropod_physical_parameters.wheel_symmetric_distribution.units    =   '[m]';


ropod_physical_parameters.wheel_distribution.value  =  [1  1 -1 -1;
                                                       1 -1 -1 1]*ropod_physical_parameters.wheel_symmetric_distribution.value; % [x;y] values
ropod_physical_parameters.wheel_distribution.units  =   '[m]';

ropod_physical_parameters.ropod_mass.value  =   10;
ropod_physical_parameters.ropod_mass.units  =   '[kg]';

% Robot base inertia around z-axes. Rough estimation using the formula of a solid cube
ropod_physical_parameters.ropod_base_inertia.value = 1/12*(ropod_physical_parameters.base_width.value^2 + ropod_physical_parameters.base_depth.value^2) * ropod_physical_parameters.ropod_mass.value; 
ropod_physical_parameters.ropod_base_inertia.units = '[kg m^2]';
