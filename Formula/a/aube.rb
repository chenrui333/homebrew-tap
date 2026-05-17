class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "1dd9a4028ec5fc67f131d8c4f7174bb8a12df7e861fcd16e7690fc7c18fffe78"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aec6f81bc5850ddf0ec0bba9cf4fee61f87e0b8c5477aa71038c0f45fb121c37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc83403617f24febad8d12ca8d153b094486e419adb68a135d84c09272d6cd17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aecde4780d0e7bbff9ccd0e0935f7b5f8367bc78e20771599faab12a79190b9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "924641627963eea549607b9ae648cc1f64734af22d7460ccb86700e474e070c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8169f5f80a7bb96f161623d0406c18f54798937395e3a66319cf1daaa555349"
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
