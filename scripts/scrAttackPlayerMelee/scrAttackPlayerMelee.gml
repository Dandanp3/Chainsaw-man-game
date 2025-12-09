function scrAttackPlayerMelee(objPlayer, dist, xscale)
{
    // Linha de ataque
    var x1 = x;
    var y1 = y - sprite_height / 15;
    var x2 = x + (dist * xscale);
    var y2 = y1;

    // Verifica se o player está no alcance
    var player = collision_line(
        x1, y1,
        x2, y2,
        objPlayer,
        false,
        true
    );

    // Se acertou o player
    if (player)
    {
        estado = "ataque";
        return true;
    }

    return false;
}
