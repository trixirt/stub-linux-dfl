#!/bin/sh
depmod -A

udevadm control --reload-rules
for device_id in  0x0b2b 0x09c4 0x0b30; do
    udevadm trigger --attr-match=vendor=0x8086 --attr-match=device="$device_id"
done