#!/usr/bin/env nextflow

params.input = "${projectDir}/data/*.png"
params.prompts = "a photo of a cat,a photo of a dog"

workflow {
    pics = Channel.fromPath(params.input)

    Classify(pics, params.prompts)
    | map { label, pic -> [label.text, pic] }
    | groupTuple
    | Collage
    | view
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
    container 'robsyme/imagemagick:latest'

    input:
    tuple val(label), path("pics/*")

    output:
    tuple val(label), path("montage.png")

    script:
    """
    montage -geometry 80 -tile 4x pics/* tmp.png
    montage -label '$label' tmp.png -geometry +0+0 -background Gold montage.png
    """
}   

