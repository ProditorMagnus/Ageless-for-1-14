#!/usr/bin/env python3
import os, re, sys
from datetime import datetime
from collections import defaultdict
import textwrap

messages = defaultdict(list)  # agrupamos por textdomain


def add_msg(domain, msg, file, line, nodeinfo, translator_comments=None):
    msg = msg.replace('\r', '')
    if not msg.strip():
        return
    messages[domain].append((msg, file, line, nodeinfo, translator_comments or []))


def clean_content(s):
    """Mantiene espacios finales y convierte saltos de línea internos en \\n y tabs en \\t"""
    s = s.replace('\r', '')
    s = s.replace('\t', '\\t')
    return s.replace('\n', '\\n')


def extract_strings(path, filter_domain=None):
    with open(path, "r", encoding="utf-8", errors="ignore") as f:
        text = f.read()

    lines = text.splitlines()

    # DETECCIÓN DINÁMICA DE TEXTDOMAIN POR LÍNEA
    domain_per_line = {}
    current_domain = "default"

    for i, line in enumerate(lines, start=1):

        # WML: #textdomain domain
        dm = re.search(r'#\s*textdomain\s+"?([\w\-.]+)"?', line)

        # Lua: wesnoth.textdomain("domain")  o  wesnoth.textdomain "domain"
        dm_lua = re.search(
            r'wesnoth\.textdomain\s*\(\s*["\']([\w\-.]+)["\']\s*\)'
            r'|wesnoth\.textdomain\s+["\']([\w\-.]+)["\']',
            line
        )

        if dm:
            current_domain = dm.group(1)

        elif dm_lua:
            current_domain = dm_lua.group(1) or dm_lua.group(2)

        domain_per_line[i] = current_domain

    # Si se pide filtrar y el dominio no aparece en este archivo
    if filter_domain and filter_domain not in domain_per_line.values():
        return

    # Detectar funciones wesnoth.wml_actions en Lua
    lua_functions = []
    if path.endswith(".lua"):
        for match in re.finditer(r'function\s+wesnoth\.wml_actions\.([A-Za-z0-9_]+)\s*\(', text):
            start_line = text[:match.start()].count("\n") + 1
            func_name = match.group(1)
            lua_functions.append((start_line, func_name))

    # Buscar cadenas traducibles
    pattern = re.compile(
    r'''
    (?<![A-Za-z0-9_])             # no precedido por carácter de identificador
    _\s*                           # _
    (?:\(\s*)?                    # opcional (
    "((?:[^"\\]|\\.|"")*?)"       # contenido
    \s*(?:\))?                    # opcional )
    \s*(?:\+)?                    # opcional +
    ''',
    re.DOTALL | re.VERBOSE
)

    for m in pattern.finditer(text):
        content_raw = m.group(1).replace('""', '"')
        line = text[:m.start()].count("\n") + 1
        context_lines = text[:m.start()].splitlines()
        nodeinfo = []

        # Si es Lua, identificar la función actual
        if path.endswith(".lua") and lua_functions:
            for i, (start, name) in enumerate(lua_functions):
                end = lua_functions[i + 1][0] if i + 1 < len(lua_functions) else len(lines)
                if start <= line <= end:
                    nodeinfo.append(f"[lua]: wesnoth.wml_actions.{name}")
                    break

        # -------------------------
        # Procesar como WML
        # -------------------------
        if not path.endswith(".lua"):
            all_tags = re.findall(r'\[(/?)([a-zA-Z0-9_+/]+)\]', "\n".join(context_lines))
            stack = []
            for slash, t in all_tags:
                if slash == "":
                    stack.append(t)
                elif stack and stack[-1] == t:
                    stack.pop()
            tag = stack[-1] if stack else None

            attack_type = attack_range = None
            unit_id = unit_race = None
            unit_type = unit_role = unit_gender = None
            speaker = None
            side_type = None
            objective_condition = None
            effect_apply_to = effect_range = effect_type = None
            about_entry_name = None

            block_pattern = None
            special_blocks = {
                "campaign", "modification", "era", "abilities", "set_menu_item", "companion_message", "achievement", "advancement",
                "scenario", "hides", "dummy", "illuminates", "heals", "skirmisher", "damage", "berserk", "plague", "poison", "firststrike", "slow", "drains"
                "topic", "teleport", "regenerate", "resistance", "chance_to_hit", "leadership", "time", "time_area", "trait", "event"
                "object", "variation", "checkbox", "multiplayer", "multiplayer_side", "choice", "slider", "row", "button", "toggle_button", "label", "window", "editor_group", "race", "terrain_type"
            }

            if tag in {"attack", "unit_type", "unit", "message", "side", "objective", "effect", "about"} or tag in special_blocks:
                block_pattern = re.compile(r'\[' + tag + r'\](.*?)\[/'+tag+r'\]', re.DOTALL)

            block_text = None
            current_key = None
            if block_pattern:
                for blk in block_pattern.finditer(text):
                    if blk.start() <= m.start() <= blk.end():
                        block_text = blk.group(1)

                        # companion_message
                        if tag == "companion_message":
                            before_segment = text[blk.start():m.start()]
                            line_fragment = before_segment.splitlines()[-1] \
                                            if before_segment.splitlines() else ""
                            key_match = re.search(r'(message_[A-Za-z0-9_]+|fallback_[A-Za-z0-9_]+)\s*=', line_fragment)
                            if key_match:
                                current_key = key_match.group(1)

                        # attack
                        if tag == "attack":
                            t_match = re.search(r'type\s*=\s*"?([^\n"]*?)"?$', block_text, re.MULTILINE)
                            r_match = re.search(r'range\s*=\s*"?([^\n"]*?)"?$', block_text, re.MULTILINE)
                            if t_match: attack_type = t_match.group(1).strip()
                            if r_match: attack_range = r_match.group(1).strip()

                        # unit_type
                        elif tag == "unit_type":
                            id_match = re.search(r'id\s*=\s*"?([^\n"]*?)"?$', block_text, re.MULTILINE)
                            race_match = re.search(r'race\s*=\s*"?([^\n"]*?)"?$', block_text, re.MULTILINE)
                            gender_match = re.search(r'gender\s*=?\s*"?([^\n"]*?)"?$', block_text, re.MULTILINE)
                            if id_match: unit_id = id_match.group(1).strip()
                            if race_match: unit_race = race_match.group(1).strip()
                            if gender_match:
                                val = gender_match.group(1).strip()
                                if ',' not in val:
                                    unit_gender = val

                        # unit
                        elif tag == "unit":
                            t_match = re.search(r'type\s*=\s*"?([^\n"]*?)"?$', block_text, re.MULTILINE)
                            id_match = re.search(r'id\s*=\s*"?([^\n"]*?)"?$', block_text, re.MULTILINE)
                            role_match = re.search(r'role\s*=?\s*"?([^\n"]*?)"?$', block_text, re.MULTILINE)
                            gender_match = re.search(r'gender\s*=?\s*"?([^\n"]*?)"?$', block_text, re.MULTILINE)
                            if t_match: unit_type = t_match.group(1).strip()
                            if id_match: unit_id = id_match.group(1).strip()
                            if role_match: unit_role = role_match.group(1).strip()
                            if gender_match: unit_gender = gender_match.group(1).strip()

                        # message
                        elif tag == "message":
                            sp_match = re.search(r'speaker\s*=\s*("?)([^"\n]+)\1', block_text)
                            if sp_match: speaker = sp_match.group(2).strip()

                        # side
                        elif tag == "side":
                            type_match = re.search(r'type\s*=\s*"?([^\n"]+)"?', block_text, re.MULTILINE)
                            if type_match: side_type = type_match.group(1).strip()

                        # objective
                        elif tag == "objective":
                            cond_match = re.search(r'condition\s*=\s*"?([^\n"]+)"?', block_text, re.MULTILINE)
                            if cond_match:
                                objective_condition = cond_match.group(1).strip()

                        # about
                        elif tag == "about":
                            # El string puede estar en title= (fuera de [entry]) o dentro de [entry].
                            # Si esta dentro de un [entry], se usa solo ese name.
                            # si esta fuera (es el title del bloque [about]), se agrega los names de todos los [entry] del bloque.
                            entries = list(re.finditer(r'\[entry\](.*?)\[/entry\]', block_text, re.DOTALL))
                            inside_entry = None
                            for em in entries:
                                entry_abs_start = blk.start() + em.start()
                                entry_abs_end   = blk.start() + em.end()
                                if entry_abs_start <= m.start() <= entry_abs_end:
                                    inside_entry = em
                                    break
                            if inside_entry is not None:
                                n_match = re.search(r'name\s*=\s*"?([^\n"]+)"?', inside_entry.group(1))
                                if n_match:
                                    about_entry_name = n_match.group(1).strip()
                            elif entries:
                                names = []
                                for em in entries:
                                    n_match = re.search(r'name\s*=\s*"?([^\n"]+)"?', em.group(1))
                                    if n_match:
                                        names.append(n_match.group(1).strip())
                                if names:
                                    about_entry_name = ", ".join(names)

                        # effect
                        elif tag == "effect":
                            at_match = re.search(r'apply_to\s*=\s*"?([^\n"]*?)"?$', block_text, re.MULTILINE)
                            r_match  = re.search(r'range\s*=\s*"?([^\n"]*?)"?$', block_text, re.MULTILINE)
                            t_match  = re.search(r'type\s*=\s*"?([^\n"]*?)"?$', block_text, re.MULTILINE)
                            if at_match: effect_apply_to = at_match.group(1).strip()
                            if r_match:  effect_range    = r_match.group(1).strip()
                            if t_match:  effect_type     = t_match.group(1).strip()

                        break

            info_parts = []

            if tag == "companion_message":
                if current_key:
                    info_parts.append(f"[{tag}], {current_key}")
                else:
                    info_parts.append(f"[{tag}]")

            elif tag in special_blocks and block_text:
                id_match = re.search(r'id\s*=\s*"?([^\n"]*?)"?$', block_text, re.MULTILINE)
                block_id = id_match.group(1).strip() if id_match else None
                if block_id:
                    info_parts.append(f"[{tag}], id={block_id}")
                else:
                    info_parts.append(f"[{tag}]")

            elif tag == "objective":
                if objective_condition:
                    info_parts.append(f"[objective], condition={objective_condition}")
                else:
                    info_parts.append("[objective]")

            else:
                if tag and tag != "about": info_parts.append(f"[{tag}]")
                if tag == "attack":
                    if attack_type: info_parts.append(f"type={attack_type}")
                    if attack_range: info_parts.append(f"range={attack_range}")
                elif tag == "unit_type":
                    if unit_id: info_parts.append(f"id={unit_id}")
                    if unit_race: info_parts.append(f"race={unit_race}")
                    if unit_gender: info_parts.append(f"gender={unit_gender}")
                elif tag == "unit":
                    if unit_id: info_parts.append(f"id={unit_id}")
                    if unit_type: info_parts.append(f"type={unit_type}")
                    if unit_role: info_parts.append(f"role={unit_role}")
                    if unit_gender: info_parts.append(f"gender={unit_gender}")
                elif tag == "side":
                    if side_type: info_parts.append(f"type={side_type}")
                elif tag == "effect":
                    if effect_apply_to: info_parts.append(f"apply_to={effect_apply_to}")
                    if effect_type:     info_parts.append(f"type={effect_type}")
                    if effect_range:    info_parts.append(f"range={effect_range}")
                elif tag == "about":
                    if about_entry_name:
                        info_parts.append(f"[about] name={about_entry_name}")
                    else:
                        info_parts.append("[about]")
                if speaker:
                    info_parts.append(f"speaker={speaker}")

            if info_parts:
                nodeinfo.append(", ".join(info_parts))

        # Comentarios del traductor (po, TRANSLATORS, po-override)
        # Soporta prefijo wml (#) y lua (--)
        _PREPROCESSOR_RE = re.compile(
            r'\s*#\s*(?:textdomain|define|ifdef|ifndef|ifver|ifnver|else|endif)\b',
            re.IGNORECASE
        )
        # Keyword valido con # (WML/cfg) y con -- (Lua); mayusculas cubiertas por ignorecase
        _KEYWORD_RE = re.compile(
            r'(?:#|--)\s*(?:TRANSLATORS|po(?:-override)?)\s*:',
            re.IGNORECASE
        )

        raw_block = []  # lineas de comentario en orden (arriba abajo)
        for _i in range(line - 2, max(-1, line - 2 - 30), -1):
            _pl = lines[_i]
            _s  = _pl.strip()
            if _s == '':
                break                                           # linea en blanco: cortar
            if _s.startswith('--'):
                raw_block.insert(0, _pl)                       # comentario Lua
            elif _s.startswith('#') and not _PREPROCESSOR_RE.match(_pl):
                raw_block.insert(0, _pl)                       # comentario WML
            else:
                break                                           # linea no-comentario: cortar

        # Buscar el primer comentario (mas arriba) que contenga el keyword
        _first_kw = None
        for _idx, _pl in enumerate(raw_block):
            if _KEYWORD_RE.search(_pl):
                _first_kw = _idx
                break

        translator_comments_block = []
        if _first_kw is not None:
            # Si el tag #po está en minusculas exactas (po, po-override, translators) se oculta el tag y solo se muestra el comentario tras los dos puntos.
            # Si esta en mayúsculas se conserva el tag.
            _LOWER_KEYWORD_RE = re.compile(
                r'^(?:#+|--+)\s*(translators|po(?:-override)?)\s*:\s*(.*)$'
            )
            for _pl in raw_block[_first_kw:]:
                _stripped = _pl.strip()
                _lower_match = _LOWER_KEYWORD_RE.match(_stripped)
                if _lower_match:
                    _content = _lower_match.group(2).strip()
                else:
                    # Quitar indentacion, prefijo -- o # y un espacio opcional
                    _content = re.sub(r'^\s*(?:--+|#+)\s?', '', _pl).strip()
                if _content:
                    translator_comments_block.append(_content)

        # Detectar #define SPECIAL_NOTE* exactamente 1 línea arriba
        if line >= 2:
            line_above = lines[line - 2]
            sn_match = re.match(r'\s*#define\s+(SPECIAL_NOTE\S*)', line_above)
            if sn_match:
                nodeinfo.insert(0, sn_match.group(1))

        # Usar dominio detectado dinamicamente
        add_msg(
            domain_per_line[line],
            clean_content(content_raw),
            path,
            line,
            nodeinfo,
            translator_comments_block
        )


