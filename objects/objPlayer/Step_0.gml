// Checando transição
if (instance_exists(objTransicao)) exit;

var right, left, jump, attack, block, special;
var chao = place_meeting(x, y + 1, objWall)

right = keyboard_check(ord("D")) or gamepad_axis_value(global.gamepad_id, gp_axislh) > AXIS_DEADZONE;
left = keyboard_check(ord("A")) or gamepad_axis_value(global.gamepad_id, gp_axislh) < -AXIS_DEADZONE;
jump = keyboard_check_pressed(vk_space) or gamepad_button_check_pressed(global.gamepad_id, gp_face1);
attack = mouse_check_button(mb_left) or gamepad_button_check_pressed(global.gamepad_id, gp_face3);
block = keyboard_check(ord("F")) or gamepad_button_check(global.gamepad_id, gp_shoulderrb)
special = keyboard_check(ord("R")) or gamepad_button_check(global.gamepad_id, gp_shoulderlb)

if (special && ultimate >= 15 && estado != "ultimate")
{
    estado = "ultimate";
    velh = 0;
    image_index = 0;
    sprite_index = sprStance; 
    
    var _spawn_x = x + (50 * image_xscale);
    var _aki = instance_create_layer(_spawn_x, y - 2, layer, objAki);

    _aki.image_xscale = image_xscale;
}

if (ultimate >= 15) {
    ultimate_brilhando = true;
} else {
    ultimate_brilhando = false;
}
if (ultimate_brilhando) {
    // Aumenta o contador (velocidade do brilho)
    ultimate_brilho_timer += 0.1; 
    if (ultimate_brilho_timer >= 360) {
        ultimate_brilho_timer = 0;
    }
}

if (block) 
{
    // O Player só pode defender se não estiver atacando, tomando dano ou morrendo.
    if (estado != "ataque" && estado != "dano" && estado != "morte")
    {
        estado = "defendendo";
    }
}

// Movimentação

velh = (right - left) * max_velh * global.vel_mult;


// GRAVIDADE
if (!chao) 
{
	if (velv < max_velv * 2)
	{
		velv += GRAVIDADE * massa * global.vel_mult;
	}
}

