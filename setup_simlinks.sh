if [ -e "$1" ]; then
    echo "Enter the path to setup the simlinks"
fi

OUTDIR="$1"
INDIR="$(pwd)"

ln -s $INDIR/.vimrc $OUTDIR
ln -s $INDIR/.vim $OUTDIR

ln -s $INDIR/.tmux.conf $OUTDIR

ln -s $INDIR/.zshrc $OUTDIR
ln -s $INDIR/.zsh $OUTDIR
ln -s $INDIR/.bashrc $OUTDIR

ln -s $INDIR/.vimperator $OUTDIR
ln -s $INDIR/.vimperatorrc $OUTDIR

ln -s $INDIR/bin $OUTDIR

