class Twig < Formula
  desc "Terminal-based JSON and YAML viewer for exploring large files"
  homepage "https://github.com/workdone0/twig"
  url "https://github.com/workdone0/twig/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "74c8a1e64d722eb0bd2da6624f0a446ecd6b1eb30e74457ac6f8216950061429"
  license "MIT"
  head "https://github.com/workdone0/twig.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7e2505aab74edb260a41adff04c765b0d913177a1d2af3ef484e893106176cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20c2b1f78d400da0b37e1f07ddece0f828e84862a3a2189d7760e752cd25f958"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1956b7c9d398e0976102b0e9af143d5ed6cda910f7aba20a63dc72eb11084997"
    sha256 cellar: :any,                 arm64_linux:   "c92c8a8e224cf29012b05c346939c1e7e8ff309fce6b1223d38094968bcf2d75"
    sha256 cellar: :any,                 x86_64_linux:  "2e5c55169765a44b9f1c1f1c91f2a13c8100721d2d06b4f054e7a5e742aece76"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"sample.json").write <<~JSON
      {"a":1}
    JSON

    assert_match version.to_s, shell_output("#{bin}/twig --version")
    output = shell_output("#{bin}/twig --print #{testpath}/sample.json")
    assert_match '"a": 1', output
  end
end
