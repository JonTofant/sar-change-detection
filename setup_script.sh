# Anaconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86.sh

bash ./Miniconda3-latest-Linux-x86.sh

cd sar-change-detection/

#Conda envrionment
conda env create -f environment.yml

conda activate SAR

# In your terminal (run this every time you activate the environment)
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/

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




# Once inside the folder 
