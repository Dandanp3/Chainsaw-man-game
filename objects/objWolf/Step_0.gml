// Diminui o cooldown se estiver ativo
if (cooldown_ataque > 0)
{
    cooldown_ataque--;
}


var chao = place_meeting(x, y +1, objWall)

if (!chao)
{
	velv += GRAVIDADE * massa * global.vel_mult;
}




switch(estado)
{
	case "parado":
	{
	    velh = 0;
	    timer_estado++;
	    if (sprite_index != sprWolfIdle)
	    {
	        image_index = 0;    
	    }
	    sprite_index = sprWolfIdle
    
	    // Condição de troca
	    if (keyboard_check(ord("L")))
	    {   
	        estado = "dano";
	    }
    
	    // Indo para patrulha
	    if (irandom(timer_estado) > 300)
	    {
	        estado = choose("movendo", "parado", "movendo");
	        timer_estado = 0;
	    }
    
	    // -----------------------------------------------------------------
	    // LÓGICA DE ATAQUE COM COOLDOWN
	    // O inimigo SÓ checa a linha de ataque se o cooldown for 0.
	    if (cooldown_ataque <= 0) // <--- Checa o Cooldown AQUI
	    {
	        // Se o script retornar TRUE, o estado muda para "ataque"
	        scrAttackPlayerMelee(objPlayer, dist, xscale);
	    }
	    // -----------------------------------------------------------------
    
	    break;  
	}
	case "movendo":
	{
		
		timer_estado++;
		if (sprite_index != sprWolfRun)
		{
			image_index = 0;	
			velh = choose(2, -2);
			
		}
		sprite_index = sprWolfRun
		// Saindo do estado
		if (irandom(timer_estado) > 300)
		{
			estado = choose("parado", "movendo", "parado");
			timer_estado = 0;
		}
		if (cooldown_ataque <= 0) // <--- Checa o Cooldown AQUI
	    {
	        // Se o script retornar TRUE, o estado muda para "ataque"
	        scrAttackPlayerMelee(objPlayer, dist, xscale);
	    }
		
		break;
	}
	
	case "ataque":
	{
	    velh = 0;
    
	    // --- LÓGICA DE ENTRADA E SPRITE (CORRIGIDA) ---
	    // Checa se o sprite atual é o de ataque. Se não for, seta, reseta o index
	    // Use seu sprite de ataque real aqui (ex: sprWolfAttack)
	    if (sprite_index != sprWolfRun)
	    {
	        sprite_index = sprWolfRun; 
	        image_index = 0;
	        image_speed = 1; 
        
	        // Garante que o ataque pode criar dano na primeira vez
	        posso = true;
	        dano = noone;
	    }
	    // ---------------------------------------------
    
    
	    // Criando o dano
	    // Este bloco executa UMA VEZ por ataque (no frame 2)
	    if (image_index > 1 && dano == noone && image_index < 4 && posso)
	    {
	        dano =	instance_create_layer(x + sprite_width/2.8, y - (sprite_height-100)/35, layer, objDano);
	        dano.dano = ataque;
	        dano.pai = id;
	        posso = false; // Bloqueia a criação de mais dano/som neste ataque
	    }
    
	    // Destruir dano (Ao fim do alcance do ataque)
	    if (dano != noone && image_index >= 4)
	    {
	        instance_destroy(dano);
	        dano = noone;
	    }
    
	    // saindo do estado (Ao fim da animação)
	    if (image_index >= image_number-1)
	    {
	        // 1. ATIVA O COOLDOWN (cooldown_ataque passa a ser 30 - 0.5s)
	        cooldown_ataque = 30; 
        
	        // 2. Garante que o inimigo possa criar dano na PRÓXIMA vez que atacar
	        posso = true; 
        
	        // 3. MUDA O ESTADO
	        estado = "parado";
	    }
    
	    break;	
	}
	
	case "dano":
	{
		if (sprite_index != sprWolfHurt)
		{
			image_index = 0;
			
			//vida_atual--;
		}
		sprite_index = sprWolfHurt
		
		// Troca
		if (vida_atual > 0)
		{
			if (image_index > image_number-1)
			{
				estado = "parado";
			}
		}
		else
		{
			if (image_index >= 1)
			{
				estado = "morte";	
			}
		}
		break;	
	}
	
	case "morte":
	{
		velh = 0;
		if (sprite_index != sprWolfDeath)
		{
			image_index = 0;
		}
		
		sprite_index = sprWolfDeath	
		
		if (image_index > image_number-1)
		{
			image_speed = 0;
			image_alpha -= .01;
			
			if (image_alpha <= 0) instance_destroy();
		}
	}
}


