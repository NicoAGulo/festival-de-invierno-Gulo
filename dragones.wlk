import festival.*

//DRAGONES
/*

MODELADO DE DRAGON
  Velocidad de vuelo de dragones: vel base - peso propio
  vel base normal 60km/h

  Furia nocturna: ve base normal *3. El daño que producen se indica para cada uno.
  Nadder mortifero: daño de 150. 
  gronckle: vel base/2. daño=peso*5



  req para montar dragon : dragon solo carga el 20% de su peso ergo aquellos vikingos que superen el 20% del peso del dragon NO PUEDEN MONTARLO

  si se puede montar un vikingo se le dice JINETE

  los dragones pueden tener otras restricciones: 
    que barbarosidad de un vikingo supere un minimo determinado
    que el vikingo tenga un item en particular: chimuelo es un furia nocturna que pide sistema de vuelo en item de vikingo para que sea su jinete
    PARA NADDER jinete que tenga menos int que nadder sino no es jinete


REFACTORIZACION DE VIKINGO/JINETE/DRAGON

    jinetes como competidores:
      jinete carga tanto kilos de pescado = diferencia e/ peso de vikingo con lo que carga el dragon
      jinete hace daño igual a la suma del daño del vikingo + daño de dragon
      jinete tiene tanta velocidad como= velocidad dragon - 1km/h por cada kg del vikingo

      los jinetes solo incrementan el 5% del hambre independientemente de la posta que se juegue


PUNTOS:
  -un vikingo puede montar un dragon si cumple con los requisitos de c/u de ellos

  -obtener jinete resultante e/ vikingo y dragon, resultando en error en caso de que no se pueda (NO DEBERIA HABER EFECTOS COLATERALES EN NINGUNO DE ELLOS)

  -a partir de un conjunto de dragones que un vikingo podria o no montar como le conviene participar en una posta (podria ser como jinete o por su cuenta)

  -debe ser posible que los participantes del torneo cuando se inscriben en una posta puedan elegir si participar por su cuenta o como jinete.
   en caso de que el vikingo se inscriba sin su dragon, el mismo pasa a disponibilidad para que lo elija otro vikingos.
   si un dragon participa de una posta, para el resto del torneo no puede volver a montarse porque quedan demasiado agotados.


*/

class Dragon {
    const velocidadBase = 60
    const peso

    var property requisitos = #{requisitoDeCarga} //requisitos predeterminados. puede tener mas requisitos al instanciar otros dragones (RequisitoDeBarbarosidad o RequisitoDeItem)

    method esVikingoQueCumpleRequisitos(vikingo){
        return requisitos.all({requisito => requisito.esDragonConVikingoValido(self, vikingo)})
    }

    method velocidadTotal(){
        return velocidadBase-peso
    }

    method daño()
}

class FuriaNocturna inherits Dragon{
    const daño

    override method velocidadTotal(){
        return super()*3
    }

    override method daño()= daño
}

class NadderMortifero inherits Dragon{
    const property inteligencia

    override method daño()= 150

    override method requisitos()= super() + #{requisitoDeNadder} 
}

class Gronckle inherits Dragon{
    override method daño()= peso*5
}

//REQUISITOS OBLIGATORIOS DE DRAGON

object requisitoDeCarga{
    method esDragonConVikingoValido(dragon, vikingo){
        return vikingo.peso()< dragon.peso()*0.2
    }
}

class RequisitoDeBarbarosidad{
    const barbarosidadMinima

    method esDragonConVikingoValido(dragon, vikingo){
        return vikingo.barbarosidad()>=barbarosidadMinima
    }
}

class RequisitoDeItem{
    const itemNecesario

    method esDragonConVikingoValido(dragon, vikingo){
        return vikingo.item()==itemNecesario
    }
}

object requisitoDeNadder {
    method esDragonConVikingoValido(dragon, vikingo){
        return dragon.inteligencia() >= vikingo.inteligencia()
    }
}
