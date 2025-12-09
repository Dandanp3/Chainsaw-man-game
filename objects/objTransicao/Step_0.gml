if (mudei)
{
	alpha -= .01;
}
else // Ainda nao saiu da room
{
	alpha += .01;	
}

if (alpha >= 1)
{
	room_goto(destino)	
	// Controlando posição
	objPlayer.x = destino_x;
	objPlayer.y = destino_y;
}

// Destruindo dps de mudança de room

if (mudei && alpha <= 0)
{
	instance_destroy();	
}