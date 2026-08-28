class Diffcat < Formula
  desc "TUI for visualizing git diffs"
  homepage "https://github.com/trebaud/diffcat"
  url "https://github.com/trebaud/diffcat/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "86dad8196d711478c0cc1d1ddc2d66310b07c5b273c25afb17119d6ea3b66f3a"
  license "MIT"
  head "https://github.com/trebaud/diffcat.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e104f69f1fb4bc8fcd7ec2f5e435fd6215dac7274e5e8c8a989479f38feed927"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e104f69f1fb4bc8fcd7ec2f5e435fd6215dac7274e5e8c8a989479f38feed927"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e104f69f1fb4bc8fcd7ec2f5e435fd6215dac7274e5e8c8a989479f38feed927"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ac77f27b562a2bb03b6ffbed7f4416e00c7da85da4a27d34b0606ee9efa1216"
    sha256 cellar: :any,                 x86_64_linux:  "96d939359599486b5e450546de55bc7d1ed252887a47e66f777bc7bb4cad153e"
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
