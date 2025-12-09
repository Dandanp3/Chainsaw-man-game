// checar colisao com player
var player = place_meeting(x, y, objPlayer)

var espaco = keyboard_check_released(ord("R")) or gamepad_button_check_pressed(global.gamepad_id, gp_shoulderl)

if (player && espaco)
{
	// transiçao
	var tran = instance_create_layer(0, 0, layer, objTransicao);
	tran.destino = destino;
	tran.destino_x = destino_x;
	tran.destino_y = destino_y;
	
}