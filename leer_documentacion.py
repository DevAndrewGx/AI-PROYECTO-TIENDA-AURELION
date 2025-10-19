# importamos el modulo  re para trabajar con expresiones regulares
import re

"""
PASOS 
1. Abrir el archivo Documentación.md
2. Leer el contenido del archivo Documentación.md
3. Extraer las secciones del markdown basados en los headers de nivel 1
4. Mostrar el menu con las secciones que se quieren seleccionar del archivo documentación.md
5. Mostrar el contenido en la pantalla 
"""

# Funcion para leer la documentacion 
def leer_documentacion():
    """
    Programa en Python que lee el archivo Documentación.md y permite seleccionar secciones específicas mediante un menú.
    """
    try:
        # Abrir y leer el archivo
        with open('Documentación.md', 'r', encoding='utf-8') as archivo:
            contenido_completo = archivo.read()

        # Parsear el contenido en secciones basadas en headers (# o ##)
        secciones = extraer_secciones(contenido_completo)

        # Mostrar menú y manejar selección
        mostrar_menu(secciones)

    # Excepciones si no se encuentra el archivo...
    except FileNotFoundError:
        print("El archivo 'Documentación.md' no se encontró.")
    except Exception as e:
        print(f"Ocurrió un error al leer el archivo: {e}")


# Funcion para extraer las secciones
def extraer_secciones(contenido):
    """
    Extrae secciones del Markdown basado en headers de nivel 1.
    Retorna una lista ordenada de diccionarios con 'titulo' y 'contenido'.
    """
    secciones = []
    lineas = contenido.split('\n')
    seccion_actual = None
    contenido_seccion = []

    for linea in lineas:
        if linea.startswith('# '):  # Header nivel 1
            if seccion_actual:
                secciones.append({'titulo': seccion_actual, 'contenido': '\n'.join(contenido_seccion).strip()})
            seccion_actual = linea[2:].strip()  # Remover '# '
            contenido_seccion = [linea]
        else:
            if seccion_actual:
                contenido_seccion.append(linea)

    # Agregar la última sección
    if seccion_actual:
        secciones.append({'titulo': seccion_actual, 'contenido': '\n'.join(contenido_seccion).strip()})

    return secciones

def mostrar_menu(secciones):
    """
    Muestra el menú interactivo y maneja la selección del usuario.
    """
    while True:
        print("\n=== Menú de Documentación - Tienda Aurelion ===")
        for i, seccion in enumerate(secciones, start=1):
            print(f"{i}. {seccion['titulo']}")
        print("0. Salir")
        opcion = input(f"\nSeleccione una opción (0-{len(secciones)}): ").strip()

        if opcion == '0':
            print("¡Gracias por usar el programa!")
            break
        try:
            idx = int(opcion) - 1
            if 0 <= idx < len(secciones):
                print(f"\n--- {secciones[idx]['titulo']} ---")
                print(secciones[idx]['contenido'])
            else:
                print("Opción inválida. Por favor, seleccione una opción válida.")
        except ValueError:
            print("Opción inválida. Por favor, ingrese un número.")

# Ejecutar la función principal
if __name__ == "__main__":
    leer_documentacion()
