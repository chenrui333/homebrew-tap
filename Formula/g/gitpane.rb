class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "20d816978b9e43914e54310a7e04fb35d0c2990c3fdc4313947e159ca18b239e"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "d90c261639277543eeed1321e4d11cd45978a6ffa4b63ba882b1b58bb387e2d3"
    sha256                               arm64_sequoia: "43497aff7409392eb2e6150123745d515beb605a9a973a10a5427f77fcddd588"
    sha256                               arm64_sonoma:  "fccd523329cd46c3ff6234fd7ba292a62098d8d97d6577196756fb368bd68849"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c998e5d243d4fdadc3d12917b6d7cd9843503f5a2e29c6dd66501d7799de36e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "870d23950b4518c84e0e9095ea333c90e61fa39ddc011e4aa0ed55465ad8b746"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "gitpane", shell_output("#{bin}/gitpane --help 2>&1")
  end
end
