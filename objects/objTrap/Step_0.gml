// Evento Step do objTrap

// --- Lógica de Animação (Travar no último frame se estiver aberta) ---
if (sprite_index == sprite_aberto)
{
    if (image_index >= image_number - 1)
    {
        image_speed = 0;
        image_index = image_number - 1;
    }
}
// -------------------------------------------------------------------


// --- Lógica de Colisão e Dano (APENAS se a trap estiver 'aberta' e ainda não deu dano) ---
if (!dano_aplicado)
{
    // --- TIMER DE VIDA (20 SEGUNDOS) ---
    if (timer_vida > 0)
    {
        timer_vida--;
    }
    else
    {
        // Se o timer zerou, a trap some
        instance_destroy();
        exit;
    }
    // -----------------------------------


    // Verifica a colisão SOMENTE com o objPlayer
    if (place_meeting(x, y, objPlayer))
    {
        // 1. Aplica o dano (Se o player não estiver invulnerável)
        if (instance_exists(objPlayer) && objPlayer.estado != "dano")
        {
			screenshake(10);
            objPlayer.vida_atual -= 1;
            objPlayer.estado = "dano";
        }
        
        // 2. Inicia o fechamento e trava o dano
        dano_aplicado = true;
        sprite_index = sprite_fechando;
        image_index = 0; // Começa a animação de fechamento
        image_speed = 1; 
    }
}
// -------------------------------------------------------------------


// --- Lógica de Destruição (APENAS se estiver fechando) ---
if (sprite_index == sprite_fechando)
{
    if (image_index >= image_number - 1)
    {
        instance_destroy();
    }
}