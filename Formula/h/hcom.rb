class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.21.tar.gz"
  sha256 "559acbc065b5603eef1d9e7483f8730cd62adccf24815b779a21b09671334837"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd95e01c7e9d4b181e62df434082fff66f0cb8a649604be0d4fac0ac799a681e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81c2861f23081343a431cb6caf4ffd3de04680db240e1d74afc65fc07e178a22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f712f0e73742eb481d68cf083fbf98f7ee9a132dc646ad1ef9967924dd10cf38"
    sha256 cellar: :any,                 arm64_linux:   "bf429a70ebf1712b72d7a52d701bb19d600690dcaa48f039795ee78df1e1294d"
    sha256 cellar: :any,                 x86_64_linux:  "d7a27565160ad54e39e85afc4f1ac6d844947a3294cb0d36852aa2a46b891749"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")
  end
end
