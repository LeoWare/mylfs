#!/bin/bash
rm -rvf /mnt/lfs/{bin,boot,etc,home,opt,var,tools/*}
# don't delete /mnt/lfs/usr/src
rm -rvf /mnt/lfs/usr/{lib,lib64,local,share,man}
