class Ninjabot < Formula
  desc "Fast cryptocurrency trading bot implemented in Go"
  homepage "https://rodrigo-brito.github.io/ninjabot/"
  url "https://github.com/rodrigo-brito/ninjabot/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "b5068dbb125d423956857cd0e73aa4c8df6b6720dfece9caff4dcd3c120d1685"
  license "MIT"
  head "https://github.com/rodrigo-brito/ninjabot.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cb2e5e21cad30d54df15d4216f93bc7ccc9efa7abb63ff3c5733674d0b9e156"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cb2e5e21cad30d54df15d4216f93bc7ccc9efa7abb63ff3c5733674d0b9e156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cb2e5e21cad30d54df15d4216f93bc7ccc9efa7abb63ff3c5733674d0b9e156"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bda27b4e15a2975bf996eaa6a9e9c502808ddc717cae6cb20c835c3818a56bfb"
    sha256 cellar: :any,                 x86_64_linux:  "8df6e885c0d8bc7b48eba154540ebd7a7a29732f131051e06bfe9b2cc6969506"
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
