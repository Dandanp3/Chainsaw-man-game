// Gravidade básica
var _chao = place_meeting(x, y + 1, objWall);
if (!_chao)
{
	velv += 0.3;
}

if (invulnerabilidade_timer > 0)
{
    invulnerabilidade_timer--;
    // Opcional: Efeito visual piscando durante a invulnerabilidade
    // visible = !((invulnerabilidade_timer div 3) mod 2);
}
else
{
    pode_tomar_dano = true;
    // visible = true; // Se você usou o efeito de piscar
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
    
	    // Momento do Grito (Invocação e Dano)
	    if (image_index >= 3 && !ataque_realizado)
	    {
	        ataque_realizado = true;
        
	        // --- 1. CRIAR DANO ---
	        if (dano_grito == noone)
	        {
	            dano_grito = instance_create_layer(x, y, layer, objDano);
	            dano_grito.dano = ataque;
	            dano_grito.pai = id;
	            dano_grito.image_xscale = 10;
	            dano_grito.image_yscale = 5;
	        }
        
	        // --- 2. SPAWNAR LOBOS ---
	        instance_create_layer(x - 150, y - 20, layer, objWolf); 
	        instance_create_layer(x + 150, y - 20, layer, objWolf);
        
	        // --- 3. SPAWNAR 8 TRAPS (CORRIGIDO) ---
	        // Agora este código roda apenas UMA vez por ataque
        
	        var _dist_min = 64;       // Distância mínima entre traps
	        var _tentativas_max = 20; // Tentativas para achar lugar vazio

	        repeat(4) // Repete 8 vezes, como você queria
	        {
	            var _trap_spawnada = false;
	            var _tentativa = 0;
    
	            // Tenta encontrar uma posição válida
	            while (!_trap_spawnada && _tentativa < _tentativas_max)
	            {
	                var _x_aleatorio = irandom_range(50, room_width - 50);
	                var _y_fixo = 288;
        
	                // Checa se a nova posição está livre de outras traps
	                // Nota: Usamos point_distance para garantir a _dist_min
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
	    // --- FIM DA ANIMAÇÃO DO GRITO ---
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
        // 1. DESLIGA A RECEPÇÃO DE DANO ENQUANTO ESTIVER NESTE ESTADO
        pode_tomar_dano = false; 
        
        sprite_index = sprCrownHurt;
        
        // A transição só deve ocorrer APÓS o fim da animação de dano.
        if (image_index >= image_number - 1) 
        {
            if (vida_atual <= 0)
            {
                estado = "morte";
                image_index = 0;
            }
            else // vida_atual > 0
            {
                // Transiciona para o teleporte (que também é invulnerável)
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
        // 2. DESLIGA A RECEPÇÃO DE DANO ENQUANTO ESTIVER NESTE ESTADO
        pode_tomar_dano = false; 
        
        velh = 0;
        
        // 1. ANIMAÇÃO DE SUMIR
        if (sprite_index != sprCrownTP)
        {
            sprite_index = sprCrownTP;
            image_index = 0;
            image_speed = 1;
        }
        
        // 2. TELEPORTE AO FINAL DA ANIMAÇÃO DE SUMIR
        if (image_index >= image_number - 1)
        {
            var _novo_x = irandom_range(50, room_width - 50); 
            x = _novo_x;
            
            estado = "reaparece";
            image_index = 0;
            
            // ... (Restante da lógica)
        }
        break;
    }

// D. Novo Estado: Reaparecendo
	case "reaparece":
	{
	    velh = 0;
		pode_tomar_dano = true;
    
	    // 1. ANIMAÇÃO DE APARECER
	    if (sprite_index != sprCrownTP2) // Use spr_aparecendo aqui, não sprCrowDeath
	    {
	        sprite_index = sprCrownTP2;
	        image_index = 0;
	        image_speed = 1;
	    }
    
	    // 2. VOLTA PARA PARADO/GRITO AO FINAL DA ANIMAÇÃO
	    if (image_index >= image_number - 1)
	    {
	        // Reseta a invulnerabilidade
	        pode_tomar_dano = true; 
        
	        // Checa se o timer está pronto para o grito imediato (<= 0)
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

