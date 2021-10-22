#!/bin/bash

halide_expr_dir="$HOME/src/halide-tutorials/experiments"
results_dir="$WORK/repos/halideData/OTF2"

source "$WORK/repos/halideData/spack/gcc.sh"

thr=(8 16 40)

for th in "${thr[@]}"
do
	work_dir="${results_dir}/nl_means/halide/${th}_threads/"
	mkdir -p ${work_dir}/OTF2_archive
	rm -r ${work_dir}/*
	touch "${work_dir}/apex_output.txt"
	date>>"${work_dir}/date.txt"
	
	#halide
	cd "${halide_expr_dir}/nl_means/build/"
	HL_NUM_THREADS=${th} APEX_OTF2_ARCHIVE_PATH="${work_dir}/OTF2_archive"  ~/lib/apex_nompi/bin/apex_exec --apex:pthread --apex:otf2 ./nl_means_process_halide ${halide_expr_dir}/nl_means/images/rgb.png 7 7 0.12 10 result_halide.png>>"${work_dir}/apex_output.txt"
	echo "nl_means halide ${th} threads done!"

	#hpx
	work_dir="${results_dir}/nl_means/hpx/${th}_threads/"
	mkdir -p ${work_dir}/OTF2_archive
	rm -r ${work_dir}/*
	touch "${work_dir}/apex_output.txt"
	date>>"${work_dir}/date.txt"
	
	APEX_OTF2_ARCHIVE_PATH="${work_dir}/OTF2_archive" APEX_OTF2=1 APEX_SCREEN_OUTPUT=1 ./nl_means_process_hpx ${halide_expr_dir}/nl_means/images/rgb.png 7 7 0.12 10 result_hpx.png --hpx:threads=${th}>>"${work_dir}/apex_output.txt"
        echo "nl_means hpx ${th} threads done!"

done	
