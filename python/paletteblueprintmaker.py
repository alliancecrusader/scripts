import os
import json

def get_all_texture_names(path):
    """Retrieve all unique texture names from JSON or text files in a directory."""
    textures = []
    for root, dirs, files in os.walk(path):
        for file in files:
            if file.endswith(".json") or file.endswith(".txt"):
                with open(os.path.join(root, file)) as f:
                    decoded = json.load(f)
                try:
                    if decoded['name'] not in textures:
                        textures.append(decoded['name'])
                except KeyError:
                    pass
    return textures

def create_palette_blueprint(input_texture_path, output_blueprint_path, blueprint_name):
    """Create a blueprint from the textures of a specified texture pack."""
    brick = '{      "n": "Fuel Tank",      "p": {        "x": 10.0,        "y": 0.5      },      "o": {        "x": 1.0,        "y": 1.0,        "z": 0.0      },      "t": "-Infinity",      "N": {        "width_original": 2.0,        "width_a": 2.0,        "width_b": 2.0,        "height": 2.0,        "fuel_percent": 1.0      },      "T": {        "color_tex": "_",        "shape_tex": "Flat"      }    }'
    bp_template = '{  "center": 10.0,  "parts": [      ],  "stages": [],  "rotation": 0.0,  "offset": {    "x": 0.0,    "y": 0.0  },  "interiorView": false}'

    textures = get_all_texture_names(input_texture_path)
    bp = json.loads(bp_template)
    
    for i, texture in enumerate(textures):
        brick_json = json.loads(brick)
        brick_json['T']['color_tex'] = texture
        brick_json['p']['x'] = i * 2
        bp['parts'].append(brick_json)

    folder_path = os.path.join(output_blueprint_path, blueprint_name)
    bp_path = os.path.join(folder_path, "Blueprint.txt")

    if not os.path.exists(folder_path):
        os.makedirs(folder_path)
    else:
        raise FileExistsError(f"Blueprint with this name ({blueprint_name}) already exists, not overwriting, at the path {folder_path}")

    with open(bp_path, 'w') as f:
        f.write(json.dumps(bp, indent=4))

    version_path = os.path.join(folder_path, "Version.txt")
    with open(version_path, 'w') as f:
        f.write('"1.5.10.2"')

    print(f"Blueprint created successfully at {bp_path}")

def main():
    """Main function for creating a blueprint from a texture pack."""
    # Inputs
    game_path = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Spaceflight Simulator\\Spaceflight Simulator Game"
    texture_pack_name = "Su-60 Firefox"

    # Paths
    textures_path = os.path.join(game_path, "Mods", "Custom Assets", "Texture Packs")
    bp_output_path = os.path.join(game_path, "Saving", "Blueprints")

    input_texture_path = os.path.join(textures_path, texture_pack_name, "Color Textures")

    # Generate blueprint
    create_palette_blueprint(input_texture_path, bp_output_path, texture_pack_name + " Palette")

if __name__ == "__main__":
    main()
