class Moji < Formula
  desc "Find, inspect and convert fonts"
  homepage "https://github.com/Microck/moji"
  url "https://github.com/Microck/moji/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "3b7803cbcf00048394668746a847074ce76928850199bb38fdd809042268a4c9"
  license "MIT"
  head "https://github.com/Microck/moji.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b8762f74ba9a56f53c17af16f4d594f96a04cdee73f1dc1783ef586c53b21b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b8762f74ba9a56f53c17af16f4d594f96a04cdee73f1dc1783ef586c53b21b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e3dab623bdd39079f1c8e2a30e54bf7f64cb8d9a6d61a8cfa5014de3664184e"
    sha256 cellar: :any,                 x86_64_linux:  "57fd69120d9962cd2fbe255c28b8b94dead7d5180915d036de4cff7853ee1cc9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/microck/moji/internal/app.Version=#{version}"), "./cmd/moji"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moji --version")
    output = shell_output("#{bin}/moji 2>&1", 2)
    assert_match "font query is required in non-interactive mode", output

    config = JSON.parse(shell_output("#{bin}/moji config show"))
    assert_equal 15, config["SearchTimeoutSeconds"]
    assert_includes config["DefaultFormats"], "otf"
    assert_match "Cleared cache", shell_output("#{bin}/moji cache clear")
  end
end
