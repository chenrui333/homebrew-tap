class Diffcat < Formula
  desc "TUI for visualizing git diffs"
  homepage "https://github.com/trebaud/diffcat"
  url "https://github.com/trebaud/diffcat/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "2627d468e2ff9ba10f857daae1b735548d6be7e444dbbe6e272c24007875783f"
  license "MIT"
  head "https://github.com/trebaud/diffcat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4711347b071a80f63d38a51d7fe1e58e5fe7355e438ebe35aa2e5b0c2dd80b2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4711347b071a80f63d38a51d7fe1e58e5fe7355e438ebe35aa2e5b0c2dd80b2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4711347b071a80f63d38a51d7fe1e58e5fe7355e438ebe35aa2e5b0c2dd80b2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a087e7d506e7818eee20a0b93af8ed3dceb26cae59707fdeec408272337a219"
    sha256 cellar: :any,                 x86_64_linux:  "ffbaf7254eee18758d86dc61f18bf6c7d4b0a3e25404f7d06c017cd0dedc88cc"
  end

  depends_on "go" => :build

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
