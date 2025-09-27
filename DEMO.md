# JEP 515: Ahead-of-Time Method Profiling

### Build the JAR
Compile the Java source and package it into a JAR file for easier execution.

```sh
javac HelloStream.java
jar cf HelloStream.jar HelloStream.class
```

### Run with no cache
Execute the application normally to see baseline performance.
The `-Xlog:class+load` flag shows which classes are being loaded.
```sh
java -Xlog:class+load -cp HelloStream.jar HelloStream
```

### Generate the cache
Create an AOT cache file that contains pre-compiled method profiles to speed up future runs.

Before JEP 514 (Java 25), two steps were required to generate the AOT Cache:
1. Training run - Records method usage patterns
```sh
java -XX:AOTMode=record -XX:AOTConfiguration=app.aotconf \
       -cp HelloStream.jar HelloStream
```

2. Create AOT Cache - Generates the cache file from recorded data
```sh
java -XX:AOTMode=create -XX:AOTConfiguration=app.aotconf \
       -XX:AOTCache=app.aot -cp HelloStream.jar
```

Now with JEP 514 (Java 25), the `AOTCacheOutput` option allows to create the AOT Cache file with just one step:
```sh
java -XX:AOTCacheOutput=app.aot -cp HelloStream.jar HelloStream
```

### Run with AOT Cache

Use the generated AOT cache to run the application with improved startup performance.
```sh
java -XX:AOTCache=app.aot -Xlog:class+load -cp HelloStream.jar HelloStream
```

### Benchmark
Compare startup times between cached and non-cached execution to measure performance improvements.

We will use the script [scripts/average_duration.sh](scripts/average_duration.sh) to run the command 'n' times and calculate the average duration.

Average duration with no cache
```sh
./scripts/average_duration.sh "java -cp HelloStream.jar HelloStream" 10
```

Output
```
Average: 51 ms
```

Average duration with cache
```sh
./scripts/average_duration.sh "java -XX:AOTCache=app.aot -cp HelloStream.jar HelloStream" 10
```

Output
```
Average: 34 ms
```