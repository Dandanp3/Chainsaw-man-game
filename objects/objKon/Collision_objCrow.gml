// Evento Colisão (objUltimate com objBoss)

// 1. Verifica se o Boss pode tomar dano E se nós JÁ NÃO demos o dano
if (other.pode_tomar_dano == true && ja_deu_dano == false)

{
    // Marca que o dano foi dado, para não repetir no próximo frame
    ja_deu_dano = true;

    // Aplica o dano
	screenshake(20)
    other.vida_atual -= 15;
    
    // Inicia a invulnerabilidade do Boss
    other.pode_tomar_dano = false;
    other.invulnerabilidade_timer = 15; 
    
    // Define o estado do Boss
    if (other.vida_atual > 0)
    {
        other.estado = "dano"; 
    }
    else
    {
        other.estado = "morte";
        other.image_index = 0;
    }
}

