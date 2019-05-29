FROM dskim89/tensorflow-genomics:latest

# tronn specific installations (mostly R)

# generic
RUN apt-get update -y --fix-missing
RUN apt-get install -y emacs python-tk

# install R (v 3.2.3)
# NOTE: to keep compatible in the future may need to install from source
RUN apt-get install -y libopenblas-base r-base=3.2.3-4 libcurl4-openssl-dev
RUN mkdir -p /R

# install CRAN packages
ADD install_cran.R /R/
RUN Rscript /R/install_cran.R

# install bioconductor packages
ADD install_bioc.R /R/
RUN Rscript /R/install_bioc.R

# install seqtk
RUN cd /software/ && \
  git clone https://github.com/lh3/seqtk.git && \
  cd seqtk && \
  make && \
  echo 'export PATH=/software/seqtk:$PATH' >> ~/.bash_profile && \
  cd
