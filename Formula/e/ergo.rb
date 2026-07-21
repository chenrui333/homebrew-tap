class Ergo < Formula
  desc "Modern IRC server (daemon/ircd) written in Go"
  homepage "https://github.com/ergochat/ergo"
  url "https://github.com/ergochat/ergo/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "37abcccd951fb9b672efffaa90e021d5f7d8b6a300137e2d89d708986e041927"
  license "MIT"
  head "https://github.com/ergochat/ergo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83170b6be54ba2284ef506398f2341c1b4c644b6505cb1da6916d38c203e8a17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83170b6be54ba2284ef506398f2341c1b4c644b6505cb1da6916d38c203e8a17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83170b6be54ba2284ef506398f2341c1b4c644b6505cb1da6916d38c203e8a17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48e7603cdd33704be86f5e2e1a59c66d5d410971671c6b78e673746b8fb53c3e"
    sha256 cellar: :any,                 x86_64_linux:  "86a7f5286960bf69c050e876a3f8c75c3d5b9b63b79e3e9b2a9d78e22ee04b86"
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
