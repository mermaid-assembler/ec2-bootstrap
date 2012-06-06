cd $HOME

cat <<'EOF' > $HOME/set_meraculous_env.sh
export ROOT=/home/ubuntu/Meraculous-1.4.4-rel
export PERL5LIB=${PERL5LIB}:${ROOT}/MERACULOUS:${ROOT}/mod_rqc/
export BOOST_DIR=/usr/include/boost
EOF

source $HOME/set_meraculous_env.sh

cat <<'EOF' >> $HOME/.bashrc
source $HOME/set_meraculous_env.sh
EOF

cat <<'EOF' >> $HOME/.ssh/config
Host fluffy
HostName fluffy.cs.berkeley.edu
User gitolite
UserKnownHostsFile=/dev/null
StrictHostKeyChecking=no
EOF
git clone https://github.com/mermaid-assembler/mermaid.git
cd mermaid-src
make
cd $HOME

wget ftp://ftp.jgi-psf.org/pub/JGI_data/meraculous/Meraculous-1.4.4-rel.tar
tar xf Meraculous-1.4.4-rel.tar
rm Meraculous-1.4.4-rel.tar

cd Meraculous-1.4.4-rel
cd MERACULOUS
sed -i s/5\.10/5.12/ build_swig
./build_swig
cd ..
cp -r start_files/ config

# Patch the gnuplot line in meraculous because we don't care about it enough to install gnuplot
cat <<'EOF' | patch start_files/meraculous.pl
2013,2017c2013,2017
<   if ( JGI_SUCCESS != run_sys_cmd( $pUserParams, "echo \"set terminal png; set output 'mercount.png'; set log y; plot [5:100] 'mercount.hist' using 2:7 with boxes\" | gnuplot", $pLog ) )
<   {
<       $pLog->error( "couldn't generate png" );
<       return JGI_FAILURE;
<   }
---
>   #if ( JGI_SUCCESS != run_sys_cmd( $pUserParams, "echo \"set terminal png; set output 'mercount.png'; set log y; plot [5:100] 'mercount.hist' using 2:7 with boxes\" | gnuplot", $pLog ) )
>   #{
>   #    $pLog->error( "couldn't generate png" );
>   #    return JGI_FAILURE;
>   #}
EOF

echo "Setup complete. Please complete setup by sourcing your .profile. Please \
remember to configure your Meraculous configuration files in \
$HOME/Meraculous-1.4.4-rel/config"
