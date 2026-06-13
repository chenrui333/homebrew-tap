class Ecscope < Formula
  desc "Monitor AWS ECS resources from the terminal"
  homepage "https://tools.dhruvs.space/ecscope/"
  url "https://github.com/dhth/ecscope/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "27d20d3c8a6ea52352e40c0384c3520d820ed0abe224148f3966ca4d5aacf3f4"
  license "MIT"
  head "https://github.com/dhth/ecscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77b7ff6e3beae2291aee7165b32db03a3f699768d19312d9cb5271fd2190417f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b6a32bdd2a942ac85b17f14dfb7c530a2eaf41b3de68556fe4f22bbf86a900b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62a8439b85774179f22e518d6a27fcff522170fde2d06f4d534de2616507d987"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfed076bd5c1323b3387aa5eb17aa7e9f94e71e606fb247aabf5e2b16f166f97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8d795b867bd2c391d5c2a05632eaf17839b538d98c879003478829701c6ec66"
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
