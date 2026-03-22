class Ergo < Formula
  desc "Modern IRC server (daemon/ircd) written in Go"
  homepage "https://github.com/ergochat/ergo"
  url "https://github.com/ergochat/ergo/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "5dafcdc9b1eaed0273d54dc274a050d983f79057fbc529af0c52704b1a540680"
  license "MIT"
  head "https://github.com/ergochat/ergo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da1a71a0c32720e9d3983e44e3637af5203c9f3cdefb4eb733211872d597ebb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da1a71a0c32720e9d3983e44e3637af5203c9f3cdefb4eb733211872d597ebb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da1a71a0c32720e9d3983e44e3637af5203c9f3cdefb4eb733211872d597ebb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15859f0606be18ee1d90b517e0c1fbaaec9a103566df081bfbb81eae25194517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9d04c972034a86aeece15b23f64abf26cc7f3392e99f87c2190bae21d1bb668"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ergo --version")

    output = shell_output("#{bin}/ergo defaultconfig")
    assert_match "# This is the default config file for Ergo", output
  end
end
