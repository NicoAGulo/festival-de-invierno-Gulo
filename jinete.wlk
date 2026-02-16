import festival.*
import dragones.Dragon

class Jinete{
    const property vikingo
    const property dragon

    method aptitudParaPesca(){
        return (dragon.peso()*0.2 - vikingo.peso()).abs() //Evitando numeros negativos
    }

    method aptitudParaCombate(){
        return vikingo.barbarosidad() + vikingo.bonusAdicional() + dragon.daño()
    }

    method aptitudParaCarrera(){
        return dragon.velocidadTotal()-vikingo.peso()
    }

    method afectarPorPosta(cantidad){
        vikingo.aumentarHambre(5)
        festival.sacarDisponibilidadDeDragon(dragon)
    }
}