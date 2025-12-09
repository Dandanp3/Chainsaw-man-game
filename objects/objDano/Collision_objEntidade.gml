/*var outro_lista = ds_list_create();
var quantidade = instance_place_list(x, y, objEntidade, outro_lista, 0);
var outro;


// Adicionando entidades a lista de dano
for (var i = 0; i < quantidade; i++)
{
	//Checando o atual
	var atual = outro_lista[| i];
	
	if (object_get_parent(atual.object_index) != object_get_parent(pai.object_index))
	{
		// se puder da dano
		// Checando se pode dar dano
		// checar se ja esta na lista
		var pos = ds_list_find_index(aplicar_dano, atual);
		if (pos == -1)
		{
			//adicionando atual a lista de dano
			ds_list_add(aplicar_dano, atual)
		}
	}
}
// aplicando dano
var tam = ds_list_size(aplicar_dano);
for (var i = 0; i < tam; i++)
{
	outro = aplicar_dano[| i].id;
	if (other.vida_atual > 0)
	    {
	        other.estado = "dano";
	        other.vida_atual -= dano;
	    }
}
ds_list_destroy(aplicar_dano);
ds_list_destroy(outro_lista);
instance_destroy();








/* 
--------------------------------------------------
if (other.id != pai) 
{
	
	// Checando quem é o pai
	var papi = object_get_parent(other.object_index);
	if (papi != object_get_parent(pai.object_index))
	{
		
		
		
		if (other.vida_atual > 0)
	    {
	        other.estado = "dano";
	        other.vida_atual -= dano;
	        instance_destroy(); 
	    }
	}
    
}
*/