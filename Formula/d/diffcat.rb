class Diffcat < Formula
  desc "TUI for visualizing git diffs"
  homepage "https://github.com/trebaud/diffcat"
  url "https://github.com/trebaud/diffcat/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "2627d468e2ff9ba10f857daae1b735548d6be7e444dbbe6e272c24007875783f"
  license "MIT"
  head "https://github.com/trebaud/diffcat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b83bdc049179f2524dcb802aad077faeb3c99bd642b448f777efe51f7c0a593b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b83bdc049179f2524dcb802aad077faeb3c99bd642b448f777efe51f7c0a593b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b83bdc049179f2524dcb802aad077faeb3c99bd642b448f777efe51f7c0a593b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68b82ab1544ce1265716c3c5b89a53c4a8df5544a39c7072970385ca63981497"
    sha256 cellar: :any,                 x86_64_linux:  "3b53d56d2a49ae4183d1546a4fa4be974c30484f4ab8a246347ed26b15d68c7b"
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
