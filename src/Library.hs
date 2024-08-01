module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero

type Ingrediente = String

data Combo = Combo {
    hamburguesa    :: [Ingrediente],
    bebida         :: Bebida, -- Hay 3 tamaños válidos para las bebidas
    acompanamiento :: String
} deriving (Show, Eq)

type Tamanio = Number

data Bebida = Bebida {
    tipoBebida   :: String,
    tamañoBebida :: Tamanio,
    light        :: Bool
} deriving (Show, Eq)
regular = 1
mediano = 2
grande = 3

caloriasDeIngredientes :: [(Ingrediente, Number)]
caloriasDeIngredientes = [("pan", 220),("carne",260),("queso",70),("panceta",90),("lechuga",5),("tomate",22),("huevo",50),("jamon",25)]

condimentos :: [Ingrediente]
condimentos = ["mayonesa","mostaza","ketchup"]

-- cuantas calorias tiene un ingredinete 
calorias :: Ingrediente -> Number
calorias ingrediente
    | ingrediente `elem` map fst caloriasDeIngredientes = caloriaAlimento ingrediente caloriasDeIngredientes
    | otherwise = 10

caloriaAlimento :: Ingrediente -> [(Ingrediente, Number)] -> Number
caloriaAlimento ingrediente = snd . head . filter ((== ingrediente) . fst) -- devuelve snd es decir la calorias del ingrediente

-- 2 
-- hamburguesaBomba es si tiene al menos uno que tenga más de 300 calorías, o si en total la hamburguesa supera más 1000 calorías
hamburguesaBomba :: Combo -> Bool
hamburguesaBomba combo =
    sum (map calorias (hamburguesa combo)) > 1000 || any ((> 300) . calorias) (hamburguesa combo)

esMortal :: Combo -> Bool
esMortal combo = hamburguesaBomba combo && (not . light . bebida) combo

-- 3
type Modificacion = Combo -> Combo

-- Funcion que usa A,B y C
cambiarCombo :: Combo -> [Modificacion] -> Combo
cambiarCombo = foldl (flip ($))

-- A. Cambiar acompañamiento
cambiarAcompanamientoPor :: String -> Modificacion
cambiarAcompanamientoPor nuevoAcompanamiento combo = combo { acompanamiento = nuevoAcompanamiento }

-- B. Agrandar bebida
sigTamañoBebida :: Tamanio -> Tamanio
sigTamañoBebida tamanioAnterior
    | tamanioAnterior == regular = mediano
    | tamanioAnterior == mediano = grande
    | otherwise                  = grande

cambiarTamañoSig :: Bebida -> Bebida
cambiarTamañoSig bebida = bebida { tamañoBebida = sigTamañoBebida (tamañoBebida bebida) }

agrandarBebida :: Modificacion
agrandarBebida combo = combo { bebida = cambiarTamañoSig (bebida combo) }

-- C. Quitar ingredientes de la hamburguesa
peroSin :: (Ingrediente -> Bool) -> Modificacion
peroSin restriccion combo = combo { hamburguesa = filter (not . restriccion) (hamburguesa combo) }

type Restriccion = Ingrediente -> Bool

esCondimento :: Restriccion
esCondimento = (`elem` condimentos)

masCaloricoQue :: Number -> Restriccion
masCaloricoQue cal = (> cal) . calorias

-- 4
-- realizar una consulta con la función definida anteriormente para alterar ese combo considerando que se quieren hacer las siguientes alteraciones: agrandar la bebida, cambiar el acompañamiento por "Ensalada César", que venga sin condimento, que venga sin ingredientes con más de 400 calorías y que venga sin queso.
-- > cambiarCombo comboDePrueba [agrandarBebida . cambiarAcompanamientoPor "Ensalada César" . peroSin esCondimento . peroSin (masCaloricoQue 400) . peroSin (== "queso")]

comboDePrueba :: Combo
comboDePrueba = Combo {
    hamburguesa = ["pan", "carne", "queso", "panceta", "lechuga", "tomate", "huevo", "jamon"],
    bebida = Bebida {
        tipoBebida = "gaseosa",
        tamañoBebida = regular,
        light = False
    },
    acompanamiento = "papas fritas"
}

-- 5 
aliviananCombo :: Combo -> [Modificacion] -> Bool
aliviananCombo combo modificaciones = esMortal combo && not (esMortal (cambiarCombo combo modificaciones))