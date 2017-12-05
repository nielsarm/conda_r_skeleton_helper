#!/bin/bash

mkdir -p tmp
for fn in `cat packages.txt`; do
    conda skeleton cran $fn
    cp $fn/meta.yaml tmp/$fn.meta.yaml
    sed -i.bak '/^\s*#.*$/ d' $fn/meta.yaml
    sed -i.bak '/^mv\s.*$/ d' $fn/build.sh
    sed -i.bak '/^grep\s.*$/ d' $fn/build.sh
    sed -i.bak '/^#\s.*$/ d' $fn/build.sh
    sed -i.bak '/^@.*$/ d' $fn/bld.bat
    sed -i.bak '/^$/{N;/^\n$/d;}' $fn/meta.yaml
    sed -i.bak '/^$/{N;/^\n$/d;}' $fn/build.sh
    sed -i.bak 's/ [+|] file LICEN[SC]E//' $fn/meta.yaml
    sed  -i.bak 's/{indent}/\n    - /' $fn/meta.yaml
    # skip win builds
    sed -i.bak 's/number: 0/number: 0\n  skip: true  # [win32]/g' $fn/meta.yaml

    # Add GPL-3
    sed -i.bak s/"  license_family: GPL3"/"  license_family: GPL3\n  license_file: '{{ environ[\"PREFIX\"] }}\/lib\/R\/share\/licenses\/GPL-3'  # [unix]\n  license_file: '{{ environ[\"PREFIX\"] }}\\\R\\\share\\\licenses\\\GPL-3'  # [win]"/ $fn/meta.yaml
    # Add GPL-2
    sed -i.bak s/"  license_family: GPL2"/"  license_family: GPL2\n  license_file: '{{ environ[\"PREFIX\"] }}\/lib\/R\/share\/licenses\/GPL-2'  # [unix]\n  license_file: '{{ environ[\"PREFIX\"] }}\\\R\\\share\\\licenses\\\GPL-2'  # [win]"/ $fn/meta.yaml

    sed -i.bak -e ':a' -e '/^\n*$/{$d;N;};/\n$/ba' $fn/bld.bat
    sed -i.bak -e ':a' -e '/^\n*$/{$d;N;};/\n$/ba' $fn/meta.yaml
    sed -i.bak -e ':a' -e '/^\n*$/{$d;N;};/\n$/ba' $fn/build.sh
    cat extra.yaml >> $fn/meta.yaml
    gedit $fn/meta.yaml
    diff -u $fn/meta.yaml tmp/$fn.meta.yaml > tmp/$fn.meta.diff
done


grep license tmp/*.meta.diff
