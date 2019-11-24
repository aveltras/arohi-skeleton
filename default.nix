let

  githubTarball = owner: repo: rev:
    builtins.fetchTarball {
      url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    };

  latestPkgs = import (githubTarball "NixOS" "nixpkgs" "master") {};
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
      arohiSrc = githubTarball "aveltras" "arohi" "master";
    in {
      arohi-datasource = self.callCabal2nix "arohi-datasource" "${arohiSrc}/arohi-datasource" {};
      arohi-datasource-client = self.callCabal2nix "arohi-datasource-client" "${arohiSrc}/arohi-datasource-client" {};
      arohi-datasource-server = self.callCabal2nix "arohi-datasource-server" "${arohiSrc}/arohi-datasource-server" {};
      arohi-server = self.callCabal2nix "arohi-server" "${arohiSrc}/arohi-server" {};
      arohi-route = self.callCabal2nix "arohi-route" "${arohiSrc}/arohi-route" {};
      arohi-route-client = self.callCabal2nix "arohi-route-client" "${arohiSrc}/arohi-route-client" {};
      arohi-route-server = self.callCabal2nix "arohi-route-server" "${arohiSrc}/arohi-route-server" {};
    };
  
  shellToolOverrides = ghc: super: {
    ghcid = pkgs.haskell.lib.justStaticExecutables super.ghcid;
    haskell-ide-engine = null;
    yarn = latestPkgs.yarn;
  };
  
})
