# ¿Y dónde está mi hamburguesa?

Queremos hacer un sistema para gestionar el delivery de comida rápida. Principalmente nos interesa modelar los combos que vende para tomar pedidos, pero tenemos que hacerlo lo suficientemente flexible para que se ajuste a los gustos de los clientes. Se tiene algunos combos prearmados como punto de partida, pero luego se pueden hacer modificaciones como cambiar el acompañamiento por otro y quitarle ingredientes a la hamburguesa, entre otras cosas que tal vez tengamos que soportar a futuro.

Los datos del programa están modelados de la siguiente forma:

```haskell
type Ingrediente = String

data Combo = Combo {
    hamburguesa    :: [Ingrediente],
    bebida         :: Bebida, -- Hay 3 tamaños válidos para las bebidas
    acompanamiento :: String    
} deriving (Show, Eq)                              

type Tamanio = Number

data Bebida = Bebida {
    tipoBebida   :: String,
    tamañoBebida :: Tamanio, -- regular = 1, mediano = 2, grande = 3
    light        :: Bool
} deriving (Show, Eq)                
                                 
```
Además disponemos de la siguiente constante que nos indica cuántas calorías tienen los distintos ingredientes:

``
caloriasDeIngredientes = [("pan", 220),("carne",260),("queso",70),("panceta",90),("lechuga",5),("tomate",22),("huevo",50),("jamon",25)]
``

Y también sabemos cuáles son los condimentos que se usan en la preparación de hamburguesas:
``condimentos = ["mayonesa","mostaza","ketchup"]``

Se pide desarrollar las siguientes funciones poniendo en práctica orden superior, aplicación parcial y composición de funciones cuando sea conveniente. Explicar el tipo de todas las funciones desarrolladas.

**1.** Queremos saber cuántas calorías tiene un ingrediente, esto puede obtenerse a partir de la información nutricional, a menos que sea un condimento, en cuyo caso se asume que las calorías son 10.
```haskell
> calorias "Panceta"
541
> calorias "Mostaza"
10
```
**2.** Se quiere saber si un combo **esMortal**. Esto se cumple cuando la bebida no es dietética y la hamburguesa es una bomba (si tiene al menos uno que tenga más de 300 calorías, o si en total la hamburguesa supera más 1000 calorías.)

**3.** Definir una función que permita obtener a partir de un combo otro combo resultante de aplicar una serie de modificaciones. Las alteraciones pueden ser las siguientes:
- **A. cambiarAcompanamientoPor** retorna el combo de otro acompañamiento elegido por el cliente
- **B. agrandarBebida**: retorna el combo agrandado la bebida al tamaño siguiente (teniendo en cuenta que el max es el tamaño grnade, no importa cuanto s ele trate de seguir agrandando)
- **C. peroSin**: retorna el combo de modo que su haburguesa no incluya ingredientes que cumplan con una determianda restriccion. En principio nos interersa las sigueintes restricciones, pero podrias haber:
    
    *i.* **esCondimento**: un ingrediente cumple esta restricción si es igual a alguno de los condimentos conocidos.
    
    *ii.* **masCaloricoQue**: se cumple esta restricción si las calorías del ingrediente superan un valor dado.

**4.** Asumiendo que se tiene una constante ``comboDePrueba :: Combo``, realizar una consulta con la función definida anteriormente para alterar ese combo considerando que se quieren hacer las siguientes alteraciones: agrandar la bebida, cambiar el acompañamiento por "Ensalada César", que venga sin condimento, que venga sin ingredientes con más de 400 calorías y que venga sin queso.

**5.** Saber si un conjunto de alteraciones **alivianan** un combo, que será cierto si el combo recibido es mortal, pero luego de aplicar las alteraciones indicadas no lo es.
