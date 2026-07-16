class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "dbcb5235af440e877c44baf7175eabb6763465fb0cf07cfa7e993f23b7c7fa15"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "521ceab33e1bf74d9cdef47ab08655a6b1c4dba7bcaf3cf88c0d389f04c179ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38f8264709d2f3e053c8360d98d02cfaacb8e459329a0523ec7acacd0e6cbd00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f087c5f3500700cbaa1f6d42bd6efc05fe3b7bac17e422749ab83e7f4de4ae6b"
    sha256 cellar: :any,                 arm64_linux:   "93df6dda9f2f7285eff2f02d764cfa99b05aaee6986388a8aecf4af513e42811"
    sha256 cellar: :any,                 x86_64_linux:  "d48aacaacabd3c8cb7a934089e3722b6f2407e709627da09cb9b58120d2877f3"
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
