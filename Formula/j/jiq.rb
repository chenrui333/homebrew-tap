class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.32.3.tar.gz"
  sha256 "2207efbe97c1d9ebc092a906876388e61f91af3bb8a0a7f8f1f011e156a232c3"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b7e7488ec64491a5c8c0b0eb94dad935efd71d82fb6f97ded8ca7c20d39a7f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "191462a84fde3fbe3ab11726059f93e932b2737ba39916bbf8a0e75196a51ed5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "824b9c467758918446ab5a577bc113042b7f325ba515b4ff963892db4631363f"
    sha256 cellar: :any,                 arm64_linux:   "9745d18be73c3031ff13bb0001a3f2bfdd3f3ad2cce17296c93cbc721f06f0b6"
    sha256 cellar: :any,                 x86_64_linux:  "da53021b12e556e621be4a1a39969b2b3ae59e3622e55df8c5db335bebce93f0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiq --version")

    (testpath/"data.json").write("{}\n")
    empty_path = testpath/"empty"
    empty_path.mkpath
    output = shell_output("PATH=#{empty_path} #{bin}/jiq #{testpath}/data.json 2>&1", 1)
    assert_match "jq binary not found in PATH.", output
  end
end
