class Ecscope < Formula
  desc "Monitor AWS ECS resources from the terminal"
  homepage "https://tools.dhruvs.space/ecscope/"
  url "https://github.com/dhth/ecscope/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "27d20d3c8a6ea52352e40c0384c3520d820ed0abe224148f3966ca4d5aacf3f4"
  license "MIT"
  head "https://github.com/dhth/ecscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2abfcf736162a6af8482b6cbcfe1824824b77336965020cea70976d7b379797b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2792e28a7e6eb1dbe0758f7b84588fbc5137633b83276c453964570d51b9b2dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4ecbdce1e6a4191295f9720374edb9041316954c7a4afb2cf788481f9678c07"
    sha256 cellar: :any,                 arm64_linux:   "b196923231bc5ab2553a52e9686a9fc570ebf1121276b8c3ea474a7aa6017417"
    sha256 cellar: :any,                 x86_64_linux:  "9859bd4e71d5d43b1de74d77957ce039582ec6007098b0ccac6ea789b93dfec5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    ENV["AWS_ACCESS_KEY_ID"] = "testing"
    ENV["AWS_SECRET_ACCESS_KEY"] = "testing"

    assert_empty shell_output("#{bin}/ecscope profiles list")
  end
end
