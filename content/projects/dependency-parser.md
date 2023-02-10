---
title: "Maven Dependency Parser"
date: 2023-02-10T13:59:22+05:30
draft: false
---


A maven dependency tree parser to check for all the included dependencies in a maven project.

# Usage

1. Build a dependency tree of a maven project with `mvn dependency:tree -DoutputFile=<path-to-file>`. See details on maven dependency plugin page http://maven.apache.org/plugins/maven-dependency-plugin/usage.html#dependency:tree
2. Run script as 
    ```bash
   python dependency_parser.py -f test.txt --dependency "<dependency_name>"
    ```

# How the script works
Since it is evident that mvn dependency:tree creates a dependency tree, the `dependency_parser` parses the file and creates a tree and finds all the ancestors.
An important part is [dependency sanitization](https://github.com/AnshumanTripathi/maven-dependency-parser/blob/6233094a9fca0152cbd5db029865c26a02510c92/dependency_parser.py#L124-L130), to cleanup tokens like `+-` and `-`.
The `+-` token means the dependency has children and the `-` means the dependency is the leaf child of the tree.
