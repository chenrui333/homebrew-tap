class Ninjabot < Formula
  desc "Fast cryptocurrency trading bot implemented in Go"
  homepage "https://rodrigo-brito.github.io/ninjabot/"
  url "https://github.com/rodrigo-brito/ninjabot/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "e5342594f25c06a27b6d892d6b96f0c4b17bd1a1841fd19f79a57bf58984495f"
  license "MIT"
  head "https://github.com/rodrigo-brito/ninjabot.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1595a85737f1ed805d68987be2519f976f00bbc8cb4e6dcf7b45725434926cef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1595a85737f1ed805d68987be2519f976f00bbc8cb4e6dcf7b45725434926cef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1595a85737f1ed805d68987be2519f976f00bbc8cb4e6dcf7b45725434926cef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba988d57f59265ec893482776f1a60b25f0d4db4d1d3d5a9862d04c212e1994c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a66805f02726c85c7856eb214055de3d2d9fa74ea0d8ca201ad5df80d5e48c8a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ninjabot"
  end

  test do
    output_file = testpath/"btc.csv"
    output = shell_output("#{bin}/ninjabot download -p BTCUSDT -t 1h -d 1 -o #{output_file} 2>&1", 1)
    assert_match "Service unavailable from a restricted location", output
  end
end
