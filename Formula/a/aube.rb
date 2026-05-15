class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "ce4907b971da672cf1de6d71673a6b6c4a84ec8cfdeec2f6e31f463b367e56f1"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9eccc660af6cc9689eb2ee006cb52b7a96b7226dc27699d7d12ba81b0c30bc62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "320187eb5771dc187ea38a96bb4b83d7aa8af670969d89693db2fa08f82e9ce7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f83824cf8fd258194e11e17d307231071d45ba2ca6ed339f8f6ac7388ac4cfe3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4cf2c37804c64ba9752b503383e10f1355b91037aebf5842e9359f036b3bffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3171ea13242ffadf36b73c29cb03f3d3186fd479bb7e7fa204f429d3ead41f3a"
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
