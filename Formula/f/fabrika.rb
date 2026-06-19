class Fabrika < Formula
  desc "Software factory that orchestrates CLI coding agents as a managed team"
  homepage "https://fabrika-ai.com"
  url "https://github.com/berkaycubuk/fabrika/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "1eec3de4d3c5ce5e35c04151b49ba570f0fa1f8a9ec5457c25eaaae1c33251e1"
  license "FSL-1.1-MIT"
  head "https://github.com/berkaycubuk/fabrika.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52b89d50ac54b235caf7924f2634482fd6a8bbd55f906479226866ef9669d46f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52b89d50ac54b235caf7924f2634482fd6a8bbd55f906479226866ef9669d46f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52b89d50ac54b235caf7924f2634482fd6a8bbd55f906479226866ef9669d46f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be3931a4acd22e0e7fd7cbdcd75df3713b54f17142be6c989e4e8b9f369825fd"
    sha256 cellar: :any,                 x86_64_linux:  "66aad8781b229d9f92162a2f5f9c42d47ea8d4fe7ffee6d32727077e158639e2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/fabrika"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabrika version")
    output = shell_output("#{bin}/fabrika not-a-real-command 2>&1", 1)
    assert_match "no fabrika.toml", output
  end
end
