class Zigfetch < Formula
  desc "Minimal neofetch/fastfetch like system information tool"
  homepage "https://github.com/utox39/zigfetch"
  url "https://github.com/utox39/zigfetch/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "8568efea2ec305513124978bbaf6db82b2293e9a0f8952d0d36a786bab57f90b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "f350357197e7b5129d305203db85579e6cde260c92b0d1d70e2ec6f244a9ce57"
    sha256                               arm64_sequoia: "6daba33c3936c0309fb1aef6129991772405af50d55b397bc6d76f395c445a3f"
    sha256                               arm64_sonoma:  "c26a958311dc28d8f9bb72dc37d84093cc71e922f8a6a84226af382ae5353f83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "372ce40b114b03416da9e75cda968f4f6f58f27590af711a352f4579ecde82d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00db95c426a351626498f0c7f5cf39bc5f43b13244e25995eb9038e39a635a63"
  end

  depends_on "pkgconf" => :build
  depends_on "zig" => :build

  on_linux do
    depends_on "pciutils" # provides libpci.so and pci/pci.h
  end

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    zig = "zig"
    system zig, "build", *args, *std_zig_args(release_mode: :fast)
  end

  test do
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
