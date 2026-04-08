class Golazo < Formula
  desc "Minimal TUI app to follow live and recent football matches"
  homepage "https://github.com/0xjuanma/golazo"
  url "https://github.com/0xjuanma/golazo/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "9dcc5103833cbd57c86ddea99f7ff70f18e6e2606961e2a7036462db089f64c4"
  license "MIT"
  head "https://github.com/0xjuanma/golazo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a0a6b187885d5dcc7b08223e12d9d721219f6c26f8c91d8e008da0be1719c7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a0a6b187885d5dcc7b08223e12d9d721219f6c26f8c91d8e008da0be1719c7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a0a6b187885d5dcc7b08223e12d9d721219f6c26f8c91d8e008da0be1719c7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "065b5deaf6a00f5b480ff65355a3569d09d92902734a415a5f841e7a2725a47d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3b8279a4527c933f66f159161e30cb35b3016e442d582bee40b7125cf0b0fec"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/0xjuanma/golazo/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/golazo --version")

    output = shell_output("#{bin}/golazo --definitely-invalid-flag 2>&1", 1)
    assert_match "unknown flag", output
  end
end
