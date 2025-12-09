// 1. Criar uma lista temporária só para este frame
var lista_do_frame = ds_list_create();
var quantidade = instance_place_list(x, y, objEntidade, lista_do_frame, false);

if (quantidade > 0)
{
    for (var i = 0; i < quantidade; i++)
    {
        var atual = lista_do_frame[| i];
        
        // Verificações de segurança
        if (atual.id != pai) // Não acertar quem criou o ataque
        {
            var pos = ds_list_find_index(aplicar_dano, atual);
            
            // Se pos for -1, é um alvo novo!
            if (pos == -1)
            {
                // --- 1. VERIFICAÇÃO DE DEFESA/BLOQUEIO POR ESTADO ---
                if (atual.object_index == objPlayer && atual.estado == "defendendo")
                {
                    audio_play_sound(Block, 1, false);
                    continue; // Pula o resto do loop para este Player
                }
                // ----------------------------------------------------

                // --- CORREÇÃO DO ERRO AQUI ---
                // Precisamos criar a variável ANTES de usar
                var _pode_bater = true; 
                // -----------------------------

                // --- CHECAGEM DE INVULNERABILIDADE ---
                // Se a instância tem a variável de invulnerabilidade E ela é false (não pode tomar dano),
                if (variable_instance_exists(atual, "pode_tomar_dano") && atual.pode_tomar_dano == false)
                {
                    _pode_bater = false;
                }
                
                // Agora a variável _pode_bater existe, então o erro da linha 19 sumirá
                if (_pode_bater)
                {
                    // 1. Adiciona na lista de alvos já atingidos neste ataque
                    ds_list_add(aplicar_dano, atual);
                    
                    // 2. Aplica o dano
                    if (atual.vida_atual > 0)
                    {
                        atual.estado = "dano";
                        atual.vida_atual -= dano;
                        
                        // --- DESATIVA A INVULNERABILIDADE AO ACERTAR ---
                        if (variable_instance_exists(atual, "pode_tomar_dano"))
                        {
                            atual.pode_tomar_dano = false;    
                        }
                        
                        // --- LÓGICA DE ULTIMATE/CARGA ---
                        if (instance_exists(pai) && pai.object_index == objPlayer) 
                        {
                            if (pai.ultimate < 30) 
                            {
                                pai.ultimate += 1;
                            }
                        }
                        
                        // --- SOM E SHAKE ---
                        if (atual.object_index == objPlayer)    
                        {
                            audio_play_sound(Hit, 1, false);
                        }
                        
                        // SE FOR INIMIGO: TREME E SAI SANGUE
                        if (object_get_parent(atual.object_index) == objInimigo)
                        {
                            screenshake(7);

                            // --- EFEITO DE SANGUE ---
                            repeat(20) 
                            {
                                var _xx = atual.x + irandom_range(-10, 10);
                                var _yy = atual.y + irandom_range(-10, 10);
                                instance_create_layer(_xx, _yy, "Instances", objBlood);
                            }
                            // ------------------------
                        }
                    }
                }
            }
        }
    }
}

// Destruir a lista temporária deste frame
ds_list_destroy(lista_do_frame);