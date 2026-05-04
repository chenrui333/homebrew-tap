class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "97c4d0f5a3f88e0ea5612de76dc0da1777b6df4eb6b517537c4cd974479caeec"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5ac900ade5b12c1d968711047284deeb00cabad2f02ec6a0973eef69202e5c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e40b8cc2768867d77ea81bca3d2c54f8d37c9215a94e48d6cbde6e3c6e84c7d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd55695b2079373317a90be5ee4d8cf1cbe3654fdab275b14c924aac36cf7fc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4fcf5715ac081e09a36a62379a9d27e0e3d20cd7ddfb18734b9b82e9c7bc8ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0392f31da059775b4490c919857a5ca92635cdf29511ca9355aab2a74217684"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4n --version")
    assert_match "Error: kube config file not found", shell_output("#{bin}/b4n 2>&1", 1)
  end
end
