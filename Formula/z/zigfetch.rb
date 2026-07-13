class Zigfetch < Formula
  desc "Minimal neofetch/fastfetch like system information tool"
  homepage "https://github.com/utox39/zigfetch"
  url "https://github.com/utox39/zigfetch/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "b60567ea9011fcafe71c0756257cda76285eb25cdefb1800e29108e93638da74"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "fbea921de8575ce034f5b741dee6c33854a245725421ab8c4e62078a4ae3d2fd"
    sha256               arm64_sequoia: "1d7dca5c2c0b7c3d5bb22c62893f30b14f012ca3669d66848cd15a2aa52fd263"
    sha256               arm64_sonoma:  "ddb5e048407b17a760df9f50e2aa2988580d7f24de6df0b019ed512ada2d80ca"
    sha256 cellar: :any, arm64_linux:   "2b496bf855875fb8b0396e99d8af8702faa24ff2df50aca2eaeb89066b32fa68"
    sha256 cellar: :any, x86_64_linux:  "440207a10708e4c3f279825ad7f644f7e322ff66efa28374313e3d3893e2492a"
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
