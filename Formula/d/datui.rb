class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "d90f0b0150fe9e371c4c5be6477cb9b9aff9a38fa456666481dc4ce8510a6378"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f043df3ab2c9faca8aabcbdfd66c196e63a3eb9cc5ea2c6fa555a357a681df9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "155b80929545d716bc09d989fe8a352c1aa58b4623a5e6392e5918e0a7b51a42"
    sha256 cellar: :any,                 arm64_linux:   "c54f473f05495275390ec675a2b74c17259584aff3885ed8c1afcc40f654e5e6"
    sha256 cellar: :any,                 x86_64_linux:  "16a3fba56cff35cbee0a919669893ceb5e1e4ac551a18dfceab19ef2d760638d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "datui", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/datui --version")

    output = shell_output("HOME=#{testpath} #{bin}/datui config init")
    assert_match(/Wrote .*config\.toml/, output)
  end
end
