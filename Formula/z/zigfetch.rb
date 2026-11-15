class Zigfetch < Formula
  desc "Minimal neofetch/fastfetch like system information tool"
  homepage "https://github.com/utox39/zigfetch"
  url "https://github.com/utox39/zigfetch/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "d70c964fbfa08bf1e777e0ccf7b689142a2e2d96830a770f8c4281538b1ca713"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "cc58b5972ddba97d1e1c9a3d5fad8d5a8315a1d6df5b4e7522665f20a3f9c74c"
    sha256               arm64_sequoia: "efc0294f00d2c25456513853977b1db89e6341b0d861db4a848b6906345a233d"
    sha256 cellar: :any, arm64_linux:   "c9cd751263f89c420f4433d7fda40b3a8759fc7409a6adbd4d9f84f2fd82f668"
    sha256 cellar: :any, x86_64_linux:  "1eb7e52ee00a367de581ccd6740ad49c284db1fd1fa6c46b21270e33112e6e1c"
  end

  depends_on "pkgconf" => :build
  depends_on "zig" => :build

  on_linux do
    depends_on "pciutils" # provides libpci.so and pci/pci.h
  end

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch"
  end

  def install
    # translate-c only links `pci` on the module, so expose its headers via Zig's native include paths
    ENV.append_path "C_INCLUDE_PATH", formula_opt_include("pciutils") if OS.linux?
    system "zig", "build", *std_zig_args(release_mode: :fast)
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    with_env(
      "LANG"         => "C.UTF-8",
      "SHELL"        => "/bin/bash",
      "TERM_PROGRAM" => "Homebrew",
      "USER"         => "brewtest",
    ) do
      if OS.mac?
        output = shell_output("#{bin}/zigfetch 2>&1 || true")
        assert_match(/brewtest|error: (EnvironmentVariableMissing|NotAppleARMIODevice)/, output)
      else
        output = shell_output(bin/"zigfetch")
        assert_match "brewtest", output
        assert_match "Shell:\e[0m bash", output
        assert_match "Terminal:\e[0m Homebrew", output
      end
    end

    # rchen@rchen
    # -----------
    # OS: macOS 15.7
    # Kernel: Darwin 24.6.0
    # Uptime: 27 days, 0 hours, 41 minutes
    # Packages: brew: 334 brew-cask: 26
    # Shell: fish, version 4.1.2
    # Cpu: Apple M4 Pro (12) @ 4.51 GHz
    # Gpu: Apple M4 Pro (16) @ 1.58 GHz
    # Ram: 40.69 / 48.00 GiB (84%)
    # Swap: 8.97 / 10.00 GiB (89%)
    # Disk (/): 393.29 / 494.38 GB (79%)
    # Local IP (en0): 10.0.0.153
    # Local IP (utun0): 172.16.0.2
    # WM: Rectangle
    # Terminal: iTerm.app
    # Locale: en_US.UTF-8
  end
end