def escape_for_po(s, width=77):
    parts = s.split("\\n")
    lines = []
    wrapper = textwrap.TextWrapper(width=width, break_long_words=False,
                                   break_on_hyphens=False, replace_whitespace=False,
                                   drop_whitespace=False, expand_tabs=False)
    for i, part in enumerate(parts):
        wrapped = wrapper.wrap(part)
        if not wrapped: wrapped = [""]
        lines.extend(wrapped)
        if i < len(parts)-1: lines[-1] += "\\n"
    if len(lines) == 1 and len(lines[0]) <= width:
        safe = lines[0].replace('"', '\\"')
        return f'msgid "{safe}"'
    out = ['msgid ""']
    for line in lines:
        safe = line.replace('"', '\\"')
        out.append(f'"{safe}"')
    return "\n".join(out)


def generate_pot(domain, entries):
    date = datetime.now().strftime("%Y-%m-%d %H:%M%z")
    out = [
        'msgid ""',
        'msgstr ""',
        '"Project-Id-Version: PACKAGE VERSION\\n"',
        '"Report-Msgid-Bugs-To: https://bugs.wesnoth.org/\\n"',
        f'"POT-Creation-Date: {date}\\n"',
        '"PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\\n"',
        '"Last-Translator: FULL NAME <EMAIL@ADDRESS>\\n"',
        '"Language-Team: LANGUAGE <LL@li.org>\\n"',
        '"Language: LANGUAGE\\n"',
        '"MIME-Version: 1.0\\n"',
        '"Content-Type: text/plain; charset=UTF-8\\n"',
        '"Content-Transfer-Encoding: 8bit\\n"\n'
    ]
    grouped = defaultdict(lambda: {"refs": [], "notes": []})
    for msg, file, line, nodeinfo, comments in entries:
        key = msg
        grouped[key]["refs"].append(f"{file}:{line}")
        grouped[key]["notes"].extend(comments + nodeinfo)
    for msg, data in grouped.items():
        unique_notes = list(dict.fromkeys(data["notes"]))
        for note in unique_notes:
            out.append(f"#. {note}")
        for ref in data["refs"]:
            out.append(f"#: {ref}")
        out.append(escape_for_po(msg))
        out.append('msgstr ""\n')
    with open(f"{domain}.pot", "w", encoding="utf-8") as f:
        f.write("\n".join(out))
    print(f"✅ Generado {domain}.pot ({len(grouped)} cadenas)")


