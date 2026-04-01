class Tiki < Formula
  desc "Markdown-based git-versioned documentation and issue management"
  homepage "https://github.com/boolean-maybe/tiki"
  url "https://github.com/boolean-maybe/tiki/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "62b1fa93db51c19177f8877b3878d9079c3a2647ae7c8aea657ec84c22eeac1a"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8acca3cb389bd83211872bed88080b23277282e35f64773e08af26de21c77bc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8acca3cb389bd83211872bed88080b23277282e35f64773e08af26de21c77bc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8acca3cb389bd83211872bed88080b23277282e35f64773e08af26de21c77bc1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc67313b6b6ffed6b9e426518b6dd61370d35698baa5866e32481cd96acae5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0b9813ee913fc902e5c9fd9169bbc52639f6374533fdca432806d27284a89bf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X github.com/boolean-maybe/tiki/config.Version=#{version}
      -X github.com/boolean-maybe/tiki/config.GitCommit=Homebrew
      -X github.com/boolean-maybe/tiki/config.BuildDate=unknown
    ]

    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    output = shell_output("#{bin/"tiki"} sysinfo")
    assert_match "System Information", output
    assert_match "OS:", output
    assert_match "Project Root:", output

    assert_match version.to_s, shell_output("#{bin/"tiki"} --version")
  end
end
