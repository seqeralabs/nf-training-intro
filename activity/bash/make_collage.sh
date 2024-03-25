#!/usr/bin/env bash

# List all of the image files in the 'data' directory and classify them in a loop
ls data/*.png | while read -r picture; do
    
    # Run the classify command and fetch the label printed to the screen
    label=$(classify --image $picture --labels 'cat,dog,cute_dog')
    
    # Create an output directory for this label, if it doesn't exist
    mkdir -p classified/$label

    # Copy the input file to the class diretory
    cp $picture classified/$label
done

# Make a directory called 'collages'
mkdir -p collages

# Make a collage for each class
ls classified | while read -r class; do
    montage -geometry 80 -tile 4x classified/$class/* tmp.png
    montage -label '$class' tmp.png -geometry +0+0 -background Gold collages/${class}.png
    rm tmp.png
done

# Combine the collages
montage -geometry +0+0 -tile 1x collages/* collage_all.png
