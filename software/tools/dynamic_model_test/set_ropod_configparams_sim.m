
run ../../globaldef/ropod_parameters

ropod_dynmodel_param.r_w    = wheel_physical_parameters.diameter.value;
ropod_dynmodel_param.s_w    = wheel_physical_parameters.caster_offset.value; % 3e-2; %
ropod_dynmodel_param.d_w    = wheel_physical_parameters.separation.value;
ropod_dynmodel_param.l_CW   = ropod_physical_parameters.wheel_symmetric_distribution.value;

ropod_dynmodel_param.Mr     = ropod_physical_parameters.ropod_mass.value;
ropod_dynmodel_param.Ir     = ropod_physical_parameters.ropod_base_inertia.value;
ropod_dynmodel_param.Mwma   = wheel_physical_parameters.middleaxis_mass.value;  
ropod_dynmodel_param.Iwma   = wheel_physical_parameters.casteraxis_inertia_zaxis.value;
ropod_dynmodel_param.Mwca   = wheel_physical_parameters.casteraxis_mass.value;   % The fact that the mass increases with caster offset is not taken into account.
ropod_dynmodel_param.Iwca   = wheel_physical_parameters.casteraxis_inertia_zaxis.value;
ropod_dynmodel_param.Mw     = wheel_physical_parameters.singlewheel_mass.value;     % Mass of an individual wheel
ropod_dynmodel_param.Iwz    = wheel_physical_parameters.singlewheel_inertia_zaxis.value;
ropod_dynmodel_param.Iwp    = wheel_physical_parameters.singlewheel_inertia_rolling.value;

ropod_dynmodel_pv = struct2array(ropod_dynmodel_param);

