# ElasticSearch Dockerfile

Dockerfile that builds an ElasticSearch server, with an SSH port open.

## Usage

Build the image with

     docker build -t my_user/my_tag_name .

then run the resulting image with

     docker run -p 2222:22 -p 9200:9200 -p 9300:9300 -t -i my_user/my_tag_name

## Ports

Internal ports exposed are:
* 22: SSH
* 9200: ElasticSearch HTTP port
* 9300: ElasticSearch transport port
