// Opcional: Rotacionar o sprite enquanto voa
image_angle += 2;

// Diminuir a opacidade para sumir aos poucos (Fade out)
image_alpha -= 0.03;

// Se ficar transparente, destrói para não pesar o jogo
if (image_alpha <= 0)
{
    instance_destroy();
}