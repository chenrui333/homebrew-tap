# framework: cobra
class Enola < Formula
  desc "Hunt down social media accounts by username across social networks"
  homepage "https://github.com/TheYahya/enola"
  url "https://github.com/TheYahya/enola/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "c48b934d95e1b6006ddac422a689e2d67d8bd81f2b47a4d75389483ad3644520"
  license "MIT"
  head "https://github.com/TheYahya/enola.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9b287caf875c04dbf6e60f0bb90f56b8268c1aa28ba9bd0af4f49a5e3772d02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9b287caf875c04dbf6e60f0bb90f56b8268c1aa28ba9bd0af4f49a5e3772d02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9b287caf875c04dbf6e60f0bb90f56b8268c1aa28ba9bd0af4f49a5e3772d02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fe5d630ab43e0cd089bd4159a2e5ca0143cda5e9dccad2b8d22c22e8c54395c"
    sha256 cellar: :any,                 x86_64_linux:  "75ce5e0978dd91aff64cb4c0eec5abf10177d135720d68829287054478242844"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/enola"
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"enola", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
