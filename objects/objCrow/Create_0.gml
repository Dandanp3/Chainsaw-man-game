// Inherit the parent event
event_inherited();

max_vida = 30;
vida_atual = max_vida;
ataque = 2; // Dano do grito
dano_grito = noone;
pode_tomar_dano = true;

// Timer configurado para 20 segundos
timer_grito_max = 20 * 60; 
timer_grito = timer_grito_max; 

ataque_realizado = false;

// --- A MUDANÇA ESTÁ AQUI ---
// Começa JÁ gritando e invocando
estado = "grito"; 
// ---------------------------

pode_tomar_dano = true;
invulnerabilidade_timer = 0



// Seus Sprites
spr_parado = sprCrownIdle; // Troque pelo nome real
spr_ataque = sprCrowRoar; // Troque pelo nome real


// Evento: Create (em objBoss ou um controlador da Boss Room)

// 1. Para a música de fundo anterior (AttackOfKillerQueen)
// A função audio_stop_sound() não causa erro se o som não estiver tocando.
audio_stop_sound(AttackOfKillerQueen);

// 2. Toca a nova música (Megalovania) e guarda o ID da instância
// O ID é necessário para controlar o volume dela especificamente.
global.musica_boss_id = audio_play_sound(Megalovania, 1, true); 

// 3. Define o volume inicial (opcional, pode ser 1.0 por padrão)
// audio_sound_gain(id_da_instancia, volume_0_a_1, tempo_em_ms_para_fade)
audio_sound_gain(global.musica_boss_id, 1.0, 0);
