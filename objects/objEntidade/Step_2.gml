// Colisão e movimentação
var _velh = sign(velh)
var _velv = sign(velv);

repeat(abs(velh))
{
	if (place_meeting(x + _velh, y, objWall))
	{
		velh = 0;
		break;
	}
	x += _velh;
}

// Vertical
repeat(abs(velv))
{
	if (place_meeting(x, y + _velv, objWall))
	{
		velv = 0;
		break;
	}
	y += _velv;
}

