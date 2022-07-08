#!/bin/bash


rm -f input_perc_access_DRAM_and_PMEM.csv 
rm -f input_exec_time.csv 
rm -f input_touches_per_pages.csv

APP_DATASET=("bc_kron" "bc_urand" "bfs_kron" "bfs_urand" "cc_kron" "cc_urand")

for ((j = 0; j < ${#APP_DATASET[@]}; j++)); do
  #-------------------------------------------------------------------------------------------------------------------
  dram=$(grep RAM ${APP_DATASET[$j]}/autonuma/perc_access_pmem_dram_${APP_DATASET[$j]}.csv | awk -F, '{print $2}')
  pmem=$(grep PMEM ${APP_DATASET[$j]}/autonuma/perc_access_pmem_dram_${APP_DATASET[$j]}.csv | awk -F, '{print $2}')

	echo ${APP_DATASET[$j]},$dram,$pmem >> input_perc_access_DRAM_and_PMEM.csv
  
  #-------------------------------------------------------------------------------------------------------------------
  start=$(sed -n 2p ${APP_DATASET[$j]}/autonuma/track_info_${APP_DATASET[$j]}.csv | awk -F, '{print $1}')
	end=$(tail -n 1 ${APP_DATASET[$j]}/autonuma/track_info_${APP_DATASET[$j]}.csv | awk -F, '{print $1}')
	exec_time_autonuma=$(echo $start $end | awk '{print ($2-$1)/60}')

	start=$(sed -n 2p ${APP_DATASET[$j]}/static_mapping/track_info_${APP_DATASET[$j]}.csv | awk -F, '{print $1}')
	end=$(tail -n 1 ${APP_DATASET[$j]}/static_mapping/track_info_${APP_DATASET[$j]}.csv | awk -F, '{print $1}')
	exec_time_static_mapping=$(echo $start $end | awk '{print ($2-$1)/60}')

	echo -n ${APP_DATASET[$j]},$exec_time_autonuma,$exec_time_static_mapping, >> input_exec_time.csv
	echo $exec_time_static_mapping $exec_time_autonuma | awk '{print (1-($1/$2))*100}' >> input_exec_time.csv
  
  #-------------------------------------------------------------------------------------------------------------------
  one_touch=$(grep "1 touch" ${APP_DATASET[$j]}/autonuma/df_touch_per_page_${APP_DATASET[$j]}.csv | awk -F, '{print $2}')
  two_touches=$(grep "2 touches" ${APP_DATASET[$j]}/autonuma/df_touch_per_page_${APP_DATASET[$j]}.csv | awk -F, '{print $2}')

	echo ${APP_DATASET[$j]},$one_touch,$two_touches >> input_touches_per_pages.csv
  
  #-------------------------------------------------------------------------------------------------------------------
done
