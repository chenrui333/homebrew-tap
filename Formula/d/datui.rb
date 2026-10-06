class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "1537cee04ffa13a808e67c728f0c0b5beac3535da206c92d5773c95bb82d50d1"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2dabf94c0fa28771e6fd054af6f09164cbbda110190dabf03ef4be1334f975b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3994fcaa1fbacf67770a997b2dc5eefc76841a823cf2fab5c12dcc91bbfdd164"
    sha256 cellar: :any,                 arm64_linux:   "ee36c48a21123fa0b956a9666a2b6ce1cbd9099ae3323cd39411e664b399f427"
    sha256 cellar: :any,                 x86_64_linux:  "7c251bc68f1fe78ac639d1db6a1d54e8b7a4382c1646ca0c35b40f7d4ba7fdbf"
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
