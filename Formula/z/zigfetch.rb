class Zigfetch < Formula
  desc "Minimal neofetch/fastfetch like system information tool"
  homepage "https://github.com/utox39/zigfetch"
  url "https://github.com/utox39/zigfetch/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "bf726b21b3d0db84b23ece8fe5e262add77b4e5bca61f32783570d99dc788c35"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "12f9191a6ba166fd6615a42aaea29a3526d8d1ae7fe7dbcc33bf571995b2effb"
    sha256               arm64_sequoia: "c5f39ed16118b69ddc4b61e8691894269f2c0ec0d9394dc6e9c1914fcb4706bb"
    sha256               arm64_sonoma:  "23f07780fb31fd241adfd986ad24e992824787b8d19ebd764e490fbb3af68870"
    sha256 cellar: :any, arm64_linux:   "35f1ade344034af14a60e03a0eaf3fed4cd674e38ff0a91d58c443d1b182f18d"
    sha256 cellar: :any, x86_64_linux:  "3c72fb9740a081c46e848decc2d3872ad98c55fece85ac12a084d490a795d0df"
  end

  depends_on "pkgconf" => :build
  depends_on "zig" => :build

  on_linux do
    depends_on "pciutils" # provides libpci.so and pci/pci.h
  end

  def install
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
