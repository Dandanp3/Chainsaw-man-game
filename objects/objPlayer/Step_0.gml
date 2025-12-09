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
    
    // 1. Usa o image_xscale do player para calcular o X de spawn:
    // Se image_xscale = 1 (Direita), (50 * 1) = +50
    // Se image_xscale = -1 (Esquerda), (50 * -1) = -50
    var _spawn_x = x + (50 * image_xscale);
    
    // 2. Cria o objAki e, o mais importante, PASSAMOS A DIREÇÃO PARA ELE.
    var _aki = instance_create_layer(_spawn_x, y - 2, layer, objAki);
    
    // 3. Garante que o objAki está olhando para a direção correta:
    _aki.image_xscale = image_xscale; 
    // É ESSENCIAL que o objAki tenha o image_xscale do player.
}

if (ultimate >= 15) {
    ultimate_brilhando = true;
} else {
    ultimate_brilhando = false;
}

// 2. Se estiver brilhando, atualiza o timer
if (ultimate_brilhando) {
    // Aumenta o contador (velocidade do brilho)
    ultimate_brilho_timer += 0.1; 
    
    // Mantém o timer dentro de um ciclo
    if (ultimate_brilho_timer >= 360) {
        ultimate_brilho_timer = 0;
    }
}

if (block) // Se a tecla 'F' estiver sendo pressionada
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

        // Termino da animação
        if (image_index >= image_number - 1)
        {
            image_index = image_number - 1;

            // --- AQUI ESTÁ A MUDANÇA ---
            if (intro_snd_id != -1 && audio_is_playing(intro_snd_id)) 
            {
                // Em vez de parar na hora, mandamos o volume ir para 0 em 500ms
                // Parametros: (ID do som, Volume Alvo, Tempo em ms)
                audio_sound_gain(intro_snd_id, 0, 500);
            }
            // ---------------------------

            // Limpamos o ID para não perder a referência, 
            // mas o GameMaker continuará o fade no background até o som acabar ou chegar a 0.
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
		    // --- LÓGICA DO SOM DE PULO AQUI ---
		    audio_play_sound(Jump, 1, false); 
		    // O 'false' garante que toca UMA VEZ e não fica em loop
    
		    // Seu código original
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
    
	    // --- LÓGICA DO SOM ---
	    // Se o som NÃO (!) estiver tocando, dá o play
	    // O 'true' no final significa que ele vai ficar em loop (repetindo)
	    if (!audio_is_playing(Footsteps))
	    {
	        audio_play_sound(Footsteps, 1, true);
	    }
	    // ---------------------

	    // Troca de estado
		// Parado
		if (abs(velh) < .1)
		{
		    estado = "parado";  
		    audio_stop_sound(Footsteps); // Parar passos
		}

		// Pulo
		else if (jump || velv != 0)
		{
		    // Parar o som de passos antes de pular
		    audio_stop_sound(Footsteps); 
    
		    // Tocar o som de pulo UMA VEZ
		    audio_play_sound(Jump, 1, false); 
    
		    // Seu código original
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
        
	        audio_play_sound(Fall, 1, false); // O 'false' garante que não fica em loo
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
    
	    // --- AQUI É A MUDANÇA ---
	    // Criando obj Dano e Tocando o Som
	    // Esse bloco roda apenas UMA vez por ataque (no frame 2), perfeito para o som
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
    
	    // Fim do ataque
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
		
		// Parado ao tomar hit
		velh = 0;
		
		//Saindo
		
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
	    velh = 0; // O Player não pode se mover enquanto defende
    
	    // Se a tecla de defesa (F) for solta, volta para o estado parado
	    if (!block)
	    {
	        estado = "parado";
	    }

	    break;
	}
	
	case "ultimate":
	{
	    // O player fica travado. 
	    // Quem vai tirar o player desse estado será o objKon quando terminar tudo.
	    velh = 0;
    
	    // Opcional: Se tiver animação de 'castando' magia, controla aqui
	    break;
	}
	
	
	default:
	{
		estado = "parado"	
	}
}

if (keyboard_check(vk_enter) or gamepad_button_check_pressed(global.gamepad_id, gp_start)) game_restart();