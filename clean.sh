#!/bin/bash
rm -rf /mnt/lfs/{bin,boot,etc,home,opt,var,tools/*}
# don't delete /mnt/lfs/usr/src
rm -rf /mnt/lfs/usr/{lib,lib64,share,man}
