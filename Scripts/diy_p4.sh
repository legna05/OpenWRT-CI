#!/bin/bash

# 获取脚本所在目录的上一级目录
PARENT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
echo "PARENT_DIR=$PARENT_DIR"

# overlay/ holds files added to the tree verbatim (new kernel or package
# patches); patches/tree/ changes files the tree already has.
if [ -d "$PARENT_DIR/sbe1v1k/overlay" ]; then
	log "copying overlay"
	cp -a "$PARENT_DIR/sbe1v1k/overlay/." "$PARENT_DIR/wrt"
	(cd "$PARENT_DIR/sbe1v1k/overlay" && find . -type f | sed 's#^\./#    #' | sort)
fi

log "applying tree patches"
cd "$PARENT_DIR/wrt"
for p in "$PARENT_DIR/sbe1v1k"/patches/tree/*.patch; do
	[ -e "$p" ] || continue
	git apply --check "$p" || die "does not apply: $(basename "$p")"
	git apply "$p"
	echo "apply for   :   $(basename "$p")"
done
cd -

# ath12k patches are applied by the mac80211 package build itself.
for p in "$PARENT_DIR/sbe1v1k"/patches/mac80211/*.patch; do
	[ -e "$p" ] || continue
	cp "$p" "$PARENT_DIR/wrt"/package/kernel/mac80211/patches/ath12k/
	echo "move patch mac80211   :   $(basename "$p")"
done
