// Evento Create do objTrap

timer_vida_max = 20 * 60;  // 20 segundos * 60 FPS = 1200 frames
timer_vida = timer_vida_max;

sprite_fechando = sprCloseTraps; // Substitua pelo seu sprite de fechando
sprite_aberto = sprTraps;      // Seu sprite original, se houver
dano_aplicado = false;           // Variável de controle: ainda não acertou

// Garante que a trap comece no estado "aberto" e com velocidade 1
sprite_index = sprite_aberto;
image_speed = 1;