class Zigfetch < Formula
  desc "Minimal neofetch/fastfetch like system information tool"
  homepage "https://github.com/utox39/zigfetch"
  url "https://github.com/utox39/zigfetch/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "d836b2b0de9d0544568093250683ca6344082f335c6e0a2fc7e86d3d140b1f7c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "5c16c38c31bce2247d750722fcdb39f50dcaa1564098917324e3d9fddcd34b71"
    sha256                               arm64_sequoia: "6baeb1ada1524f7d91a6bf810bcf158ad21432f7e202a584e1df5bbdd8b6458d"
    sha256                               arm64_sonoma:  "83556e2c0a86d599bd3b4cd813370f98f380c8826ef4b2a48d609c8a9d56b7e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ed1fba7db9b8a9c9f1220dc59932a6cac2997126c6163ba12b20fc14c428ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14f45a7765bec3739c10475ab2826aea93925f3244c3a5fd978b465a5b6c459e"
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

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseFast
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args
  end

  test do
    if OS.mac?
      expected_error = "error: NotAppleARMIODevice"
      assert_match expected_error, shell_output("#{bin}/zigfetch 2>&1", 1)
    else
      assert_match "Shell:\e[0m bash", shell_output(bin/"zigfetch")
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
