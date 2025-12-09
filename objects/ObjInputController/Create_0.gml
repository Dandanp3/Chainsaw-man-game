global.gamepad_id = noone;

gamepad_connect = function(){
	var _gamepad_slots = gamepad_get_device_count();
	
	for(var _i = 0; _i < _gamepad_slots; _i++){
		if (gamepad_is_connected(_i)){
			global.gamepad_id = _i;
			gamepad_set_axis_deadzone(global.gamepad_id, AXIS_DEADZONE)
			return  true;	
		}	
	}
	
	return false;
}