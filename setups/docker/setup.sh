#!/usr/bin/bash

packages=( pm:docker )

links=()

for f in docker-gc.timer docker-gc.service; do
    links+=( "${ADM_DIR}/${f}" ~/.config/systemd/user/"${f}" )
done

st_rc() {
    alias docker_clean_images='docker rmi $(docker images -a --filter=dangling=true -q)'
    alias docker_clean_ps='docker rm $(docker ps --filter=status=exited --filter=status=created -q)'
    function docker-last() {
        docker ps --latest --quiet
    }
}

st_install() {
    md5sumv() { md5sum "$@" | cut -d ' ' -f 1; }

    # see https://wiki.archlinux.org/index.php/Docker#Storage_driver
    local override='override.conf'
    local dir='/etc/systemd/system/docker.service.d'

    if [ ! -e "${dir}/${override}" ]; then
        sudo mkdir --parents /etc/systemd/system/docker.service.d/
        sudo install --mode=a=r,u+w "${ADM_DIR}/${override}" "${dir}"
        sudo systemctl daemon-reload

    elif [ "$(md5sumv "${dir}/${override}")" != "$(md5sumv "${ADM_DIR}/${override}")" ]; then
        warn docker/setup.sh: "${dir}/${override}" already exists skipping installation of "${override}"
    fi

    sudo usermod -aG docker "$USER"
    systemctl --user daemon-reload
    systemctl --user enable --now docker-gc.timer
}
