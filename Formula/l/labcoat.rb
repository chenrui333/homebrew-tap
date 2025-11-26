class Labcoat < Formula
  desc "NixOS system deployment TUI"
  homepage "https://github.com/jhillyerd/labcoat"
  url "https://github.com/jhillyerd/labcoat/archive/50b552e94be25c2cd60f854ae02f3d69f6f9142c.tar.gz"
  version "0.0.1"
  sha256 "060eb4b951dfe358a6512ef1caeb08e902afa3dffe67f2536b9e2b904750400d"
  license "MIT"
  head "https://github.com/jhillyerd/labcoat.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match <<~EOS, shell_output("#{bin}/labcoat -defaults")
      # labcoat default configuration, only needed if you wish to make changes.

      [general]
      pager = 'less'

      [commands]
      # List of commands to run to display host status
      status-cmds = ['uptime', 'uname -a', 'nixos-rebuild --no-build-nix list-generations', 'systemctl --failed', 'df -h -x tmpfs -x overlay']

      # Host deployment configuration. Nix attrs typically start with 'flake' or 'target'.
      [hosts]
      # Appended after '.' to bare hostnames
      default-ssh-domain = ''
      default-ssh-user = 'root'
      # Nix attr path for SSH deploy target hostname
      deploy-host-attr = 'target.config.networking.fqdnOrHostName'
      deploy-user-attr = ''

      [nix]
      # Default [user@]host to run Nix builds on
      default-build-host = 'localhost'
    EOS
  end
end
