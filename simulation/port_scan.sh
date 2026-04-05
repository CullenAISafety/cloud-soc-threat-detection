#!/bin/bash

TARGET=$1

echo "Running Nmap scan..."

nmap -sS -A $TARGET
