if (fade_in)
{
    // Aumenta o alpha rapidamente. 0.2 faz com que ele apareça em 5 frames (se 1/0.2 = 5)
    image_alpha += 0.2; 
    
    if (image_alpha >= 1)
    {
        image_alpha = 1; // Garante que ele chegue em 100%
        fade_in = false; // Desliga o Fade-In para não rodar mais
    }
}


if (desaparecer)
{
    image_alpha -= 0.02; // Some devagar
    
    // Quando estiver totalmente transparente, encerra tudo
    if (image_alpha <= 0)
    {
        // 1. Zera a ultimate do Player
        if (instance_exists(objPlayer))
        {
            objPlayer.ultimate = 0;
            objPlayer.estado = "parado"; // Libera o player
        }
        
        // 2. Destroi o Kon
        instance_destroy();
    }
}