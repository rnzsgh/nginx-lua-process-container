#!/bin/bash


curl -H "Content-Type: text/plain" -X POST -d 'public class Test { public static void main(final String [] pArgs) { System.out.println("Hello World!"); } }' http://localhost:8080


