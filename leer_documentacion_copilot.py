#!/usr/bin/env python3
"""leer_documentacion_copilot.py

Mejoras sobre `leer_documentacion.py`:
- Parseo de secciones por headers (#, ##)
- Menú interactivo y modo CLI (listar, mostrar, buscar, exportar)
- Manejo de errores y encoding explícito
- Funciones reutilizables para tests

Uso (ejemplos):
  python leer_documentacion_copilot.py --list
  python leer_documentacion_copilot.py --show "Resumen ejecutivo"
  python leer_documentacion_copilot.py --search "productos"
  python leer_documentacion_copilot.py --export "Estructura" salida.txt
"""

from __future__ import annotations
import argparse
import re
from typing import List, Dict, Optional
import sys


def read_file(path: str) -> str:
    """Lee y retorna el contenido del archivo con UTF-8.
    Lanza FileNotFoundError si no existe.
    """
    with open(path, 'r', encoding='utf-8') as f:
        return f.read()


def parse_sections(markdown: str) -> List[Dict[str, str]]:
    """Extrae secciones del Markdown usando headers de nivel 1 y 2.

    Retorna una lista ordenada de diccionarios: {'titulo': str, 'contenido': str}
    """
    lines = markdown.splitlines()
    sections: List[Dict[str, str]] = []
    current_title: Optional[str] = None
    buffer: List[str] = []

    header_re = re.compile(r'^(#{1,2})\s+(.*)')

    for line in lines:
        m = header_re.match(line)
        if m:
            # Nuevo header
            if current_title:
                sections.append({'titulo': current_title, 'contenido': '\n'.join(buffer).strip()})
            level = len(m.group(1))
            title = m.group(2).strip()
            current_title = title
            buffer = [line]
        else:
            if current_title:
                buffer.append(line)

    if current_title:
        sections.append({'titulo': current_title, 'contenido': '\n'.join(buffer).strip()})

    return sections


def list_sections(sections: List[Dict[str, str]]) -> None:
    for i, s in enumerate(sections, 1):
        print(f"{i}. {s['titulo']}")


def find_section_by_title(sections: List[Dict[str, str]], title: str) -> Optional[Dict[str, str]]:
    title_lower = title.strip().lower()
    for s in sections:
        if s['titulo'].lower() == title_lower:
            return s
    # fallback: partial match
    for s in sections:
        if title_lower in s['titulo'].lower():
            return s
    return None


def search_sections(sections: List[Dict[str, str]], query: str) -> List[Dict[str, str]]:
    q = query.strip().lower()
    results = []
    for s in sections:
        if q in s['titulo'].lower() or q in s['contenido'].lower():
            results.append(s)
    return results


def export_section(section: Dict[str, str], outpath: str) -> None:
    with open(outpath, 'w', encoding='utf-8') as f:
        f.write(f"# {section['titulo']}\n\n")
        f.write(section['contenido'])


def interactive_menu(sections: List[Dict[str, str]]) -> None:
    while True:
        print("\n=== Menú interactivo - Documentación Tienda Aurelion ===")
        list_sections(sections)
        print("0. Salir")
        choice = input("Seleccione una sección por número o escriba 'buscar' o 'salir': ").strip()
        if choice.lower() in ('0', 'salir', 'exit', 'quit'):
            print("Saliendo...")
            break
        if choice.lower() == 'buscar':
            q = input("Término de búsqueda: ").strip()
            matches = search_sections(sections, q)
            if not matches:
                print("No se encontraron coincidencias.")
            else:
                for s in matches:
                    print(f"-- {s['titulo']} --")
                    print(s['contenido'][:1000])
            continue
        try:
            idx = int(choice) - 1
            if 0 <= idx < len(sections):
                sel = sections[idx]
                print(f"\n--- {sel['titulo']} ---\n")
                print(sel['contenido'])
            else:
                print("Número fuera de rango.")
        except ValueError:
            print("Entrada no válida.")


def build_arg_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description='Leer y explorar Documentación.md del proyecto Tienda Aurelion')
    p.add_argument('--file', '-f', default='Documentación.md', help='Ruta al archivo markdown (default: Documentación.md)')
    p.add_argument('--list', action='store_true', help='Listar secciones')
    p.add_argument('--show', metavar='TITULO', help='Mostrar sección por título')
    p.add_argument('--search', metavar='QUERY', help='Buscar término en títulos y contenido')
    p.add_argument('--export', nargs=2, metavar=('TITULO', 'OUTFILE'), help='Exportar la sección titulada a OUTFILE')
    p.add_argument('--interactive', action='store_true', help='Iniciar menú interactivo')
    return p


def main(argv: List[str]) -> int:
    parser = build_arg_parser()
    args = parser.parse_args(argv)

    try:
        text = read_file(args.file)
    except FileNotFoundError:
        print(f"El archivo especificado no existe: {args.file}")
        return 2

    sections = parse_sections(text)

    if args.list:
        list_sections(sections)
        return 0

    if args.show:
        s = find_section_by_title(sections, args.show)
        if not s:
            print(f"Sección no encontrada: {args.show}")
            return 3
        print(s['contenido'])
        return 0

    if args.search:
        matches = search_sections(sections, args.search)
        if not matches:
            print("No se encontraron coincidencias.")
            return 4
        for m in matches:
            print(f"-- {m['titulo']} --")
            print(m['contenido'][:2000])
            print('\n')
        return 0

    if args.export:
        title, outfile = args.export
        s = find_section_by_title(sections, title)
        if not s:
            print(f"Sección no encontrada: {title}")
            return 5
        export_section(s, outfile)
        print(f"Sección '{title}' exportada a {outfile}")
        return 0

    if args.interactive:
        interactive_menu(sections)
        return 0

    # Si no hay flags, entrar al modo interactivo por defecto
    interactive_menu(sections)
    return 0


if __name__ == '__main__':
    raise SystemExit(main(sys.argv[1:]))
