class Moji < Formula
  desc "Find, inspect and convert fonts"
  homepage "https://github.com/Microck/moji"
  url "https://github.com/Microck/moji/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "43989e70b8dba28180e5a9bbbc51c833d74a4ebe652a2a263b266d8eea9983f4"
  license "MIT"
  head "https://github.com/Microck/moji.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5745191b102ecc045131a1578e3bc8c16f89433f8da7480eec43765a0fe3bc85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5745191b102ecc045131a1578e3bc8c16f89433f8da7480eec43765a0fe3bc85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b763d0b5695bd7843819148e4a283255582e026e2141e93845b6a63f516b0bae"
    sha256 cellar: :any,                 x86_64_linux:  "2367c65e7f1f4857cf15207af5e08fe9a0c430b529d24615c4260f22233b5f8e"
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
