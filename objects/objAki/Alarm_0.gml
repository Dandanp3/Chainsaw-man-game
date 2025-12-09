// Configurações de Posição
var _distancia_frente = 80; // Quanto mais alto o número, mais para frente ele vai
var _altura_subir = 40;     // Quanto mais alto o número, mais ele sobe (Y diminui)

// CÓDIGO DO OBAKI (Já está correto)

// Calcula a posição baseada na direção que o Aki está olhando
var _spawn_x = x + (_distancia_frente * image_xscale); // USA image_xscale do Aki
var _spawn_y = y - _altura_subir;

// Cria o objKon na nova posição ajustada
var _kon = instance_create_layer(_spawn_x, _spawn_y, layer, objKon);

// IMPORTANTE: Faz o Kon olhar para a mesma direção do Aki/Player
_kon.image_xscale = image_xscale; // Usa image_xscale do Aki para o Kon