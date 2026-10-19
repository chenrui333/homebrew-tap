class Cpg < Formula
  desc "Cilium Policy Generator using Hubble relay"
  homepage "https://github.com/SoulKyu/cpg"
  url "https://github.com/SoulKyu/cpg/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "070ffe95689a262c7477af5918d87e4d2243ff56665f27fe6a9a5bf595ad655d"
  license "Apache-2.0"
  head "https://github.com/SoulKyu/cpg.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3220fcebb156b84b725d2bafcc2ff482f1f547399f787390f5c15115362a1d13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9871bc6041f68a058c81fe3576951e83e859903617453563f3850d210d786a0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb4380afff4c2fdae8c30e2dddcd80975ef7dcaa6fc6f155e7103c5577c1cc2b"
    sha256 cellar: :any,                 x86_64_linux:  "1d2275268c209c6d8fcd53ffde5738c0ca085fe882511ad3f2003311e57532e6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/cpg"

    generate_completions_from_executable(bin/"cpg", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cpg --version")
  end
end
