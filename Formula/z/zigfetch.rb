class Zigfetch < Formula
  desc "Minimal neofetch/fastfetch like system information tool"
  homepage "https://github.com/utox39/zigfetch"
  url "https://github.com/utox39/zigfetch/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "84da4559072d3c6f37c5875b56359e37c098a8cc7972c9b0bb5d40b7761f5026"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "6557be875932651ede8510490341f731564dd985ed3b3486560795bcf7b6317b"
    sha256               arm64_sequoia: "60ddc8d7e0a9a47464924a9601b9df7444cae22c01ad994b65cda6d2893bd88e"
    sha256 cellar: :any, arm64_linux:   "37ba2d565306cefbe154cc86d26e01eed51ccf72d31ceb700af071e074edf64c"
    sha256 cellar: :any, x86_64_linux:  "ab397eaee0f1f248f2d5fbc339f6656f49796ff83b9fffb96fb5f77aa41c62bf"
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
