if (alvo == noone) exit;

//seguindo alvo

x = lerp(x, alvo.x, .1);
y = lerp(y, alvo.y, .1);

// Pega a posição real do canto da câmera (não o centro do objeto)
var _cam_x = camera_get_view_x(view_camera[0]);
var _cam_y = camera_get_view_y(view_camera[0]);

// Aplica na layer "Background"
// Certifique-se que o nome "Background" é idêntico ao da sua Room (maiúsculas importam)
layer_x("Background", _cam_x); 
layer_y("Background", _cam_y);