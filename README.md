---
marp: true
theme: gaia
class: lead
paginate: true
---

# JEP 515: AOT Method Profiling
Faster Startup in Java:
from **JEP 483: AOT Class Loading & Linking** to **JEP 515**

Andre Bedregal
Java User Group Peru

---

## The Problem: JVM Warmup

- Java apps take time to **warm up**
- Two main costs:
  - **Class loading** thousands of classes
  - **JIT compilation** waiting for profiles
- Every restart = a fresh start

---

## Solution Part 1: JEP 483 (Java 24)

### Ahead-of-Time Class Loading & Linking

- Records loaded/linked **classes**
- Saves info in an **AOT cache file**
- Next startup: reuses cache, avoids class loading contention

---

## Solution Part 2: JEP 515 (Java 25)

### Ahead-of-Time Method Profiling

- Records **JIT profiling data** (e.g., method counts, branch frequencies)
- On next startup:
  - JIT compiler has profile instantly
  - Generates optimized native code **immediately**

---

## Demo Workflow

1. Training run + Create cache
    ```sh
    java -XX:AOTCacheOutput=app.aot \
        -jar app.jar
    ```
2. Run with cache
    ```sh
    java -XX:AOTCache=app.aot \
        -jar app.jar
    ```
- Check details on [DEMO.md](DEMO.md) file.

---

## Final notes

- **JEP 483**: Great for raw startup, but minimal on large apps like Spring Boot.
- **JEP 515**: The real payoff. Reduces time to peak performance.
- Excellent for frequently restarted services.
- References:
  - https://openjdk.org/jeps/483 (Java 24)
  - https://openjdk.org/jeps/514 (Java 25)
  - https://openjdk.org/jeps/515 (Java 25)