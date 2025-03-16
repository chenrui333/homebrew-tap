class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.10.15.tar.gz"
  sha256 "085583fbe92e6828ad2c8e6985b88c06be580b6e947b942f3b30e2bfed948fec"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8daceee7e48b9040202c28af765ed8ef7c8c8ad4ffec2d7d4c5a069dd2f0ae3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6ac0c7f82f30574ee9c70102ba914efcc82bb4ca9d6bfabcc4d60955ca68e09"
    sha256 cellar: :any_skip_relocation, ventura:       "14bddd0ddf4260f844704b5173d14d45ecfee28ce02d13880efe4e24e921f11c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8e51791b693de279522b849948b744a3a30ba26f7c94ab0b27f277c30c00cdc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtree version")

    assert_match "testdata", shell_output("#{bin}/gtree template")
  end
end
