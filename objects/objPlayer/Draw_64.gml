// --- CONFIGURAÇÕES DE LAYOUT 
var _margem_x = 10;     
var _margem_y = 60;    
var _altura_conteudo = 25; 
var _grossura_borda = 4;   
var _altura_total = _altura_conteudo + (_grossura_borda * 2);

// --- TAMANHOS E POSIÇÕES 
var _largura_hp = 300;     
var _largura_ultimate = 200; 

var _x1 = _margem_x;
var _y_hp = _margem_y;
// Barras Coladas
var _y_ultimate = _y_hp + _altura_total; 

// --- Cores e Valores ---
var _cor_borda = c_black; 
var _cor_fundo_vazio = c_black;    
var _max_hp = vida_max;
var _max_ultimate = 15;


// ## BARRA DE HP (VIDA)


var _valor_hp_porcentagem = (vida_atual / _max_hp) * 100;
var _cor_cheia_hp = c_red; 
if (_valor_hp_porcentagem < 25) _cor_cheia_hp = c_maroon;

draw_set_color(_cor_borda);
draw_rectangle(_x1, _y_hp, _x1 + _largura_hp, _y_hp + _altura_total, false);
draw_set_color(c_white); // Reset da cor de desenho

var _x1_inner = _x1 + _grossura_borda;
var _y1_inner = _y_hp + _grossura_borda;
var _x2_inner = _x1 + _largura_hp - _grossura_borda;
var _y2_inner = _y_hp + _altura_total - _grossura_borda;

// Usamos showborder = false para evitar o conflito e não ter borda duplicada
draw_healthbar(_x1_inner, _y1_inner, _x2_inner, _y2_inner, 
               _valor_hp_porcentagem, 
               _cor_fundo_vazio,     
               _cor_cheia_hp,  
               _cor_cheia_hp,  
               0,              
               true,           
               false);         


// ## BARRA DE ULTIMATE

var _cor_ultimate_base = c_purple; 
var _cor_ultimate = _cor_ultimate_base;


if (ultimate_brilhando) {
   
    var _brilho_pulsar = 0.5 + 0.5 * sin(ultimate_brilho_timer);
    
    
    var _h = color_get_hue(_cor_ultimate_base);
    var _s = color_get_saturation(_cor_ultimate_base);
   
    var _v = 0.5 + (0.5 * _brilho_pulsar); 
    
    // Cria a nova cor pulsante
    _cor_ultimate = make_colour_hsv(_h, _s, _v * 255); 
}


var _valor_ultimate_porcentagem = (ultimate / _max_ultimate) * 100;


draw_set_color(_cor_borda);
draw_rectangle(_x1, _y_ultimate, _x1 + _largura_ultimate, _y_ultimate + _altura_total, false);
draw_set_color(c_white); // Reset da cor de desenho

var _x1_inner_ult = _x1 + _grossura_borda;
var _y1_inner_ult = _y_ultimate + _grossura_borda;
var _x2_inner_ult = _x1 + _largura_ultimate - _grossura_borda;
var _y2_inner_ult = _y_ultimate + _altura_total - _grossura_borda;


draw_healthbar(_x1_inner_ult, _y1_inner_ult, _x2_inner_ult, _y2_inner_ult, 
               _valor_ultimate_porcentagem, 
               _cor_fundo_vazio,       
               _cor_ultimate,    
               _cor_ultimate,    
               0,                
               true,             
               false);           // showborder: DESATIVADO