function Vector2(x, y)
  return {x = x, y = y}
end

function Vector3(x, y, z)
  return {x = x, y = y, z = z}
end

function DegToRad(d)
  return math.pi * d / 180
end

map_name =  "/home/connor/ar_ws/src/amrl_libraries/amrl_maps/GDC1/GDC1.vectormap.txt";
-- Simulator starting location.
start_x = -21
start_y = 9.0
start_angle = 0.0

-- Time-step for simulation.
delta_t = 0.025

-- Car dimensions.
car_width = 0.281
car_length = 0.535
car_height = 0.15;

-- Location of the robot's rear wheel axle relative to the center of the body.
rear_axle_offset = -0.162
laser_loc = Vector3(0.2, 0, 0.15)

-- Kinematic and dynamic constraints for the car.
min_turn_radius = 0.98
max_speed = 5.0
max_accel = 5.0

-- Laser noise simulation.
laser_noise_stddev = 0.01

-- Turning error simulation.
angular_error_bias = DegToRad(0);
angular_error_rate = 0.1;
