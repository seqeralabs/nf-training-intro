#!/usr/bin/env nextflow

params.input = "${projectDir}/data/*.png"
params.prompts = 'a photo of a cat,a photo of a dog,a photo'
params.outdir = 'results'

workflow {
    pics = Channel.fromPath(params.input)

    Classify(pics, params.prompts)
    | Resize
    | groupTuple
    | Collage
    | collect
    | CombineImages
}

process Classify {
    memory '8G'
    container 'robsyme/clip-cpu:1.0.0'

    input:
    path pic
    val prompts

    output:
    tuple stdout, path(pic)

    script:
    """
    classify.py --image $pic --labels '$prompts'
    """
}

process Resize {
    container 'robsyme/imagemagick:latest'

    input:
    tuple val(label), path("pics/*")

    output:
    tuple val(label), path("*.png")

    script:
    """
    mogrify -resize 100x100 -path . -format png pics/*
    """
}

process Collage {
    container 'robsyme/imagemagick:latest'

    input:
    tuple val(label), path("pics/*")

    output:
    path "collage.png"

    script:
    """
    montage pics/* -background black +polaroid -background '#ffbe76' collage_nolabel.png
    montage -label '$label' -geometry +0+0 -background "#f0932b" collage_nolabel.png collage.png
    """
}

process CombineImages {
    container 'robsyme/imagemagick:latest'
    publishDir params.outdir

    input:
    path "in.*.png"

    output:
    path "collage_all.png"

    script:
    """
    montage -geometry +10+10 -quality 05 -background "#ffbe76" -border 5 -bordercolor "#f0932b" in.*.png collage_all.png
    """
}