MAINLINE_CORE = {"wesnoth", "wesnoth-lib", "wesnoth-units", "wesnoth-help"}

AYUDA = """\
============================================================
                CREAR_POT - AYUDA
============================================================

USO:
  python crear_pot.py [comando] [opciones]


COMANDOS:
  (ninguno)
      Extrae todas las cadenas y genera un archivo .pot
      por dominio.
      Los dominios sin declaración explícita se guardan en:
          default.pot

  all
      Extrae todas las cadenas de todos los dominios
      y las combina en un único archivo:
          all.pot

  <dominio>
      Extrae únicamente las cadenas del dominio indicado
      y genera:
          <dominio>.pot
      Ejemplo:
          python crear_pot.py wesnoth-era

  --ayuda
      Muestra este mensaje de ayuda.


OPCIONES:
  --nomainline
      Ignora los dominios del núcleo de Wesnoth:
          - wesnoth
          - wesnoth-lib
          - wesnoth-units
          - wesnoth-help

      Compatible con todos los modos.


============================================================
"""

if __name__ == "__main__":
    args = sys.argv[1:]

    # Ayuda
    if "--ayuda" in args:
        print(AYUDA)
        sys.exit(0)

    no_mainline = "--nomainline" in args
    args = [a for a in args if a != "--nomainline"]

    mode = args[0] if args else None  # None | "all" | "<dominio>"

    root = "."
    for dirpath, dirs, files in os.walk(root):
        for f in files:
            if f.endswith(".cfg") or f.endswith(".lua"):
                extract_strings(
                    os.path.join(dirpath, f),
                    None if mode in (None, "all") else mode
                )

    # Filtrar dominios mainline si corresponde
    def should_skip(domain):
        return no_mainline and domain in MAINLINE_CORE

    if mode == "all":
        # Un único all.pot con todo (salvo dominios excluidos)
        combined = []
        for domain, entries in messages.items():
            if not should_skip(domain):
                combined.extend(entries)
        generate_pot("all", combined)

    elif mode is None:
        # Un .pot por dominio
        for domain, entries in messages.items():
            if not should_skip(domain):
                generate_pot(domain, entries)

    else:
        # Dominio concreto
        if should_skip(mode):
            print(f"⚠️  Dominio '{mode}' excluido por --nomainline.")
        else:
            entries = messages.get(mode, [])
            if entries:
                generate_pot(mode, entries)
            else:
                print(f"⚠️  No se encontraron cadenas para el dominio '{mode}'.")