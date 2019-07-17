# Info

```sh
ssh -i ~/.ssh/sasha-iaas-no.pem mprinc@158.39.75.130
```

# Install

```sh
sudo virtualenv -p python3 /var/services/colabo-env-python3
sudo chown -R sasha:developers /var/services/colabo-env-python3
cd /var/services/colabo-business-services/
source /var/services/colabo-env-python3/bin/activate
deactivate
```

## Browsers

https://www.tecmint.com/linux-command-line-tools-for-downloading-files/

```sh
sudo apt install elinks
```

## Packages

```sh
pip3 install numpy
pip3 install gensim
pip3 install nltk
# pip3 install pyemd
pip3 install statistics
```

# Packages

## Word2vec

+ https://code.google.com/archive/p/word2vec/
+ pretrained sets
    + GoogleNews
        + https://drive.google.com/file/d/0B7XkCwpI5KDYNlNUTTlSS21pQmM/edit
        + without need to login to google doc
            + https://groups.google.com/forum/#!topic/word2vec-toolkit/z0Aw5powUco
            + `wget -c "https://s3.amazonaws.com/dl4j-distribution/GoogleNews-vectors-negative300.bin.gz"`
            + `wget -c "http://vectors.nlpl.eu/repository/11/1.zip"`
            + https://www.quora.com/How-can-I-download-the-Google-news-word2vec-pretrained-model-from-a-Ubuntu-terminal
        + `/var/colabo/GoogleNews-vectors-negative300.bin`


## WMD

+ https://markroxor.github.io/gensim/static/notebooks/WMD_tutorial.html
+ https://www.ibm.com/blogs/research/2018/11/word-movers-embedding/