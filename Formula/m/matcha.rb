class Matcha < Formula
  desc "Daily Digest Reader"
  homepage "https://github.com/piqoni/matcha"
  url "https://github.com/piqoni/matcha/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "a24de22ba5614be70563a8eeda579f16479af7f809373fe15b0eb869e1c174db"
  license "MIT"
  head "https://github.com/piqoni/matcha.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3f4bede60b719c3787c1bf4aea90d429e8fb91d95f4c533eac588673ca7eb18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c47adf5a2174ce60efb686952a6608f645e51e95803883409f77ae6ca30771d2"
    sha256 cellar: :any_skip_relocation, ventura:       "c7cef9206053bf4726fd17105b1e316cd298bfd1fb40c7aadb9043b490864957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21b9db48ee8d8a22f68a82626c2ac9fcc758dfee23b4bfab17daa1331ba7bb4a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"matcha"
    assert_match "markdown_dir_path", (testpath/"config.yaml").read
  end
end
