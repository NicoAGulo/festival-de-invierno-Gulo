import Jinete.*
class Vikingo {
  const property peso
  const property inteligencia
  const property velocidad // km/h
  const property barbarosidad 

  const maximoHambre = 100
  const minimoHambre = 0
  
  var property nivelHambre = minimoHambre //0% = sin hambre, 100% hambre maxima

  var property item

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
    nivelHambre = (nivelHambre - cantidad).max(minimoHambre)
  }

  method puedeSoportarHambre(hambrePorAdicionar){
    return (nivelHambre + hambrePorAdicionar) < 100
  }

  method afectarPorPosta(cantidad){
      self.aumentarHambre(cantidad)
  }

  method puedeMontarDragon(dragon){
    return  festival.esDragonDisponible(dragon) &&
            dragon.esVikingoQueCumpleRequisitos(self)
  }

  // method montarDragon(dragon){
  //   if(self.puedeMontarDragon(dragon)){
  //   }
  // }

  method aptitudParaPesca(){
    return self.peso()/2 + self.barbarosidad()*2
  }

  method aptitudParaCombate(){
    return self.barbarosidad() + self.bonusAdicional()
  }
  
  method aptitudParaCarrera(){
    return self.velocidad()
  }
}

object festival {
  var property competidores = #{}
  var property dragonesDisponibles = #{}
  const property postas= #{}

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
  var property jinetes = []

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

  method dragonesDisponiblesParaCompetidor(competidor){
    return festival.dragonesDisponibles().filter({dragon => competidor.puedeMontarDragon(dragon)})
  }

  method posiblesFormasDeJinetear(competidor){
    return self.dragonesDisponiblesParaCompetidor(competidor).map({d=> new Jinete(vikingo=competidor, dragon=d)})
  }

  method mejorOpcionComoJinete(competidor){
    return self.posiblesFormasDeJinetear(competidor).first()
  }

  method esMejorComoJineteQueSolo(jinete){
    return self.esMejorCompetidorQueOtro(jinete, jinete.vikingo())
  }

  method versionMasCompetidora(competidor){
    return if(self.esMejorComoJineteQueSolo(self.mejorOpcionComoJinete(competidor))){

    }
  }

  method reemplazarParticipantesPorJinetes(){
    participantes= participantes.map({p => })
  }

  method agregarParticipantesQuePuedenCompetir(){
    participantes = festival.competidores().filter({c => self.puedeParticipar(c)})
  }

  method iniciarPostaConDragones(competidores){
    participantes = competidores.filter({c => self.puedeParticipar(c)})
    jinetes= participantes.filter({p => self.esMejorComoJineteQueSolo(p)})
    participantes= participantes-jinetes



      // .sortedBy({c1, c2 => self.esMejorCompetidorQueOtro(c1, c2)})
    participantes.forEach({p => p.afectarPorPosta(self.hambreGeneradaAlparticipar())})
  }



}

class Pesca inherits Posta{
  override method hambreGeneradaAlparticipar(){
    return 5
  }

  override method atributoParaCompetir(participante){
    return participante.aptitudParaPesca()
  }

  override method atributoDeDragon(dragon){
    return dragon.peso()
  }
}

class Combate inherits Posta{
  override method hambreGeneradaAlparticipar(){
    return 10
  }

  override method atributoParaCompetir(participante){
    return participante.aptitudParaCombate()
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

  override method atributoParaCompetir(participante){
    return participante.aptitudParaCarrera()
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
object sistemaDeVuelo {
  method puntos(){
    return 0
  }
}

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

//punto 4: no debo utilizar el self.error() o debo hacerlo pero no donde haya un daño colateral(ej que sume puntos del dragon cuando no se pudo montar)?

