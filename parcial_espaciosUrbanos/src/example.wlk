class EspacioUrbano{
	var property valor = 0
	const property superficie = 51
	const property nombre = "sin nombre"
	var property tieneVallado = false
	var property trabajadorACargo = null
	
	method esGrande() = superficie > 50 && self.cumpleCondicion()
	
	method cumpleCondicion()
	
	method seCierraDeNoche() = tieneVallado
	
	method esHeavy() = trabajadorACargo.tieneTrabajoHeavy(self)
}

class Plaza inherits EspacioUrbano{
	const property espacioEsparcimiento = 0 //borrar si no se usa
	const property canchas
	
	override method cumpleCondicion() = canchas > 2
	
	method esLimpiable() = true
	
	method tieneMasDeTresEspacios() = false
	
}

class Plazoleta inherits EspacioUrbano{
	const property espacioSinCesped = 0 // borrar si no se usa
	const property rindeHomenajeA 
	
	override method cumpleCondicion() = rindeHomenajeA == "San Martin" and self.seCierraDeNoche()
	
	method esLimpiable() = false
	
	method tieneMasDeTresEspacios() = false
	
	
}
class Anfiteatro inherits EspacioUrbano{
	const property capacidad
	const property superficieEscenario
	
	override method cumpleCondicion() = capacidad > 500
	
	method esLimpiable() = self.esGrande() 
	
	method tieneMasDeTresEspacios() = false
	
	
}

class Multiespacio inherits EspacioUrbano{
	var espacios = #{}
	
	override method cumpleCondicion() = espacios.all{esp => esp.cumpleCondicion()}
	
	method tieneMasDeTresEspacios() = espacios.size() > 3
	
	method esLimpiable() = false
}

object salarioDelTrabajador{
	var valorPorHora = 100
	
	method cambiar(cantidad){
		valorPorHora = cantidad
	}
	
	method valorPorHora() = valorPorHora
}

class Trabajador{
	var profesion
	var property ganancias = 0
	var property costo = salarioDelTrabajador.valorPorHora()
	var property trabajosRealizados = #{} 

	
	method puedeRealizarTarea(espacioUrbano) = profesion.puedeRealizarTarea(espacioUrbano)
	
	method realizarTrabajo(espacioUrbano) {
		if (!self.puedeRealizarTarea(espacioUrbano)){
			self.error("El trabajo pretendido no es el adecuado para la profesion")
		}
		profesion.realizarTrabajo(espacioUrbano)
		
		self.agregarATrabajoRealizado(espacioUrbano)
		}
	
	method agregarATrabajoRealizado(trabajoTerminado){
		trabajosRealizados.add(trabajoTerminado)
		trabajosRealizados.add(self.duracionDelTrabajo(trabajoTerminado))
		trabajosRealizados.add(self.manoDeObra(trabajoTerminado))
		trabajosRealizados.add(new Date())
		ganancias = ganancias + self.manoDeObra(trabajoTerminado)
	}
			
	method duracionDelTrabajo(espacioUrbano)= profesion.duracionDelTrabajo(espacioUrbano)
			
	method manoDeObra(espacioUrbano) = profesion.costoDeManoObra(self,espacioUrbano)
		
	method tieneTrabajoHeavy(espacioUrbano) = profesion.condicionHeavy(self,espacioUrbano)
	
	
}

object cerrajero{
	var trabajador
		
	method puedeRealizarTarea(espacioUrbano) = !espacioUrbano.tieneVallado()
	
	method realizarTrabajo(espacioUrbano) {
		espacioUrbano.tieneVallado(true)
	}
	
	method duracionDelTrabajo(espacioUrbano) = if (espacioUrbano.esGrande()) 5 else 3 	
	
	method costoDeManoObra(empleado,espacioUrbano) = empleado.costo()*self.duracionDelTrabajo(espacioUrbano)
	
	method condicionHeavy(empleado,espacioUrbano) = self.duracionDelTrabajo(espacioUrbano) > 5 || self.costoDeManoObra(empleado,espacioUrbano) > 10000
	
}


object jardinero{
//	var trabajador
	
	method puedeRealizarTarea(espacioUrbano) = espacioUrbano.canchas() == 0 || espacioUrbano.tieneMasDeTresEspacios()
	
	method realizarTrabajo(espacioUrbano) {
		espacioUrbano.valor(espacioUrbano.valor()*1.10)
	}
	
	method duracionDelTrabajo(espacioUrbano) = espacioUrbano.superficie()*0.10
	
	method costoDeManoObra(empleado,espacioUrbano) = 2500
	
	method condicionHeavy(empleado,espacioUrbano) =  empleado.manoDeObra(espacioUrbano) > 10000
}


object encargado{
	
	method puedeRealizarTarea(espacioUrbano) = espacioUrbano.esLimpiable()
	
	method realizarTrabajo(espacioUrbano){
		espacioUrbano.valor(espacioUrbano.valor() + 5000)
		}
	method duracionDelTrabajo(espacioUrbano) = 8
	
	method costoDeManoObra(empleado,espacioUrbano) = empleado.costo()*self.duracionDelTrabajo(espacioUrbano) >10000
	
	method condicionHeavy(empleado,espacioUrbano) =  empleado.manoDeObra(espacioUrbano) > 100000
	
	
}

object espaciosHeavys{
	var espaciosVerdes = #{}
	
	method sonEspaciosDeUsoIntesivo()= espaciosVerdes.count{esp => esp.esHeavy()}
}