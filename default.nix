let

  githubTarball = owner: repo: rev:
    builtins.fetchTarball {
      url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    };

  reflexPlatform = import (githubTarball "reflex-frp" "reflex-platform" "develop") {};
  
in reflexPlatform.project ({ pkgs, ... }: {

  withHoogle = false;
  
  packages = {
    app = ./app;
  };

  shells = {
    ghc = [ "app" ];
    ghcjs = [ "app" ];
  };

  overrides = self: super:
    let
      toolkitSrc = githubTarball "aveltras" "reflex-toolkit" "master";
      # toolkitSrc = (pkgs.nix-gitignore.gitignoreSourcePure [ ./../reflex-toolkit/.gitignore ] ./../reflex-toolkit);
    in {
      reflex-datasource = self.callCabal2nix "reflex-datasource" "${toolkitSrc}/reflex-datasource" {};
      reflex-datasource-client = self.callCabal2nix "reflex-datasource-client" "${toolkitSrc}/reflex-datasource-client" {};
      reflex-datasource-server = self.callCabal2nix "reflex-datasource-server" "${toolkitSrc}/reflex-datasource-server" {};
      reflex-devserver = self.callCabal2nix "reflex-devserver" "${toolkitSrc}/reflex-devserver" {};
      reflex-route = self.callCabal2nix "reflex-route" "${toolkitSrc}/reflex-route" {};
      reflex-route-client = self.callCabal2nix "reflex-route-client" "${toolkitSrc}/reflex-route-client" {};
      reflex-route-server = self.callCabal2nix "reflex-route-server" "${toolkitSrc}/reflex-route-server" {};
    };
  
  shellToolOverrides = ghc: super: {
    ghcid = pkgs.haskell.lib.justStaticExecutables super.ghcid;
    haskell-ide-engine = null;
  };
  
})
