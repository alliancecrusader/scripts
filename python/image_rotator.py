import os
from PIL import Image

def rotate_images_in_folder(folder_path, rotation_angle=-90):
    if not os.path.exists(folder_path):
        print("Folder does not exist.")
        return
    
    output_folder = os.path.join(folder_path, "rotated")
    os.makedirs(output_folder, exist_ok=True)

    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)
        if os.path.isfile(file_path):
            try:
                with Image.open(file_path) as img:
                    rotated_img = img.rotate(rotation_angle, expand=True)
                    rotated_img.save(os.path.join(output_folder, filename))
                    print(f"Rotated: {filename}")
            except Exception as e:
                print(f"Failed to process {filename}: {e}")

    print("Rotation complete. Rotated images are saved in the 'rotated' folder.")

# Example usage
rotate_images_in_folder("C:\Program Files (x86)\Steam\steamapps\common\Spaceflight Simulator\Spaceflight Simulator Game\Mods\Custom Assets\Texture Packs\A-10 Thunderbolt II Shark\Textures")
