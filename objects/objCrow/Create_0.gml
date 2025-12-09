event_inherited();

max_vida = 30;
vida_atual = max_vida;
ataque = 2; // Dano do grito
dano_grito = noone;
pode_tomar_dano = true;


timer_grito_max = 20 * 60; 
timer_grito = timer_grito_max; 

ataque_realizado = false;
estado = "grito"; 


pode_tomar_dano = true;
invulnerabilidade_timer = 0

spr_parado = sprCrownIdle; 
spr_ataque = sprCrowRoar; 

audio_stop_sound(AttackOfKillerQueen);

global.musica_boss_id = audio_play_sound(Megalovania, 1, true); 

audio_sound_gain(global.musica_boss_id, 1.0, 0);

