class Producto {
	var porcentajeDeDescuento //Podríamos usar un porcentaje o un factor. Esto va a impactar en la forma de calcular el precio.
	
	/*
	 * Otra opción es modelar el descuento mediante el patrón "Null Object".
	 * Esto implica tener un TipoDescuento y dos WKO (NoDescuento y Descuento), y delegarles la responsabilidad.
	 * https://en.wikipedia.org/wiki/Null_object_pattern#Motivation
	 */
	
	method precioBruto()
	
	//Punto 1
	method precio() = self.precioBruto() * (100 - porcentajeDeDescuento) / 100
	
	method tienePromo() = porcentajeDeDescuento > 0
	
	method dineroAhorrado() = self.precioBruto() - self.precio()
	
}

class Indumentaria inherits Producto {
	const talle
	const factorConversion
	
	constructor(_talle, _factorConversion) {
		talle = _talle
		factorConversion = _factorConversion
	}
	
	override method precioBruto() = talle * factorConversion
}

class Electronico inherits Producto {
	const precioBase
	
	constructor(_precioBase) {
		precioBase = _precioBase
	}
	
	override method precioBruto() = 15 * electronico.factorConversion() + precioBase
}

object electronico {
	var property factorConversion	
}

class Decoracion inherits Producto {
	
	const materiales
	const peso
	const alto
	const ancho
	
	constructor(_materiales, _peso, _alto, _ancho){
		materiales = _materiales
		peso = _peso
		alto = _alto
		ancho = _ancho
	}
	
	override method precioBruto() = peso * alto * ancho + self.precioMateriales()
	
	method precioMateriales() = materiales.sum({material => material.precio()})
}

class Venta {
	
	const fecha
	const productos
	const lugar
	
	constructor(_fecha, _productos, _lugar) {
		fecha = _fecha
		productos = _productos
		lugar = _lugar
	}
	
	//Punto 2
	method monto() = productos.sum({ producto => producto.precio() })
	//Punto 3
	method tienePromo() = productos.any({ producto => producto.tienePromo() })
	
	method dineroAhorrado() = productos.sum({ producto => producto.dineroAhorrado() })
	
	method realizadaEnFecha(_fecha) = _fecha == fecha
	method realizadaEnLugar(_lugar) = _lugar == lugar
	
}

class Establecimiento { 
	method cantidadVentas(lugar)
	method dineroMovido()
	method tieneSoloVentasTacanias(lugar)
}

class Local inherits Establecimiento {
	
	const ventas = []
	method cantidadVentasConPromo() = ventas.count({ venta => venta.tienePromo() })
	
	//Punto 4a
	method ventasEnFecha(fecha) = ventas.filter({ venta => venta.realizadaEnFecha(fecha) })	
	
	//Punto 4b
	method dineroAhorradoEnFecha(fecha) = self.ventasEnFecha(fecha).sum({ venta => venta.dineroAhorrado()})
	
	//Punto 5a
	override method cantidadVentas(lugar) = ventas.count({ venta => venta.realizadaEnLugar(lugar) })
	
	//Punto 5b
	override method dineroMovido() = ventas.sum({ venta => venta.monto() })
	
	override method tieneSoloVentasTacanias(lugar) = self.ventasDe(lugar).all({ venta => venta.tienePromo() })
	
	method ventasDe(lugar) = ventas.filter({ venta => venta.realizadaEnLugar(lugar) })
	
}

class Shopping inherits Establecimiento {
	const locales = []
	
	//Punto 5a
	override method cantidadVentas(lugar) = locales.sum({ local => local.cantidadVentas(lugar) })
	//Punto 5b
	override method dineroMovido() = locales.sum({ local => local.dineroMovido() })
	
	override method tieneSoloVentasTacanias(lugar) = locales.all({ local => local.tieneSoloVentasTacanias(lugar) })
	
}

object empresa {
	
	const lugares = []
	const establecimientos = []

	//Punto 6
	method lugarConMasVentas() {
		lugares.max({ lugar => self.cantidadVentas(lugar) })
	}
	
	method cantidadVentas(lugar) {
		establecimientos.sum({ establecimiento => establecimiento.cantidadVCentas(lugar) })
	}
	
	//Punto 7
	method tieneLugarDeClientesTacanios() {
		lugares.any({ lugar => self.lugarDeTacanios(lugar) })
	}
	
	method lugarDeTacanios(lugar) {
		establecimientos.all({ establecimiento => establecimiento.tieneSoloVentasTacanias(lugar) })
	}
	
}