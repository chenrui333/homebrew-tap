class Twig < Formula
  desc "Terminal-based JSON and YAML viewer for exploring large files"
  homepage "https://github.com/workdone0/twig"
  url "https://github.com/workdone0/twig/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "74c8a1e64d722eb0bd2da6624f0a446ecd6b1eb30e74457ac6f8216950061429"
  license "MIT"
  head "https://github.com/workdone0/twig.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1a8e62f21d92e4c8b6981975c02680b0f392c5d7399590e1b6f5264b7984971"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aab0f1d5424bd209416d5cb9bc53e5d558e436e5ca78ce9680d443a7f7ac73c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1454e7a51d32dc50e104832c97fa4fd5b403d55436b2306ba208e8e6d3e0e3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fa515ad74aaab9881f96577545b5db1c70c9380d8384569e492da4143e8e24b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7902f32ebb6167e57925777ad771a42ac01fa9ef20e570dac43cb97f0505e31a"
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
