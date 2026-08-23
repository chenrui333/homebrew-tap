class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "a6772070e66399a400d942f8ee4fab3ea0babe02fa97f3a4eb255ce776172415"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11f83a56f8a4215a5baea0cb64e6016385c7544027dfa2bdb42030ac14e69208"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26b1cbc925d6ad325ae063b573c1291d1d9972b09426132fc7e1f757ee386b4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06f47647b57a99c881047d64a72a5921c72efabe4706c5d731c8e68f229a602c"
    sha256 cellar: :any,                 arm64_linux:   "33cca4e1bf52e15f890d4be3add73ae6d0bf95406b35b0b0cfdf0f723eb5010d"
    sha256 cellar: :any,                 x86_64_linux:  "5258925216f001d8fe43fe95a1bf080aae18bb42ea57d01f92ad03ae702bd1f7"
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
    assert_path_exists bin/"aubr"
    assert_path_exists bin/"aubx"

    (testpath/"package.json").write('{"name":"test","version":"0.0.1"}')
    system bin/"aube", "install"
  end
end
