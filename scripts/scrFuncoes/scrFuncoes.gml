function scrFuncoes(){

}


// Enumerator para definir ações
enum menu_acoes
{
	roda_metodo,
	carrega_menu
}

enum menus_lista
{
	principal,
	opcoes
}

///@function screenshake(valor_da_tremida)
///@arg força_da_tremida
function screenshake(_theme)
{
	var shake = instance_create_layer(0, 0, "instances", objScreenShake);
	shake.shake = _theme
}


// Define align
///@function define_align(vertical, horizontal)
function define_align(_ver, _hor)
{
	draw_set_halign(_hor);
	draw_set_valign(_ver);
}

// Pegar valor da anim Curve
///@function valor_ac(animation_curve, canal, animar, [canal])
function valor_ac(_anim, _animar= false, _chan = 0)
{
	// Posiçao da animaçao
	static _pos = 0, _val = 0;
	
	// Aumentando valor do pos
	// 1seg a
	_pos += delta_time / 1000000
	
	if (_animar) _pos = 0;
	
	//valor do canal
	var _canal = animcurve_get_channel(_anim, _chan);
	_val = animcurve_channel_evaluate(_canal, _pos);
	
	show_debug_message(_val);
	
	return _val;
}