class Moji < Formula
  desc "Find, inspect and convert fonts"
  homepage "https://github.com/Microck/moji"
  url "https://github.com/Microck/moji/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "43989e70b8dba28180e5a9bbbc51c833d74a4ebe652a2a263b266d8eea9983f4"
  license "MIT"
  head "https://github.com/Microck/moji.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c557f75024c030cbe33e5887979f332d11fd4a547b668649ebf1d47e98cea8dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c557f75024c030cbe33e5887979f332d11fd4a547b668649ebf1d47e98cea8dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c557f75024c030cbe33e5887979f332d11fd4a547b668649ebf1d47e98cea8dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "327f419ae820662809034661dc8bf5e6caa3bc51ccf0c076e460176969d3f1d1"
    sha256 cellar: :any,                 x86_64_linux:  "c08782dccc8a7fdfd11b82861107076750b77a271521f9f6cd1c4ca340b56445"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/microck/moji/internal/app.Version=#{version}"), "./cmd/moji"
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
