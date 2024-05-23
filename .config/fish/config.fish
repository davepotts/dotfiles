
export KAPTIS="$HOME/development/kaptis"
export NODE_OPTIONS="--max-old-space-size=8192"
export AWS_PROFILE="KaptisDev"
export SPRING_PROFILES_ACTIVE="local"

if test "$(uname -n)" = 'XPS17'
    export AWS_PROFILE="Screach"
end

alias ls="exa"
alias gs="git status"
alias ll="ls -la"
alias ..="cd .."
alias nvimrc="nvim $HOME/.config/nvim"
alias fishrc="nvim $HOME/.config/fish/config.fish"
alias tmuxrc="nvim $HOME/.config/tmux/tmux.conf"
alias weather="curl wttr.in/south%20shields"
alias notes="cd /mnt/c/Users/Dave.Potts/OneDrive/Notes; nvim"
alias know-be="cd $KAPTIS/aop-knowledge-backend; mvn spring-boot:run -Dspring-boot.run.profiles=local"
alias know-fe="cd $KAPTIS/frontend; npm run start"
alias know-e2e="cd $KAPTIS; mvn clean test -pl :e2e-test -am -fae -Dgroups=AopKbEditor -Dskip.api.tests=true -Dskip.backend.tests=true"
alias asmt-be="cd $KAPTIS/assessments-backend; mvn spring-boot:run -Dspring-boot.run.profiles=local"
alias asmt-fe="cd $KAPTIS/frontend; npm run start:assessments"
alias asmt-e2e="cd $KAPTIS; mvn clean test -pl :e2e-test -am -fae -Dgroups=Carc -DtrimStachTrace=false -Dskip.api.tests.true -Dskip.backend.tests=true "
alias home-fe="cd $KAPTIS/frontend; npm run start:kaptis-home"
alias home-e2e="cd $KAPTIS; mvn clean test -pl :e2e-test -am -fae -Dgroups=Home"
alias skin-fe="cd $KAPTIS/frontend; npm run start:skin"
alias skin-e2e="cd $KAPTIS; mvn clean test -pl :e2e-test -am -fae -Dgroups=SkinDa"
alias s1-fe="cd $KAPTIS/frontend; npm run start:ichs1"
alias s1-e2e="cd $KAPTIS; mvn clean test -pl :e2e-test -am -fae -Dgroups=Ichs1"
alias kc-rebuild="cd ~/development/keycloak/test-harness/docker; docker compose down -v; cd ~/development/keycloak/docker; docker build -t keycloak-test-harness .; cd ~/development/keycloak/test-harness/docker;  docker compose up -d; docker logs docker-keycloak-1 -f"
alias nvim_build="cd /opt/neovim; sudo make CMAKE_BUILD_TYPE=RelWithDebInfo; sudo make install"
alias screachca="aws codeartifact login --tool npm --repository screach-npm --domain screach --domain-owner 861532443756 --region eu-west-1"

function move-tag
	git push origin :refs/tags/$argv[1] && git tag -d $argv[1] || true && git tag -a $argv[1] -m "$argv[2]" && git push origin $argv[1]
end

function sys-up
    set DIR (pwd)
    cd $KAPTIS/compose/dev
    docker compose up -d
    cd $DIR
end
function sys-down
    set DIR (pwd)
    cd $KAPTIS/compose/dev
    docker compose down
    cd $DIR
end

function sys-kill
    set DIR (pwd)
    cd $KAPTIS/compose/dev
    docker compose down -v
    cd $DIR
end

function kapcom
    set DIR (pwd)
    cd $KAPTIS/kaptis-common/
	mvn clean install
    cd $DIR
end

function github
    if not set -q SSH_AUTH_SOCK
        eval (ssh-agent -c) >/dev/null
        if not ssh-add -l | grep -q github_lhasa
            ssh-add ~/.ssh/github_lhasa >/dev/null
        end
    end
end

starship init fish | source
zoxide init --cmd cd fish | source
