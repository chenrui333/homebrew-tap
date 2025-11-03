class Ninjabot < Formula
  desc "Fast cryptocurrency trading bot implemented in Go"
  homepage "https://rodrigo-brito.github.io/ninjabot/"
  url "https://github.com/rodrigo-brito/ninjabot/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "e5342594f25c06a27b6d892d6b96f0c4b17bd1a1841fd19f79a57bf58984495f"
  license "MIT"
  head "https://github.com/rodrigo-brito/ninjabot.git", branch: "main"

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
