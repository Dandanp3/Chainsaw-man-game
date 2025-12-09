// 1. Trava a animação no último frame
image_speed = 0;
image_index = image_number - 1;

// 2. Garante que o som e o alarme só rodem uma vez
if (!tocou_som)
{
    // Toca o som do Ultimate que você tem (certifique-se que o nome 'soundUltimate' está correto)
    audio_play_sound(Ultimate, 1, false); 
    tocou_som = true;
    
    // 3. Define o alarme para criar o objKon 1.5 segundos depois
    // (Se seu jogo for 60FPS, 90 frames = 1.5s)
    alarm[0] = game_get_speed(gamespeed_fps) * 1.5; 
}