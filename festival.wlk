class Vikingo {
  const property peso
  const property inteligencia
  const property velocidad // km/h
  const property barbarosidad 

  const maximoHambre = 100
  const minimoHambre = 0
  
  var nivelHambre = 0 //0% = sin hambre, 100% hambre maxima

  
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
    nivelHambre = (nivelHambre + cantidad).max(minimoHambre)
  }

  method puedeSoportarHambre(hambrePorAdicionar){
    return (nivelHambre + hambrePorAdicionar) < 100
  }
}

object festival {
  var property competidores = #{}
  
  method iniciarTorneo(){

  }

  method agregarCompetidor(competidor){
    competidores.add(competidor)
  }
}

//POSTAS
class Posta{
  method hambreGeneradaAlparticipar()
  method atributoParaCompetir(vikingo)

  const participantes = #{}

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
}

class Pesca inherits Posta{
  override method hambreGeneradaAlparticipar(){
    return 5
  }

  override method atributoParaCompetir(vikingo){
    return vikingo.peso()/2 + vikingo.barbarosidad()*2
  }
}

class Combate inherits Posta{
  override method hambreGeneradaAlparticipar(){
    return 10
  }

  override method atributoParaCompetir(vikingo){
    return vikingo.barbarosidad() + vikingo.bonusAdicional()
  }
}

class Carrera inherits Posta{
  const kilometrosDeCarrera

  override method hambreGeneradaAlparticipar(){
    return kilometrosDeCarrera
  }

  override method atributoParaCompetir(vikingo){
    return vikingo.velocidad()
  }
}

//ITEMS

class Arma {
  const property puntos
}

object itemComestible{
  const nutricion = 25

  method puntos(){
    return 0
  }

  method comerItem(vikingo){
    vikingo.disminuirHambre(nutricion)
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
}
