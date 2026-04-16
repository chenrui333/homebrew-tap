class Clickhousectl < Formula
  desc "CLI for ClickHouse: local and cloud"
  homepage "https://github.com/ClickHouse/clickhousectl"
  url "https://github.com/ClickHouse/clickhousectl/archive/refs/tags/v0.1.18.tar.gz"
  sha256 "62fbaf4e1fa59174cbfd0ce90fcb700d3f607283646f9e6742ed189ac4d273a5"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhousectl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f38388bd0c85916dcb3cbf9b5a5375f52da538c2e578827815df247352a7598"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b42666087d9857eee797896703902eb235a1aa896f55283fcb1b1eb73b8a5f4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12272454a818ddde384a7e81c83d9c948857d129523a055f03e1930592d55ad2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a791a7432a8f3284bd3e89d5c2dee490d648dfbfc745fe36b6296318c6794331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06bd7751e14f30ee4a4dc43a2f668edd5fe7e0fce99618c0fad7bad0e65523bd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clickhousectl --version")

    output = shell_output("#{bin}/clickhousectl cloud auth status")
    assert_match "Not configured", output
  end
end
