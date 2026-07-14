class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.49.tar.gz"
  sha256 "c43b9e189c1e75ac6e6f1f5ac136fc9ac9739f7a075553aed7edbe0d6ce0a3d6"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c51ef75f9a52f0b7af2638d3dcddca8ab3fa8f1876b85dc430dd91ed86e6e29e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d4783581f49a6a1a798b90d419a24ffd329baa395e20ced0845e044137cbd6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fe77e507f4a6445d28a1b954fa759cf2e8f77a54e067dac860f9301f36b6fa6"
    sha256 cellar: :any,                 arm64_linux:   "c7c0db9b07c49a6c181abe18a8ceacd9ae42ecd5e4b032b98ed2a8c88a6980cd"
    sha256 cellar: :any,                 x86_64_linux:  "bfff0285cea12d836894e3fa091d92735486425d1827aa90841cbd722d48360c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oyo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oy --version")
    assert_match "github", shell_output("#{bin}/oy themes")
  end
end
