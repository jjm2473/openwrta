#!/bin/bash

PRG_DIR=`dirname $0`
PRG_DIR=`sh -c "cd $PRG_DIR && pwd"`

if [ -d $PRG_DIR/overwrite ]; then
    tar -c -C $PRG_DIR/overwrite . | tar -x
    ./scripts/feeds update -ai
fi
