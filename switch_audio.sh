#!/bin/bash

# Define the name of the sink
SINK_NAME="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink"

# Define the names of the ports
SPEAKER_PORT="[Out] Speaker"
HEADPHONES_PORT="[Out] Headphones"

CURRENT_PORT=$(pactl list sinks | grep -A 45 "${SINK_NAME}" | grep "Active Port" | cut -c 15-)

case ${CURRENT_PORT} in
  "${HEADPHONES_PORT}")
    pactl set-sink-port ${SINK_NAME} "${SPEAKER_PORT}" ;;
  "${SPEAKER_PORT}")
    pactl set-sink-port ${SINK_NAME} "$HEADPHONES_PORT" ;;
esac

