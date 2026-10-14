class Diffcat < Formula
  desc "TUI for visualizing git diffs"
  homepage "https://github.com/trebaud/diffcat"
  url "https://github.com/trebaud/diffcat/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "02391ce8f8258dd876d51950266837bba0fd45977c34eb200a367886bd4b654d"
  license "MIT"
  head "https://github.com/trebaud/diffcat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07a108bf200b54d07ce1fa5520ba748032f9f544b0b350c0b11bd8e54ba075be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07a108bf200b54d07ce1fa5520ba748032f9f544b0b350c0b11bd8e54ba075be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "debc91965ca27fd3414d44c0ebaa3a92668cabf70bd1d2401b22a770516ed506"
    sha256 cellar: :any,                 x86_64_linux:  "8d7ce456dc378f34decdccd69debf27225da8e01fb55f442e0b6c95e5b41e501"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.ldflagsVersion=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/diffcat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diffcat --version")
    output = shell_output("#{bin}/diffcat not-a-real-command 2>&1", 1)
    assert_match "not a git repository", output
  end
end
