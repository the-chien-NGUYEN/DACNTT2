#!/bin/bash -v

cd downloaded-data || exit

# get En-Vi training data
printf "\n********** Downloading data... **********\n"
wget -nc https://object.pouta.csc.fi/OPUS-GNOME/v1/moses/en_CA-vi.txt.zip -O en_CA-vi.txt.zip
wget -nc https://object.pouta.csc.fi/OPUS-Ubuntu/v14.10/moses/en_NZ-vi.txt.zip -O en_NZ-vi.txt.zip
wget -nc https://object.pouta.csc.fi/OPUS-GNOME/v1/moses/en_US-vi.txt.zip -O en_US-vi.txt.zip
wget -nc https://object.pouta.csc.fi/OPUS-GNOME/v1/moses/en_ZA-vi.txt.zip -O en_ZA-vi.txt.zip
wget -nc https://object.pouta.csc.fi/OPUS-GNOME/v1/moses/en_GB-vi.txt.zip -O en_GB-vi.txt.zip
wget -nc https://object.pouta.csc.fi/OPUS-TED2020/v1/moses/en-vi.txt.zip -O TED2020-en-vi.txt.zip
wget -nc https://object.pouta.csc.fi/OPUS-Ubuntu/v14.10/moses/en-vi.txt.zip -O wikipedia-en-vi.txt.zip
wget -nc https://object.pouta.csc.fi/OPUS-GNOME/v1/moses/en_AU-vi.txt.zip -O en_AU-vi.txt.zip.zip
printf "\n********** Download data successfully! **********\n"

# extract data
printf "\n********** Extracting data... **********\n"
unzip -o en_CA-vi.txt.zip
unzip -o en_NZ-vi.txt.zip
unzip -o en_US-vi.txt.zip
unzip -o en_ZA-vi.txt.zip
unzip -o en_GB-vi.txt.zip
unzip -o TED2020-en-vi.txt.zip
unzip -o wikipedia-en-vi.txt.zip
unzip -o en_AU-vi.txt.zip.zip
printf "\n********** Extract data successfully! **********\n"

# create corpus files
printf "\n********** Concatenating data... **********\n"
cat GNOME.en_AU-vi.en_AU  GNOME.en_CA-vi.en_CA GNOME.en_GB-vi.en_GB GNOME.en_US-vi.en_US GNOME.en_ZA-vi.en_ZA TED2020.en-vi.en Ubuntu.en_NZ-vi.en_NZ Ubuntu.en-vi.en> corpus-ordered.en.txt
cat GNOME.en_AU-vi.vi  GNOME.en_CA-vi.vi GNOME.en_GB-vi.vi GNOME.en_US-vi.vi GNOME.en_ZA-vi.vi TED2020.en-vi.vi Ubuntu.en_NZ-vi.vi Ubuntu.en-vi.vi> corpus-ordered.vi.txt
printf "\n********** Concatenate data successfully! **********\n"

# remove unnecessary files
printf "\n********** Removing unnecessary files...! **********\n"
find . -type f ! -name '*.txt' -delete
printf "\n********** Remove unnecessary files successfully! **********\n"

# shuffle
printf "\n********** Shuffling training data...! **********\n"
shuf --random-source=corpus-ordered.en.txt corpus-ordered.en.txt > corpus-full.en.txt || exit
shuf --random-source=corpus-ordered.en.txt corpus-ordered.vi.txt > corpus-full.vi.txt || exit
printf "\n********** Shuffling training data successfully! **********\n"

# Make data splits
printf "\n********** Splitting data...! **********\n"
head -n 344987 corpus-full.en.txt > src-train.txt
head -n 344987 corpus-full.vi.txt > tgt-train.txt
tail -n 8000 corpus-full.en.txt > src-test-valid.txt
tail -n 8000 corpus-full.vi.txt > tgt-test-valid.txt
head -n 4000 src-test-valid.txt > src-test.txt
head -n 4000 tgt-test-valid.txt > tgt-test.txt
tail -n 4000 src-test-valid.txt > src-val.txt
tail -n 4000 tgt-test-valid.txt > tgt-val.txt
printf "\n********** Splitting data successfully! **********\n"

# Remove empty lines
printf "\n********** Removing empty lines...! **********\n"
sed -r '/^\s*$/d' -i src-train.txt
sed -r '/^\s*$/d' -i tgt-train.txt
sed -r '/^\s*$/d' -i src-test.txt
sed -r '/^\s*$/d' -i tgt-test.txt
sed -r '/^\s*$/d' -i src-val.txt
sed -r '/^\s*$/d' -i tgt-val.txt
printf "\n********** Removing empty lines successfully! **********\n"

cd ..