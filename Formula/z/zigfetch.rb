class Zigfetch < Formula
  desc "Minimal neofetch/fastfetch like system information tool"
  homepage "https://github.com/utox39/zigfetch"
  url "https://github.com/utox39/zigfetch/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "77b6df2cefc50c67290f6a5af139aedbe2fe82c966751e278a056f3ff70077c2"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "57e8679075bf5663a72b1a46c29a91f3b22cb407cb201a598719639f0768fb0a"
    sha256                               arm64_sequoia: "e3c4ad1022f3c0d16b12a6c9058418ea9cc866146d0917a8f76ac867621901b3"
    sha256                               arm64_sonoma:  "cfe67c1104d2fae8c27fd5223868c1414d369a9cee97ebde15dbc1867464168b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f1ceb6dc2c771b46befc3a3a4b76eac6f58d2763ae5d344d3f2844f209656f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e57c021c9b747e09e373f1a844c9c9a169dda5be562e9d432422dda85afd36bd"
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
