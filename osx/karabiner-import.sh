#!/bin/sh

cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner

$cli set remap.holdcommandQ 1
/bin/echo -n .
$cli set repeat.initial_wait 200
/bin/echo -n .
$cli set parameter.keyoverlaidmodifier_timeout 300
/bin/echo -n .
$cli set private.ctrl_to_hyper 1
/bin/echo -n .
$cli set private.vi_arrows 1
/bin/echo -n .
$cli set bilalh.remap.f19_escape_control 1
/bin/echo -n .
/bin/echo
