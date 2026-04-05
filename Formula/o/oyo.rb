class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.26.tar.gz"
  sha256 "8f98d7f50fa1026faf051802cb17ca8821974d82595ca127771ea9b4584cf11c"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4418930de7f68ecf3338861e0d136c3d4e42e0757487837a40a725121eb2979e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47c235a54e892010840bda4ea3d9a9b8de27de7fa0bb3fe34b76fc072cf70886"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a7bfc45d006bd640f53c12d5b89c5dc83013bef2030d250ceb084a57df7067e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "019fc556a8a75d2fbcf75a114a109d008e80dd74c70225a4a24a04b130b67320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e19ac2a975d81ff1901223a93db8386884919a9f3a2a4db0ce949b2e2e334ed2"
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
