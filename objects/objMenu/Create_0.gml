// --- SETUP INICIAL ---

// 1. Tocar musica do menu em loop (se já não estiver tocando)
if (!audio_is_playing(IRIS_OUT)) {
    audio_play_sound(IRIS_OUT, 1, true);
}

// Variáveis de Seleção
sel = 0;
marg_val = 32;
marg_total = 32;
pag = 0;

// Variáveis de Transição
transicao_rodando = false;
alpha_transicao = 0;
velocidade_fade = 0.002; 
snd_chainsaw = noone; // Variável para guardar o ID do som da serra

#region MÉTODOS

// Desenha o menu
desenha_menu = function(_menu)
{
    // Fonte
    draw_set_font(fntMenu);

    // Alinhando texto
    define_align(0, 0);
    
    var _qtd = array_length(_menu);
    var _alt = display_get_gui_height();
    var _espaco_y = string_height("I") + 16;
    var _alt_menu = _espaco_y * _qtd;

    // Opções
    for (var i = 0; i < _qtd; i++)
    {
        var _cor = c_black, _marg_x = 0;
        var _texto = _menu[i][0];
    
        if (menus_sel[pag] == i)
        {
            _cor = c_yellow;
            _marg_x = marg_val;
        }
        draw_text_color(20 + _marg_x, (_alt/2) - _alt_menu/2 + (i * _espaco_y), _texto, _cor, _cor, _cor, _cor, 1);
    }

    draw_set_font(-1);
    define_align(-1, -1);
    
    // Desenhar o Fade da Transição
    if (transicao_rodando) {
        desenha_transicao();
    }
}

// Controlando menu
controla_menu = function(_menu)
{
    if (transicao_rodando) {
        gerencia_transicao(); 
        return; 
    }

    var _up, _down, _avanca, _recua;
    var _sel = menus_sel[pag];
    static _animar = false;
    
    _up     = keyboard_check_pressed(vk_up) or gamepad_button_check_pressed(global.gamepad_id, gp_padu)
    _down   = keyboard_check_pressed(vk_down) or gamepad_button_check_pressed(global.gamepad_id, gp_padd)
    _avanca = keyboard_check_released(vk_enter) or gamepad_button_check(global.gamepad_id, gp_face1)
    _recua  = keyboard_check_released(vk_space) or gamepad_button_check(global.gamepad_id, gp_face2)

    if (_up || _down)
    {
        // 2. Toca som de navegação
        audio_play_sound(MenuSec, 1, false);
        
        menus_sel[pag] += _down - _up;
        var _tam = array_length(_menu) - 1;
        menus_sel[pag] = clamp(menus_sel[pag], 0, _tam);
        _sel = menus_sel[pag];
        _animar = true;
    }
    
    if (_avanca)
    {
        switch(_menu[_sel][1])
        {
            case 0: _menu[sel][2](); break;
            case 1: pag = _menu[_sel][2]; break;
        }
    }
    
    if (_animar)
    {
        marg_val = marg_total * valor_ac(ac_margem, _up ^^ _down);
    }
}

inicia_jogo = function()
{
    if (!transicao_rodando) {
        transicao_rodando = true;
        
        // Para a música do menu
        audio_stop_sound(IRIS_OUT);
        
        // Toca o som do Chainsaw e guarda o ID na variável
        snd_chainsaw = audio_play_sound(ChainsawMenu, 1, false);
    }
}

// Método gerencia_transicao (dentro do objMenu ou controlador)

gerencia_transicao = function() {
    // Aumenta o alpha (escurece a tela)
    if (alpha_transicao < 1) {
        alpha_transicao += velocidade_fade;
        
        // Aplica o fade de áudio no ChainsawMenu
        if (audio_is_playing(snd_chainsaw)) {
            audio_sound_gain(snd_chainsaw, 1 - alpha_transicao, 0);
        }
        
    } else {
        // Garante que o ChainsawMenu parou
        audio_stop_sound(snd_chainsaw); 
        
        // -----------------------------------------------------------------
        // NOVO: INICIA A MÚSICA PADRÃO AQUI (AttackOfKillerQueen)
        // A música só começa quando a transição termina e a Room é trocada.
        // -----------------------------------------------------------------
        if (!audio_is_playing(AttackOfKillerQueen)) {
            audio_play_sound(AttackOfKillerQueen, 1, true);
        }
        
        room_goto(Room1_1); // Mude para a primeira Room do jogo
    }
}

desenha_transicao = function() {
    var _larg = display_get_gui_width();
    var _alt = display_get_gui_height();
    
    draw_set_color(c_black);
    draw_set_alpha(alpha_transicao);
    draw_rectangle(0, 0, _larg, _alt, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}

fecha_jogo = function()
{
    game_end(); 
}

#endregion

menu_principal = [
                    ["START", menu_acoes.roda_metodo, inicia_jogo],
                    ["CREDITS", menu_acoes.carrega_menu, menus_lista.opcoes],
                    ["EXIT", menu_acoes.roda_metodo, fecha_jogo]
                ];

menu_opcoes = [];
menus = [menu_principal, menu_opcoes];
menus_sel = array_create(array_length(menus), 0);