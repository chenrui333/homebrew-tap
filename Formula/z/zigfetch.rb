class Zigfetch < Formula
  desc "Minimal neofetch/fastfetch like system information tool"
  homepage "https://github.com/utox39/zigfetch"
  url "https://github.com/utox39/zigfetch/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "6be9c242e4ab205d6ea8ead589b61bd15c116d58ab3024b2870b49300f220205"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "54869c5d13e961b526303784e7f5b33cd5ba31a3d23ffdffe11293764d564c00"
    sha256               arm64_sequoia: "ac2b5e3d15e0d245aae7e49abd116c93e96f180c28e6047373f93071e27e59a6"
    sha256 cellar: :any, arm64_linux:   "74ae4a515dcdbdfec9ff2521c668bfa401dbe441373fec5d880723ac46c3278a"
    sha256 cellar: :any, x86_64_linux:  "6a325bb014960880219b8ce346591340bdcf88e0316e77f16e95f08d0b26adf0"
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
