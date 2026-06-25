class Diffcat < Formula
  desc "TUI for visualizing git diffs"
  homepage "https://github.com/trebaud/diffcat"
  url "https://github.com/trebaud/diffcat/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "b7697315599f9fb250aa31e65573188057ec69ed860fd3d7d467f2e042cb434a"
  license "MIT"
  head "https://github.com/trebaud/diffcat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f6d134e9e84afd0fd6cbf7f6b4e77168da3b140a3ef4b5536457a3d03cf392e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f6d134e9e84afd0fd6cbf7f6b4e77168da3b140a3ef4b5536457a3d03cf392e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f6d134e9e84afd0fd6cbf7f6b4e77168da3b140a3ef4b5536457a3d03cf392e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "996c203db35db5badd7230c6935fa8fe0296010c38e12824932c3417a33dae18"
    sha256 cellar: :any,                 x86_64_linux:  "df0fdd909267c9e65d1c7a39944d0b349e2e930c340a9d1ad9ca876c3fc33559"
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