// MachineState
switch(estado)
{
	
	// dentro do switch -> case "entrada"
	case "entrada":
    {
        velh = 0;
        sprite_index = sprIntro;

        // Toca o som apenas uma vez
        if (intro_snd_id == -1) {
            // Garante que o som comece com volume máximo (1) caso tenha sido alterado antes
            intro_snd_id = audio_play_sound(intro_snd, 10, false);
        }

        if (image_index >= image_number - 1)
        {
            image_index = image_number - 1;

            if (intro_snd_id != -1 && audio_is_playing(intro_snd_id)) 
            {
                audio_sound_gain(intro_snd_id, 0, 500);
            }
            intro_snd_id = -1; 

            estado = "parado";
            combo = 0;
        }

        break;
    }


	
	case "parado":
	{
		sprite_index = sprStance;
		
		// Ttroca
		// Movendo
		if (velh != 0)
		{
			estado = "movendo"	
		}
		else if (jump || velv != 0)
		{
		    audio_play_sound(Jump, 1, false); 
		    estado = "pulando";
		    velv = (-max_velv * jump);
		    image_index = 0;
		}
		else if (attack)
		{
			estado = "ataque";
			velh = 0;
			image_index = 0;
		}
		
		break;	
	}
	
	case "movendo":
	{
	    sprite_index = sprRun;

	    if (!audio_is_playing(Footsteps))
	    {
	        audio_play_sound(Footsteps, 1, true);
	    }
		if (abs(velh) < .1)
		{
		    estado = "parado";  
		    audio_stop_sound(Footsteps); 
		}

		else if (jump || velv != 0)
		{
		    audio_stop_sound(Footsteps); 
    
		    audio_play_sound(Jump, 1, false); 
    
		    estado = "pulando";
		    velv = (-max_velv * jump);
		    image_index = 0;
		}
		else if (attack)
		{
		    estado = "ataque";
		    velh = 0;
		    image_index = 0;
		    audio_stop_sound(Footsteps); // Parar passos
		}

		break;
	}
	
	case "pulando":
	{   
	    // Troca para o sprite de Caindo
	    if (velv > 0)
	    {
	        sprite_index = sprFall; 
	    }
	    // Troca para o sprite de Pulando
	    else
	    {
	        sprite_index = sprJump;
	        if (image_index >= image_number-1)
	        {
	            image_index = image_number-1;
	        }
        
	    }
    
	    // Troca de estado
		if (attack)
		{
			estado = "ataque aereo";	
		}
	
	    if (chao)
	    {
        
	        audio_play_sound(Fall, 1, false); // O 'false' garante que não fica em loop
	        estado = "parado"; 
	    }
    
	    break;  
		}
	
	case "ataque aereo":
	{
		if (sprite_index != sprAirKick)
		{
			sprite_index = sprAirKick;
			image_index = 0;
		}
		if (image_index >= 1 && dano == noone && posso)
	    {
	        dano = instance_create_layer(x + sprite_width/2 + velh * 2, y - sprite_height/11 + 30, layer, objDano); 
	        dano.dano = ataque;
	        dano.pai = id;
	        posso = false; 
	    }
		
		// Saindo
		if (image_index >= image_number - 1)
		{
			estado = "pulando"	
			posso = true;
	        if (dano)
	        {
	            instance_destroy(dano, false);
	            dano = noone;
	        }
		}
		if (chao)
		{
			estado = "parado"	
			posso = true;
	        if (dano)
	        {
	            instance_destroy(dano, false);
	            dano = noone;
	        }
		}
		
		break;
	}
	
	case "ataque":
	{
	    velh = 0;
    
	    // Define os sprites baseados no combo
	    if (combo == 0)
	    {
	        sprite_index = sprAtk1;
	    }
	    else if (combo == 1)
	    {
	        sprite_index = sprAtk2;
	    }
	    else if (combo == 2) 
	    {
	        sprite_index = sprAtk4; 
	    }

	    if (image_index >= 2 && dano == noone && posso)
	    {
	        dano = instance_create_layer(x + sprite_width/2, y - sprite_height/11, layer, objDano); 
	        dano.dano = ataque * ataque_mult;
	        dano.pai = id;
        
	        // Lógica dos Sons
	        if (combo == 0)
	        {
	            audio_play_sound(Combo1, 0.7, false);
	        }
	        else if (combo == 1)
	        {
	            audio_play_sound(Combo2, 0.7, false);
	        }
	        else if (combo == 2)
	        {
	            audio_play_sound(Combo3, 0.7, false);
	        }
        
	        posso = false; // Trava para não criar dano nem som de novo nesse golpe
	    }
    
	    // Sistema de Combo (Muda para o próximo ataque)
	    if (attack && combo < 2 && image_index >= image_number-3)
	    {
	        combo++; 
	        image_index = 0;
	        posso = true; // Libera o "posso" para o próximo som e dano tocarem
	        ataque_mult += .5;
	        if (dano)
	        {
	            instance_destroy(dano, false);
	            dano = noone;
	        }
	    }
	    if (image_index > image_number-1)
	    {
	        estado = "parado";
	        velh = 0;
	        combo = 0;
	        posso = true;
	        ataque_mult = 1;
	        if (dano)
	        {
	            instance_destroy(dano, false);
	            dano = noone;
	        }
	    }
    
	    break;
	}
	
	case "dano":
	{
		if (sprite_index != sprPlayerDano)
		{
			sprite_index = sprPlayerDano	
			image_index = 0;
			
			// Screeshake
			screenshake(5);
		}
		
		velh = 0;
		
		// checando morte
		if (vida_atual > 0)
		{
			if (image_index >= image_number - 1)
			{
				estado = "parado";	
				
			}
		}
		else
		{
			if (image_index > image_number - 1)
			{
				estado = "morte"	
			}
		}
		break;	
	}
	
	case "morte":
	{
		
		if (instance_exists(objGameController))
		{
			with(objGameController)
			{
				game_over = true;
			}
		}
		
		velh = 0;
		if (sprite_index != sprDeath)
		{
			image_index = 0;
			sprite_index = sprDeath;
		}
		
		// ficando parado
		if (image_index >= image_number - 1)
		{
			image_index = image_number-1
		}
		
		
		break;
	}
	
	case "defendendo":
	{
	    sprite_index = sprPlayerParry; // Use o sprite de defesa aqui
	    velh = 0; 
	    if (!block)
	    {
	        estado = "parado";
	    }

	    break;
	}
	
	case "ultimate":
	{
	    velh = 0;
    
	    break;
	}
	
	
	default:
	{
		estado = "parado"	
	}
}


if (keyboard_check(vk_enter) or gamepad_button_check_pressed(global.gamepad_id, gp_start)) game_restart();
