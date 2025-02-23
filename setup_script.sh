# Anaconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86.sh

bash ./Miniconda3-latest-Linux-x86.sh

cd sar-change-detection/

#Conda envrionment
conda env create -f environment.yml

conda activate SAR

# In your terminal (run this every time you activate the environment)
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/

# Once inside the folder 
aria2c -x 16 -s 16 -o bigfile.zip "URL_TO_ZIP_FILE"

# Step 2
#unzip -q bigfile.zip -d extracted_files &

# step 2
unzip -q bigfile.zip &

pid=$!
ionice -c 2 -n 0 nice -n -5 wait $pid

# Delete zip
rm bigfile.zip


sudo apt-get parallel -y

# assuming that train_files.txt includes filepaths to all files you want to preprocess
parallel --halt now,fail=1 -j 45 -I{} python preprocess_tfrecords.py --dataset_stats stats.json --output_dir processed/train/ {} :::: train_files.txt


# assuming that val_files.txt includes filepaths to all files you want to preprocess
parallel --halt now,fail=1 -j 45 -I{} python preprocess_tfrecords.py --dataset_stats stats.json --output_dir processed/val/ {} :::: val_files.txt


# Train
python main.py \
        --train_data "processed/train/*.tfrecord.GZIP" \
        --val_data "processed/val/*.tfrecord.GZIP" \
        --no_checkpoints \
        --epochs 50 \
        --no_mixed_precision \
        --batch_size 32




