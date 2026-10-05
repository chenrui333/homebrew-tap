class Rwx < Formula
  desc "Manage Unix permissions and ownership"
  homepage "https://github.com/vncsmnl/rwx"
  url "https://github.com/vncsmnl/rwx/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "e7848a07e96fbed035e1ab3f32b6099a2c9457c7caa3863f97112cee57a9eae2"
  license "MIT"
  head "https://github.com/vncsmnl/rwx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e15733d697993c9b8ed848f7c1a0c07f5bef1d3d14d4767cb7c0778d232fec79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d0f5a897ee39b83bde5af315dabaf7aa0a0549620b20dab6b6b5a7faf97f1ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5689dd63acc7a8f7fc84df59b82751d652d1289ef27759c6c30998b188b8d17b"
    sha256 cellar: :any,                 arm64_linux:   "c0bacd687fd770f86db945cf59f5e1c6db81dc9a673bfd03c4baa5da224bb2e4"
    sha256 cellar: :any,                 x86_64_linux:  "b34cb79209e9306817a2688935af0387c31058487285fe382905bb15154e7803"
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
    assert_match version.to_s, shell_output("#{bin}/rwx --version")
    output = shell_output("#{bin}/rwx --invalid-option 2>&1", 2)
    assert_match "unexpected argument '--invalid-option'", output
  end
end
