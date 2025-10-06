class Shuk < Formula
  desc "Filesharing command-line application that uses Amazon S3"
  homepage "https://github.com/darko-mesaros/shuk"
  url "https://github.com/darko-mesaros/shuk/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "74b5d7af63e256cf8c9496a8739bf6ee67a133a760cb676ed4128897ac85593c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/darko-mesaros/shuk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28fded97440a323c3829f29946337643422976bbe37710a72cca4cf3581ed226"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8215fd41d03821c6941917fc6c0695d4ed0f05748019574d9f13148f7238da0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4801d78c83151b5ab637a69c61fb5fec5f610bf2e7b655b556fc522a7295877b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2c55753d51b0fb2f1dec00e7f79349aaba2d92cd9a828dd8e3093624ba25c8d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuk --version")

    output = shell_output("#{bin}/shuk test_file 2>&1", 1)
    assert_match "Could not read config file", output
  end
end
