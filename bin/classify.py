#!/usr/bin/env python3

import torch
import clip
from PIL import Image
import argparse

def parse_args():
    parser = argparse.ArgumentParser(description='Image classification with CLIP')
    parser.add_argument('-i', '--image', type=str, required=True, help='Path to the image file')
    parser.add_argument('-l', '--labels', type=str, required=True, help='Comma-separated list of labels for classification')
    return parser.parse_args()

def main():
    args = parse_args()
    device = "cpu"

    # Split the labels argument on commas to get a list of labels
    labels = [label.strip() for label in args.labels.split(',')]

    text = clip.tokenize(labels).to(device)

    model, preprocess = clip.load('ViT-B/32', device=device)

    image = preprocess(Image.open(args.image)).unsqueeze(0).to(device)
    with torch.no_grad():
        logits_per_image, logits_per_text = model(image, text)
        probs = logits_per_image.softmax(dim=-1).cpu().numpy()
        
        max_label, max_value = max(zip(labels, probs[0]), key=lambda x: x[1])

        print(max_label)

if __name__ == '__main__':
    main()
