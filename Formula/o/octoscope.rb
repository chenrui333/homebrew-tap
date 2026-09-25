class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "7303a738f6f5ab9efbec3f4dc03d3d434513d1c45b50a997553ac2dd569fa4d4"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a41287c12b15187c0b99d34fdfd1b9dc55dcb4588f6ca11e8742a029c4d02711"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a41287c12b15187c0b99d34fdfd1b9dc55dcb4588f6ca11e8742a029c4d02711"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae6ec77d3fa4733c378ffe19188a6b1b71a0c4c97331df998cd8e4e111b3541d"
    sha256 cellar: :any,                 x86_64_linux:  "782038e3f3af5afff3e237dbf29bc91bf835b80b58e66f5b3a84c59fd2eca312"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")

    output = shell_output("#{bin}/octoscope --theme invalid 2>&1", 2)
    assert_match 'unknown theme "invalid"', output
  end
end
