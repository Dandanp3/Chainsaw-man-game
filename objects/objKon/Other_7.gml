// Evento: Animation End

if (!travado)
{
    // 1. Trava a animação no último frame
    image_speed = 0;
    image_index = image_number - 1;
    
    // 2. Marca que travou para não rodar esse código de novo
    travado = true;
    
    // 3. Inicia o Alarme 0 para tocar daqui a 3 segundos
    alarm[0] = game_get_speed(gamespeed_fps) * 1;
}