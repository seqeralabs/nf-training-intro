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
    mogrify -resize 256x256 -quality 100 -path resized/ pics/*
    montage -geometry 100 null: resized/* null: -background black +polaroid -gravity center -background '#ffbe76' png:- \
    | montage -label '$label' - -geometry +0+0 -background "#f0932b" montage.png
    """
}

process CombineImages {
    container 'robsyme/imagemagick:latest'
    publishDir params.outdir

    input:
    path("input.*.png")

    output:
    path("collage.png")

    script:
    """
    montage -geometry +10+10 montage.*.png -background "#ffbe76" -border 5 -bordercolor "#f0932b" collage.png
    """
}

