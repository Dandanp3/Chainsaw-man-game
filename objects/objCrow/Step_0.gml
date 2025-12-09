var _chao = place_meeting(x, y + 1, objWall);
if (!_chao)
{
	velv += 0.3;
}

if (invulnerabilidade_timer > 0)
{
    invulnerabilidade_timer--;
}
else
{
    pode_tomar_dano = true;
    // visible = true; 
}

switch(estado)
{
	case "parado":
	{
		pode_tomar_dano = true;
		velh = 0;
		sprite_index = spr_parado;
		
		// Conta o tempo para o PRÓXIMO grito
		if (timer_grito > 0)
		{
			timer_grito--;
		}
		else
		{
			estado = "grito";
			image_index = 0;
			ataque_realizado = false;
		}
		break;
	}
	
	case "grito":
	{
	    velh = 0;
	    sprite_index = spr_ataque; 
		if (!audio_is_playing(Scream))
	    {
	        audio_play_sound(Scream, 1, true);
	    }

	    if (image_index >= 3 && !ataque_realizado)
	    {
	        ataque_realizado = true;
        
	        if (dano_grito == noone)
	        {
	            dano_grito = instance_create_layer(x, y, layer, objDano);
	            dano_grito.dano = ataque;
	            dano_grito.pai = id;
	            dano_grito.image_xscale = 10;
	            dano_grito.image_yscale = 5;
	        }
	        instance_create_layer(x - 150, y - 20, layer, objWolf); 
	        instance_create_layer(x + 150, y - 20, layer, objWolf);
        
	        var _dist_min = 64;       
	        var _tentativas_max = 20; 

	        repeat(4)
	        {
	            var _trap_spawnada = false;
	            var _tentativa = 0;
    
	            // Tenta encontrar uma posição válida
	            while (!_trap_spawnada && _tentativa < _tentativas_max)
	            {
	                var _x_aleatorio = irandom_range(50, room_width - 50);
	                var _y_fixo = 288;

	                var _trap_perto = instance_nearest(_x_aleatorio, _y_fixo, objTrap);
	                var _pode_spawnar = true;

	                if (_trap_perto != noone)
	                {
	                    if (point_distance(_x_aleatorio, _y_fixo, _trap_perto.x, _trap_perto.y) < _dist_min)
	                    {
	                        _pode_spawnar = false;
	                    }
	                }

	                if (_pode_spawnar)
	                {
	                    instance_create_layer(_x_aleatorio, _y_fixo, layer, objTrap);
	                    _trap_spawnada = true;
	                }
                
	                _tentativa++;
	            }
	        }
        
	        screenshake(5); 
	    }
		audio_stop_sound(Scream);
	    if (image_index >= image_number - 1)
	    {
	        estado = "parado";
	        timer_grito = timer_grito_max; 
        
	        if (dano_grito != noone)
	        {
	            instance_destroy(dano_grito);
	            dano_grito = noone;
	        }
	    }
    
	    break;
	}
    
    case "dano":
    {
        pode_tomar_dano = false; 
        
        sprite_index = sprCrownHurt;
        
        if (image_index >= image_number - 1) 
        {
            if (vida_atual <= 0)
            {
                estado = "morte";
                image_index = 0;
            }
            else 
            {
                estado = "teleporte"; 
                image_index = 0; 
            }
        }
        break;
    }
	
    
    case "morte":
    {
        sprite_index = sprCrowDeath;
        if (image_index >= image_number - 1) instance_destroy();
        break;
    }
	
	case "teleporte":
    {
        pode_tomar_dano = false; 
        
        velh = 0;
        if (sprite_index != sprCrownTP)
        {
            sprite_index = sprCrownTP;
            image_index = 0;
            image_speed = 1;
        }
        
        if (image_index >= image_number - 1)
        {
            var _novo_x = irandom_range(50, room_width - 50); 
            x = _novo_x;
            
            estado = "reaparece";
            image_index = 0;
        }
        break;
    }

// D. Novo Estado: Reaparecendo
	case "reaparece":
	{
	    velh = 0;
		pode_tomar_dano = true;
    
	    if (sprite_index != sprCrownTP2)
	    {
	        sprite_index = sprCrownTP2;
	        image_index = 0;
	        image_speed = 1;
	    }
    
	    if (image_index >= image_number - 1)
	    {
	        pode_tomar_dano = true; 
        
	        if (timer_grito <= 0)
	        {
	            estado = "grito";
	            image_index = 0;
	            ataque_realizado = false;
	        }
	        else
	        {
	            // Volta a esperar pelo próximo ataque
	            estado = "parado";
	        }
	    }
	    break;
	}
}


