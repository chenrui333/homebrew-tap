class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "3b1d056cbe41022a053c857d04cd0c349fdbc7ae2f719f3b41995196c6b542a2"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67d406512809a3a3b7826ec87a4564436d29f362d07c1dbf7cdf05a8b4d7b37c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee7ab9adddd440314f5c07d5fae12121bcd3aaea338a82def61227d1cc7f4c5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dae12d6d0792b627be436793c444605bd0b4cf343f68ae343e94806a501f1ca3"
    sha256 cellar: :any,                 arm64_linux:   "a5c2627bd7510420565dc0331a3cc9e4cd402234db5e590baeeb3eb3e2f78dc1"
    sha256 cellar: :any,                 x86_64_linux:  "a7fe27fd42aacd9678484533499696f3562fb677741b4179ee8c92ba073ceb93"
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
