#!/usr/bin/env nextflow

params.input = "${projectDir}/data/*.png"
params.prompts = 'a photo of a cat,a photo of a dog'
params.outdir = 'results'

workflow {
    pics = Channel.fromPath(params.input)

    Classify(pics, params.prompts)
    | map { label, pic -> [label.text, pic] }
    | groupTuple
    | Collage
    | collect
    | CombineImages
}

process Classify {
    memory '8G'
    container 'robsyme/clip-cpu:1.0.0'

    input:
    path(pic)
    val(prompts)

    output:
    tuple path("out.txt"), path(pic)

    script:
    "classify --image $pic --labels '$prompts' > out.txt"
}

process Collage {
    memory '8G'
    container 'robsyme/imagemagick:latest'

    input:
    tuple val(label), path("pics/*")

    output:
    path("montage.png")

    script:
    """
    mkdir -p resized
    mogrify -resize 128x128 -path resized/ pics/*

    montage -geometry 128 resized/* -background black +polaroid -background '#ffbe76' -geometry -10-10 png:- \
    | montage -label '$label' - -geometry +0+0 -background "#f0932b" montage.png
    """
}

process CombineImages {
    container 'robsyme/imagemagick:latest'
    publishDir params.outdir

    input:
    path("montage.*.png")
    
output:
    path("collage.png")
    path("collage.compressed.jpg")

    script:
    """
    montage -geometry +10+10 montage.*.png -background "#ffbe76" -border 5 -bordercolor "#f0932b" collage.png
    convert collage.png -define jpeg:extent=9M collage.compressed.jpg
    """
}

