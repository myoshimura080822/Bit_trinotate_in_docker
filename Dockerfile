FROM phusion/baseimage

MAINTAINER Mika Yoshimura myoshimura080822@gmail.com

RUN mkdir /rnammer_src 
COPY hmmer-2.3.2_trusty.tar.gz /rnammer_src/
ADD rnammer-1.2 /rnammer_src/rnammer-1.2
ADD get_Trinity_gene_to_trans_map.pl /tmp/
ADD vimrc.local /tmp/

## Install Bowtie2,Samtools,Hmmer/Pfam,sqlite,perl URI:Escape module
RUN apt-get update;\
    apt-get install -y -q wget;\
    apt-get install -y -q openjdk-7-jre;\
    apt-get install bowtie -y ;\
    apt-get install samtools -y ;\
    apt-get install hmmer ;\
    apt-get install sqlite -y ;\
    apt-get install -y cpanminus ;\
    cpanm -v URI::Escape ;\
    cpanm -v DBI ;\
    cpanm -v DBD::SQLite ;\
    cpanm -v PerlIO::gzip ;\
    apt-get install -y git ;\
    apt-get install libxml-simple-perl -y ;\
    apt-get -y install tree zsh ;\
    apt-get -y install lib{anyevent,class-accessor-lite,crypt-ssleay,datetime,dbd-sqlite3,dbd-mysql,dbd-pg,dbi,dbix-class,extutils-parsexs,file-homedir,file-sharedir,file-spec,ipc-run3,json,module-build,module-install,mojolicious,moo,moose,mouse,net-ssleay,path-class,plack,test-exception,test-fatal,test-requires,test-warnings,tie-ixhash,try-tiny,uri,uri-encode,www,xml-libxml,yaml}-perl ;\
    apt-get clean && \
## Install Trinity
    mkdir /trinity && cd /trinity && \
    wget https://github.com/trinityrnaseq/trinityrnaseq/archive/v2.2.0.tar.gz;\
    tar -xzvf v2.2.0.tar.gz; rm -rf *.gz;\
    cp -r trinityrnaseq-2.2.0/* ./;\
    mv ./util/support_scripts/get_Trinity_gene_to_trans_map.pl ./util/support_scripts/get_Trinity_gene_to_trans_map.pl_bk ;\
    cp /tmp/get_Trinity_gene_to_trans_map.pl ./util/ ;\
    rm -rf trinityrnaseq_2.2.0 && \

## Install FastqMCF
    apt-get update ; apt-get install -y subversion libgsl0-dev; apt-get clean;\
    svn checkout http://ea-utils.googlecode.com/svn/trunk/ ea-utils-read-only ;\
    cd ea-utils-read-only/clipper ;\
    make install;\
    cd ../..; rm -rf ea-utils-read-only && \

## Install Blast+
    mkdir /blast && cd /blast;\
    wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.3.0/ncbi-blast-2.3.0+-x64-linux.tar.gz ;\
    tar zxvpf ncbi-blast-2.3.0+-x64-linux.tar.gz ;\
    rm ncbi-blast-2.3.0+-x64-linux.tar.gz ;\
    cd .. && \

## Install Trinotate
    mkdir /trinotate && cd /trinotate;\
    wget https://github.com/Trinotate/Trinotate/archive/v3.0.0.tar.gz ;\
    tar xzvf v3.0.0.tar.gz ;\
    rm v3.0.0.tar.gz ;\
    cp -r Trinotate-3.0.0/* ./;\
    rm -rf Trinotate-3.0.0 ;\
    cd .. && \

## Install TransDecoder
    mkdir /transdecoder && cd /transdecoder;\
    wget https://github.com/TransDecoder/TransDecoder/archive/v2.1.0.tar.gz ;\
    tar xzvf v2.1.0.tar.gz ;\
    rm v2.1.0.tar.gz ;\
    cp -r TransDecoder-2.1.0/* ./;\
    rm -rf TransDecoder_2.1.0 ;\
    cd .. && \

## Install hmmer 2.3.2
    mkdir /hmmer_v232 && cd /hmmer_v232 ;\
    tar zxvpf /rnammer_src/hmmer-2.3.2_trusty.tar.gz -C ./ ;\
    cd .. && \

## setting database
    mkdir /database && cd /database ;\
    wget https://data.broadinstitute.org/Trinity/Trinotate_v3_RESOURCES/uniprot_sprot.pep.gz ;\
    gunzip uniprot_sprot.pep.gz ;\
    wget https://data.broadinstitute.org/Trinity/Trinotate_v3_RESOURCES/Pfam-A.hmm.gz ;\
    gunzip Pfam-A.hmm.gz ;\
    hmmpress Pfam-A.hmm ;\
    /blast/ncbi-blast-2.3.0+/bin/makeblastdb -in /database/uniprot_sprot.pep -dbtype prot ;\
    wget "https://data.broadinstitute.org/Trinity/Trinotate_v3_RESOURCES/Trinotate_v3.sqlite.gz" -O /database/Trinotate.sqlite.gz ;\
    gunzip /database/Trinotate.sqlite.gz

# Install OH-MY-ZSH
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git /tmp/.oh-my-zsh  && \
    cp /tmp/.oh-my-zsh/templates/zshrc.zsh-template /etc/zsh/zshrc && \
    sed -i -e "9i TERM=xterm" /etc/zsh/zshrc && \
    sed -i "s/robbyrussell/candy/" /etc/zsh/zshrc && \
# setting vimrc
    cp /tmp/vimrc.local /etc/vim/ && \
    cp -r /tmp/.oh-my-zsh/ /root/

env PATH /trinity:/blast/ncbi-blast-2.2.29+/bin:/trinotate:/transdecoder:$PATH 

VOLUME ["/export/", "/data/", "/var/lib/docker"]

ENTRYPOINT ["/sbin/my_init","--"]

