starship init fish | source

#export DISPLAY=(ip route list default | awk '{print $3}'):0
#export LIBGL_ALWAYS_INDIRECT=1
export KAPTIS="$HOME/development/kaptis"
set DOCKER_NOT_RUNNING (ps aux | grep dockerd | grep -v grep)
if test -z "$DOCKER_NOT_RUNNING"
	sudo dockerd > /dev/null 2>&1 & disown
end

# Load SSH KEYS
if not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c) > /dev/null
		if not ssh-add -l | grep -q "github_lhasa"
				ssh-add ~/.ssh/github_lhasa > /dev/null
		end
end


alias ls="exa"
alias gs="git status"
alias ll="ls -la"
alias ..="cd .."
alias weather="curl wttr.in/south%20shields"
alias notes="cd /mnt/c/Users/Dave.Potts/OneDrive/Notes; nvim ."
alias kap-be="cd $KAPTIS/backend; mvn spring-boot:run -Dspring-boot.run.profiles=local"
alias kap-fe="cd $KAPTIS/frontend; npm run start"
alias kap-e2e="cd $KAPTIS; mvn clean test -pl :e2e-test -am -fae -DexcludedGroups=AopWiki,Ichs1,FrontendServices -Dskip.api.tests=true -Dskip.backend.tests=true"
alias s1-be="cd $KAPTIS/ichs1-backend; mvn spring-boot:run -Dspring-boot.run.profiles=local"
alias s1-fe="cd $KAPTIS/frontend; npm run start:ichs1"
alias s1-e2e="cd $KAPTIS; mvn clean test -pl :e2e-test -am -fae -Dgroups=Ichs1"
alias home-fe="cd $KAPTIS/frontend; npm run start:kaptis-home"
alias home-be="cd $KAPTIS/home-backend; mvn spring-boot:run -Dspring-boot.run.profiles=local"
alias skin-fe="cd $KAPTIS/frontend; npm run start:skin"
alias skin-be="cd $KAPTIS/skin-backend; mvn spring-boot:run -Dspring-boot.run.profiles=local"
alias carc-fe="cd $KAPTIS/frontend; npm run start:carc"
alias carc-be="cd $KAPTIS/ichs1-backend; mvn spring-boot:run -Dspring-boot.run.profiles=local"
alias kc-rebuild="cd ~/development/keycloak/test-harness/docker; docker compose down -v; cd ~/development/keycloak/docker; docker build -t keycloak-test-harness .; cd ~/development/keycloak/test-harness/docker;  docker compose up -d; docker logs docker-keycloak-1 -f"
alias nvimrc="nvim $HOME/.config/nvim"
alias fishrc="nvim $HOME/.config/fish/config.fish"

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
