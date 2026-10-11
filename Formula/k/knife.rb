class Knife < Formula
  desc "Reverse engineering toolkit for PE, ELF, and Mach-O binaries"
  homepage "https://github.com/bl4ckr0ss3/knife"
  url "https://github.com/bl4ckr0ss3/knife/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "822e3f48a8d7986d0ae17bd47be183884ca414195ead205823d0825d826d6062"
  license "MIT"
  head "https://github.com/bl4ckr0ss3/knife.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a99f9a08953c1be40242313381955b3686b05d804b9731a9cc205db8936ee48c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8c74a7bc73c0cc26ad49adcf3b2a5372a75b9fb202604c03f105807d84bac9d"
    sha256 cellar: :any,                 arm64_linux:   "1420ccded5a41eeed2803301807167a439eb206c0e7c08760701aa4d7a11e32d"
    sha256 cellar: :any,                 x86_64_linux:  "3265364a424d5e22d067bfcd7511344b3afb08b72dc4915393567b07105a4c35"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"knife", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/knife --version")
    (testpath/"sample.bin").binwrite("\x00Homebrew sandbox test\x00")
    output = shell_output("#{bin}/knife strings --json #{testpath}/sample.bin")
    assert_equal ["Homebrew sandbox test"], JSON.parse(output)
  end
end
