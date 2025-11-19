#!/bin/bash

set -e

nh firmware publish _build/soleil_rpi0_2_dev/nerves/images/soleil_demo.fw --product soleil_demo --org Underjord --key soleil
