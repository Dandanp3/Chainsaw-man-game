// Define uma direção aleatória (vai voar para qualquer lado)
direction = random(360);

// Define uma velocidade aleatória (alguns rápidos, outros lentos)
speed = random_range(2, 6);

// Adiciona gravidade para eles caírem
gravity = 0.3;

// Tamanho variado para dar textura
var tamanho = random_range(0.5, 1.2);
image_xscale = tamanho;
image_yscale = tamanho;
