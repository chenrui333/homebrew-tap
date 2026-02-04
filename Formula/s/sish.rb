class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v2.21.1.tar.gz"
  sha256 "c69a7542ad4135cf5f408f533e4767e6a6e8e6ab4cdbd97e3dc004f7dec3b045"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b857efff6fc60d9d3f4d17f7ad6c215f3c118d1e62a6ef27f4bac7e2e37570ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b857efff6fc60d9d3f4d17f7ad6c215f3c118d1e62a6ef27f4bac7e2e37570ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b857efff6fc60d9d3f4d17f7ad6c215f3c118d1e62a6ef27f4bac7e2e37570ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bd7c8caa911078bb15a2f7b7ef5e250d850a0a9068d514fb8aa626c0ef48f60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d57645e0d0f6685d6213c66cea3fea8127e1835b342562f8edab8283bd24823e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/antoniomika/sish/cmd.Version=#{version}
      -X github.com/antoniomika/sish/cmd.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sish --version")
  end
end
