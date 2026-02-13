import dragones.*

class Vikingo {
  const property peso
  const property inteligencia
  const property velocidad // km/h
  const property barbarosidad 

  const maximoHambre = 100
  const minimoHambre = 0
  
  var property nivelHambre = minimoHambre //0% = sin hambre, 100% hambre maxima

  var property item
  var montura = null

  var property modoDeParticipacion = aPie //state


  method inscribirseATorneo(torneo){
    torneo.agregarCompetidor(self)
  }

  method bonusAdicional(){
    return item.puntos()
  }

  method aumentarHambre(cantidad){
    nivelHambre = (nivelHambre + cantidad).min(maximoHambre)
  }

  method disminuirHambre(cantidad){
    nivelHambre = (nivelHambre + cantidad).max(minimoHambre)
  }

  method puedeSoportarHambre(hambrePorAdicionar){
    return (nivelHambre + hambrePorAdicionar) < 100
  }

  method afectarPorPosta(cantidad){
    if (self.esJinete()){
      self.aumentarHambre(5)
      self.desmontarDragon(montura)
    } else {
      self.aumentarHambre(cantidad)
    }
  }

  method puedeMontarDragon(dragon){
    return  festival.esDragonDisponible(dragon) &&
            dragon.esVikingoQueCumpleRequisitos(self)
  }

  method montarDragon(dragon){
    if(self.puedeMontarDragon(dragon)){
      montura=dragon
      modoDeParticipacion=aDragon
      festival.sacarDisponibilidadDeDragon(dragon)
    }
  }

  method desmontarDragon(dragon){
    montura=null
    modoDeParticipacion= aPie
  }

  method aptitudParaPesca(){
        return modoDeParticipacion.cargaDePescados(self, montura)
    }

    method aptitudParaCombate(){
        return modoDeParticipacion.poderDeDaño(self, montura)
    }

    method aptitudParaCarrera(){
        return modoDeParticipacion.velocidadMaxima(self, montura)
    }

    method esJinete(){
      return modoDeParticipacion!=aPie
    }
}

object festival {
  var property competidores = #{}
  var property dragonesDisponibles = #{}
  const postas= #{}

  method agregarCompetidor(competidor){
    competidores.add(competidor)
  }

  method iniciarFestival(){
    postas.forEach({posta => posta.iniciarPosta(competidores)})
  }

  method agregarPosta(posta){
    postas.add(posta)
  }

  method esDragonDisponible(dragon){
    return dragonesDisponibles.contains(dragon)
  }

  method sacarDisponibilidadDeDragon(dragon){
    dragonesDisponibles.remove(dragon)
  }
}

//POSTAS
class Posta{
  method hambreGeneradaAlparticipar()
  method atributoParaCompetir(vikingo)
  method atributoDeDragon(dragon)

  var property participantes = []

  method puedeParticipar(alguien){
    return alguien.puedeSoportarHambre(self.hambreGeneradaAlparticipar())
  }

  method agregarParticipante(alguien){
    if (self.puedeParticipar(alguien)){
      participantes.add(alguien)
    }
  }

  method esMejorCompetidorQueOtro(competidor, otro){
    return self.atributoParaCompetir(competidor) > self.atributoParaCompetir(otro) //A mayor nivel de atributo, mejor competidor.
  }

  method iniciarPosta(competidores){
    participantes = competidores
      .filter({c => self.puedeParticipar(c)})
      .sortedBy({c1, c2 => self.esMejorCompetidorQueOtro(c1, c2)})

    participantes.forEach({p => p.afectarPorPosta(self.hambreGeneradaAlparticipar())})
  }

  method mejorOpcionParaCompetirEnPosta(competidor){
    festival.dragonesDisponibles()
      .filter({dragon => competidor.puedeMontarDragon(dragon)})
      .sortedBy({d1, d2 => self.esMejorDragonQueOtroParaPosta(d1, d2)})
      .first()
  }

  method esMejorDragonQueOtroParaPosta(dragon, otroDragon){
    return self.atributoDeDragon(dragon) > self.atributoDeDragon(otroDragon)
  }
}

class Pesca inherits Posta{
  override method hambreGeneradaAlparticipar(){
    return 5
  }

  override method atributoParaCompetir(vikingo){
    return vikingo.aptitudParaPesca()
  }

  override method atributoDeDragon(dragon){
    return dragon.peso()
  }
}

class Combate inherits Posta{
  override method hambreGeneradaAlparticipar(){
    return 10
  }

  override method atributoParaCompetir(vikingo){
    return vikingo.aptitudParaCombate()
  }

  override method atributoDeDragon(dragon){
    return dragon.daño()
  }

}

class Carrera inherits Posta{
  const kilometrosDeCarrera

  override method hambreGeneradaAlparticipar(){
    return kilometrosDeCarrera
  }

  override method atributoParaCompetir(vikingo){
    return vikingo.aptitudParaCarrera()
  }

  override method atributoDeDragon(dragon){
    return dragon.velocidadTotal()
  }
}

//ITEMS

class Arma {
  const property puntos
}

object itemComestible{
  const nutricion = 10

  method puntos(){
    return 0
  }

  method comerItem(vikingo){
    vikingo.disminuirHambre(nutricion)
  }
}
object sistemaDeVuelo {}

//VIKINGO DISTINTO

class Patapez inherits Vikingo{
  
  override method aumentarHambre(cantidad){
    super(cantidad*2)
  }

  override method puedeSoportarHambre(hambrePorAdicionar){
    return (nivelHambre + hambrePorAdicionar) < 50
  }

  override method afectarPorPosta(cantidad){
    super(cantidad)
    item.comerItem(self)
  }
}

//ESTADOS DE VIKINGO

object aPie { //cambiar nombre a normal?
  method cargaDePescados(vikingo, dragon){
    return vikingo.peso()/2 + vikingo.barbarosidad()*2
  }

  method poderDeDaño(vikingo, dragon){
    return vikingo.barbarosidad() + vikingo.bonusAdicional()
  }
  
  method velocidadMaxima(vikingo, dragon){
    return vikingo.velocidad()
  }
}

object aDragon { //Cambiar nombre a jinete?
  method cargaDePescados(vikingo, dragon){
    return (dragon.peso()*0.2 - vikingo.peso()).abs() //Evitando numeros negativos
  }
  
  method poderDeDaño(vikingo, dragon){
    return vikingo.barbarosidad() + vikingo.bonusAdicional() + dragon.daño()
  }

  method velocidadMaxima(vikingo, dragon){
    return dragon.velocidadTotal()-vikingo.peso()
  }
}

//punto 4: no debo utilizar el self.error() o debo hacerlo pero no donde haya un daño colateral(ej que sume puntos del dragon cuando no se pudo montar)?

