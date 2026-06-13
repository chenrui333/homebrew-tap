class Kyushu < Formula
  desc "Self-hostable Wasm sandbox for JavaScript workers"
  homepage "https://github.com/peterpeterparker/kyushu"
  url "https://github.com/peterpeterparker/kyushu/archive/refs/tags/cli/v0.0.5.tar.gz"
  sha256 "8a5bc77f15b191e0e7a78aac2755b800509a044bea5bf2013114f44274c97705"
  license "MIT"
  head "https://github.com/peterpeterparker/kyushu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e752d51e8293e1fbc67650bb8e701efc4deb4ded2678ea39432a997650d6eddd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f438dcac97578efc7873df1e7ee2ca376f1cd18c682bee3dd4a088a12a274c8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ed400b5479893e683e09cf7a0cf4e11a25b9a42917c59f0d5a244a38358364f"
    sha256 cellar: :any,                 arm64_linux:   "a78f69dd65e48d6fe9fa5c63ca79b183094d38a5cc2455db0692fceebe10ad62"
    sha256 cellar: :any,                 x86_64_linux:  "f976226d83884f5e75870a2d0f8c37ebd88e5fc5f2523ac201594b711d1ae18d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kyu --version")
    output = shell_output("#{bin}/kyu --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
