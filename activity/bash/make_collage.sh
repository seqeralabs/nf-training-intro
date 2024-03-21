#!/usr/bin/env bash

# Loop over all our files to classify them

ls data/*.png | while read -r picture; do
    
    # Run the classify command and fetch the label# 
    label=$(classify --image $picture --labels 'cat,dog,spider')
    
    # Create an output directory for this label, if it doesn't exist
    mkdir -p classified/$label

    # Copy the input file to the class diretory
    cp $picture classified/$label
done

# Make a collage for each class

mkdir -p collages

ls classified | while read -r class; do
    montage -geometry 80 -tile 4x classified/$class/* tmp.png
    montage -label '$class' tmp.png -geometry +0+0 -background Gold collages/${class}.png
    rm tmp.png
done

# Combine the collages
montage -geometry +0+0 -tile 1x collages/* collage_all.png
