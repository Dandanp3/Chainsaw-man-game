// Lógica para desaparecer suavemente (controlada pelo objKon ou tempo)
if (desaparecer)
{
    image_alpha -= 0.05; // Vai sumindo
    if (image_alpha <= 0) instance_destroy();
}