class Vikingo {
  const peso
  const inteligencia
  const velocidad // km/h
  const barbarosidad 

  const maximoHambre = 100
  const minimoHambre = 0
  
  var nivelHambre = 0 //0% = sin hambre, 100% hambre maxima

  
  var property item = ningunArma

  method inscribirseATorneo(torneo){
    torneo.agregarParticipante(self)
  }

  method bonusPorItem(){
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
  var competidores = #{}
  
  method iniciarFestival(){
    const postaDePesca = new Pesca()
    const postaDeCombate = new Combate()
    const postaDeCarrera = new Carrera(kilometrosDeCarrera= 10)


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

const ningunArma = new Arma(puntos = 0)
const hacha = new Arma(puntos = 30)
const masa = new Arma (puntos =100)

object itemComestible{
  const nutricion = 25

  method comerItem(vikingo){
    vikingo.disminuirHambre(nutricion)
  }
}

//VIKINGOS

const hipo = new Vikingo(peso= 50, inteligencia= 30, velocidad= 60, barbarosidad=50)
const astrid = new Vikingo(peso= 40, inteligencia= 40, velocidad= 70, barbarosidad=40, item= hacha)
const patan = new Vikingo(peso= 55, inteligencia= 10, velocidad= 30, barbarosidad=65, item= masa)

class Patapez inherits Vikingo{
  
  override method aumentarHambre(cantidad){
    super(cantidad*2)
  }

  override method puedeSoportarHambre(hambrePorAdicionar){
    return (nivelHambre + hambrePorAdicionar) < 50
  }
}
