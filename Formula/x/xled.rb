class Xled < Formula
  desc "Transform tabular data using regular expressions"
  homepage "https://github.com/excelano/xled"
  url "https://github.com/excelano/xled/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "5ad0e96f48cc5b56afb2957698073c89af9a75438acdeac8ce6aa8e36e28779d"
  license "MIT"
  head "https://github.com/excelano/xled.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd5cdf9892425455d7aba99e82662b3d92ceaa79a391d5ef72274b952fc406ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4b6d8d1e8db52b3e1aa0d708cae12318ab77c28c4cfc6c091f0ec09f2562fc8"
    sha256 cellar: :any,                 arm64_linux:   "dfdc7a171907bbc87b3c6a72696d618ab676782a699256712fec29a2a006be21"
    sha256 cellar: :any,                 x86_64_linux:  "b83dc44e114f435f21dc883554286aa26fc76700ee52bd03477c56fb09cee075"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xled --version")
    (testpath/"input.csv").write("name\nold\n")
    assert_equal "name\nnew\n", shell_output("#{bin}/xled '[name] s/old/new/' #{testpath}/input.csv")
  end
end
