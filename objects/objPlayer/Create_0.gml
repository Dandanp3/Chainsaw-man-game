// Inherit the parent event
randomise();


var cam = instance_create_layer(x, y, layer, objCamera);
cam.alvo = id;


event_inherited();

vida_max = 30;
vida_atual = vida_max;

max_velh = 4;
max_velv = 8;

mostra_estado = false;

combo = 0;

estado = "entrada"

dano = noone;
ataque = 1;
posso = true
ataque_mult = 1;
block = false;

ultimate = 15;
// SOUNDS
intro_snd_id = -1;

ultimate_brilho_timer = 0; 
ultimate_brilhando = false;