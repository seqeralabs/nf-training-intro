#!/usr/bin/env bash

# Loop over all image files in the 'data' folder to classify them
echo 'Classifying images...'
for picture in data/*; do
    # # Run the classify command and fetch the label
    label=$(classify.py --image $picture --labels 'cat,dog,spider')

    # Create an output directory for this label, if it doesn't exist
    mkdir -p classified/$label

    # Copy the input file to the class diretory
    cp $picture classified/$label/
done

# Resize each image
echo 'Resizing images...'
for labeldir in classified/*; do
    label=$(basename $labeldir)
    mkdir -p resized/$label
    mogrify -resize 100x100 -path resized/$label -format png $labeldir/*
done

# Make a collage for each class
echo 'Making a collage for each label...'
mkdir -p collages
for labeldir in resized/*; do
    label=$(basename $labeldir) 
    montage -background black +polaroid -background '#ffbe76' $labeldir/* png:- \
    | montage -label "$label" -geometry +0+0 -background "#f0932b" - collages/$label.png
done

# Combine the collages
echo 'Combining for final image...'
montage -geometry +10+10 -quality 05 -background "#ffbe76" -border 5 -bordercolor "#f0932b" collages/* collage_all.png
echo 'Done!'