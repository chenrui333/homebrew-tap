class Burn < Formula
  desc "See what's burning your Kubernetes budget"
  homepage "https://github.com/tanrikuluozlem/burn"
  url "https://github.com/tanrikuluozlem/burn/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "cc4aa76e1c667b9a1f50af73b8638c8a7e9d09d1ac3fa5cb7bed57bd9d78457f"
  license "Apache-2.0"
  head "https://github.com/tanrikuluozlem/burn.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ec7c5e2ffda4981b5eb54c2890936a79d3956f5416766095059f34b004bdc45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ec7c5e2ffda4981b5eb54c2890936a79d3956f5416766095059f34b004bdc45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ec7c5e2ffda4981b5eb54c2890936a79d3956f5416766095059f34b004bdc45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f3f294dc8c34ee6509084773c0c5f121e42ca9b34281a4797a8b0f811e09ab1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c34b261b8dcc9ee31d19acb20278acdcf1a91b1110bc40821da0750ed472b1d6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=HEAD
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/burn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/burn version")
    assert_match "burn", shell_output("#{bin}/burn --help")
  end
end
