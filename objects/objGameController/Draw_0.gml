// Game Over

if (game_over)
{
	show_debug_message("salve seres humanos")
	// Pegando info
	var x1 = camera_get_view_x(view_camera[0]);
	var w = camera_get_view_width(view_camera[0]);
	var x2 = x1 + w;
	var meio_w = x1 + w/2
	var y1 = camera_get_view_y(view_camera[0]);
	var h = camera_get_view_height(view_camera[0]);
	var y2 = y1 + h;
	var meio_h = y2/2;
	
	var qtd = h * .15;
	valor = lerp(valor, 1, .05);
	
	draw_set_colour(c_black)
	// Escurecer tela
	draw_set_alpha(valor - .3)
	draw_rectangle(x1, y1, x2, y2, false);
	
	// Desenhando retangulo de cima
	draw_set_alpha(1);
	draw_rectangle(x1, y1, x2, y1 + qtd * valor, false)
	
	// Retangulo de baixo
	draw_rectangle(x1, y2, x2, y2 - qtd * valor, false)
	
	draw_set_alpha(1)
	draw_set_color(-1)
	
	// Dando delay
	if (valor > .95)
	{
		contador = lerp(contador, 1, .01)
		// Escrevendo Game over
		draw_set_alpha(contador);
		draw_set_font(fntGameOver)
		draw_set_valign(1);
		draw_set_halign(1);
		// Sombra
		draw_set_colour(c_red)
		draw_text(meio_w, meio_h, "Game Over")
		// Texto
		draw_set_colour(c_white)
		draw_text(meio_w + 1, meio_h + 1, "Game Over")
		draw_set_font(-1)
		
		draw_text(meio_w, meio_h + 50, "Press Start to Restart")
		
		draw_set_valign(-1);
		draw_set_halign(-1);
		
		draw_set_alpha(-1);
	}
}
else 
{
	valor = 0;	
}