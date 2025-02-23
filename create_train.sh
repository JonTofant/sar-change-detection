import os

def save_file_paths(directory):
    with open("train_files.txt", "w") as f:
        for root, _, files in os.walk(directory):
            for file in files:
                f.write(os.path.join(root, file) + "\n")

# Change 'your_directory_path' to the folder you want to scan
directory_path = "notprocessed/train/"
save_file_paths(directory_path)

print("File paths saved to train_files.txt")
