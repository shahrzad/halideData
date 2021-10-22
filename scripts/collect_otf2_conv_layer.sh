#!/bin/bash

halide_expr_dir="$HOME/src/halide-tutorials/experiments"
results_dir="$WORK/repos/halideData/OTF2"

source "$WORK/repos/halideData/spack/gcc.sh"

thr=(8 16 40)

for th in "${thr[@]}"
do
	work_dir="${results_dir}/conv_layer/halide/${th}_threads/"
	mkdir -p ${work_dir}/OTF2_archive
	rm -r ${work_dir}/*
	touch "${work_dir}/apex_output.txt"
	date>>"${work_dir}/date.txt"
	
	#halide
	cd "${halide_expr_dir}/conv_layer/build/"
	HL_NUM_THREADS=${th} APEX_OTF2_ARCHIVE_PATH="${work_dir}/OTF2_archive"  ~/lib/apex_nompi/bin/apex_exec --apex:pthread --apex:otf2 ./conv_layer_process_halide>>"${work_dir}/apex_output.txt"
	echo "conv_layer halide ${th} threads done!"

	#hpx
	work_dir="${results_dir}/conv_layer/hpx/${th}_threads/"
	mkdir -p ${work_dir}/OTF2_archive
	rm -r ${work_dir}/*
	touch "${work_dir}/apex_output.txt"
	date>>"${work_dir}/date.txt"
	
	APEX_OTF2_ARCHIVE_PATH="${work_dir}/OTF2_archive" APEX_OTF2=1 APEX_SCREEN_OUTPUT=1 ./conv_layer_process_hpx --hpx:threads=${th}>>"${work_dir}/apex_output.txt"
        echo "conv_layer hpx ${th} threads done!"

done	
