#!/bin/bash

halide_expr_dir="$HOME/src/halide-tutorials/experiments"
results_dir="$WORK/repos/halideData/OTF2"

source "$WORK/repos/halideData/spack/gcc.sh"

thr=(8 16 40)

for th in "${thr[@]}"
do
	work_dir="${results_dir}/iir_blur/halide/${th}_threads/"
	mkdir -p ${work_dir}/OTF2_archive
	rm -r ${work_dir}/*
	touch "${work_dir}/apex_output.txt"
	date>>"${work_dir}/date.txt"
	
	#halide
	cd "${halide_expr_dir}/iir_blur/build/"
	HL_NUM_THREADS=${th} APEX_OTF2_ARCHIVE_PATH="${work_dir}/OTF2_archive"  ~/lib/apex_nompi/bin/apex_exec --apex:pthread --apex:otf2 ./iir_blur_filter_halide ${halide_expr_dir}/iir_blur/images/rgb.png result_halide.png>>"${work_dir}/apex_output.txt"
	echo "iir_blur halide ${th} threads done!"

	#hpx
	work_dir="${results_dir}/iir_blur/hpx/${th}_threads/"
	mkdir -p ${work_dir}/OTF2_archive
	rm -r ${work_dir}/*
	touch "${work_dir}/apex_output.txt"
	date>>"${work_dir}/date.txt"
	
	APEX_OTF2_ARCHIVE_PATH="${work_dir}/OTF2_archive" APEX_OTF2=1 APEX_SCREEN_OUTPUT=1 ./iir_blur_filter_hpx ${halide_expr_dir}/iir_blur/images/rgb.png result_hpx.png --hpx:threads=${th}>>"${work_dir}/apex_output.txt"
        echo "iir_blur hpx ${th} threads done!"

done	
