class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.23.tar.gz"
  sha256 "e8dabe61acdd3e24d9e94941621dfa409f05bbb406bd95a290b32908e8f5204d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68acb9380671f1ffc400c5cd75bcd5d3b2737c67fccdc2caebeba0070180e48e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2daa3d3518bfdca7c64d7798627187ff4dbb69248da8270535ac96667eb09837"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9587c5e847a26396344b2b4201327e4bfc62cd04ab522b38688255cd63dcca4"
    sha256 cellar: :any,                 arm64_linux:   "fe98f4a77f0ab24dd419c56d0b4874786c4681e2a8bbe7dd4b27bef5b8da296e"
    sha256 cellar: :any,                 x86_64_linux:  "4cb2571d705a2939d83f343140f91ecff73b5d2b2d3f3f0be9da2013f36df448"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")

    ENV["HCOM_DIR"] = testpath
    assert_match "Set:    hcom config terminal kitty", shell_output("#{bin}/hcom config terminal --info")
  end
end
