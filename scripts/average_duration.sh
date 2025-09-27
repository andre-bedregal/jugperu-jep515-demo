#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 \"<command>\" <number_of_runs>"
    exit 1
fi

CMD="$1"
RUNS="$2"
durations=()

for ((i=1; i<=RUNS; i++)); do
    start_time=$(date +%s%N)
    eval $CMD
    end_time=$(date +%s%N)
    duration_ns=$((end_time - start_time))
    duration_ms=$((duration_ns / 1000000))
    durations+=($duration_ms)
    echo "Run $i: $duration_ms ms"
done

min=${durations[0]}
max=${durations[0]}
sum=0

for d in "${durations[@]}"; do
    (( d < min )) && min=$d
    (( d > max )) && max=$d
    sum=$((sum + d))
done

avg=$((sum / RUNS))

echo "All durations (ms): ${durations[@]}"
echo "Min: $min ms"
echo "Max: $max ms"
echo "Average: $avg ms"