class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "8d2c18bf0aed504a7053158fe04773bf9755c949fcc912ddc340189a102d24d9"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d5daa3723b11dfd9417d880c43cd219aff307d590facf72830296f5a64ad683"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47a4a730c9705ddc0cc82aa7dd92edb1c025e0a14d840a40e52f300e4c0e611b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "accffacb2696e7b65f882508319088b7058052191922300c052f4017c38e8254"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10d9e02257f1aef3757e30e9eb57525781b260359fe93678fbc42eab594101b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3b03882acac909ea6779bd02840a8c347d7d16c90163d01dec92820522203bf"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")

    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aube --version")
    assert_match "Usage", shell_output("#{bin}/aubr --help")
    assert_match "Usage", shell_output("#{bin}/aubx --help")

    (testpath/"package.json").write('{"name":"test","version":"0.0.1"}')
    system bin/"aube", "install"
  end
end
