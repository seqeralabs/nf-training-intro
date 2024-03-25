FROM ubuntu:latest

RUN apt-get update && apt-get -y install python3-venv python3-pip git 

RUN pip install torch torchvision ftfy regex tqdm git+https://github.com/openai/CLIP.git
RUN python3 -c 'import clip; clip.load("ViT-B/32", device="cpu")'