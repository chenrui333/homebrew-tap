class Aic < Formula
  desc "Fetch the latest changelogs for popular AI coding assistants"
  homepage "https://github.com/arimxyer/aic"
  url "https://github.com/arimxyer/aic/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "1beae995886f56c54c0cfe08a800cdcf304df0dad6819312181415423a905ad1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31d1aac985f7ef5742af1f917ee446d70f0c8f5a7d14c07bdd21a655c24fc8b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31d1aac985f7ef5742af1f917ee446d70f0c8f5a7d14c07bdd21a655c24fc8b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31d1aac985f7ef5742af1f917ee446d70f0c8f5a7d14c07bdd21a655c24fc8b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b57e03d7d0102fadddaaa44f9f3cd6596ca3aef096b1dbe12e4bef21f64d8c1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddd35c3e6923dd17a221026e21ebf53ab2a8aa5aa880b62c01f6e2d2fde26162"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aic --version")
    assert_match "Claude Code", shell_output("#{bin}/aic claude")
  end
end
