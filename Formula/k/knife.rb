class Knife < Formula
  desc "Reverse engineering toolkit for PE, ELF, and Mach-O binaries"
  homepage "https://github.com/bl4ckr0ss3/knife"
  url "https://github.com/bl4ckr0ss3/knife/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "007d24459d958cff453dd6fe78923635ac1d65e1cd1203341801e38fc0980928"
  license "MIT"
  head "https://github.com/bl4ckr0ss3/knife.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9c7e3b0e1ac913410e438e8981de2f3ee527ff3fe3701de3518de9384651ce5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad04c805972c6e2ffcbe066285ae6c55570fe977f938bee27d73acdc795c06dc"
    sha256 cellar: :any,                 arm64_linux:   "c3533e9e9b7301e6a2ad625feb828f1f265908e54c2b6b8ffe8ebd7e13b29b61"
    sha256 cellar: :any,                 x86_64_linux:  "a47b92b131ee193ab00754caecc983ff0c7ba2474e930307aec2779378ecdf7f"
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
