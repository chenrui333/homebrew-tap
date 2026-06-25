class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "52bd926e6934e4b4da7920b6b85fadee1767872a6bfab1b793994208217b3b3d"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b1710305ea7aaad0aa822c974099b28bcb7978859062e242725857488aeebeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7c9a723664bf0d03bc4f1798d59902ed69e3ee4be60b87b6070963ee304c505"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3740a4d63cf4af2a1168ba5ea85adbe8f81771a2755dc5dcae64a73fd1cacac"
    sha256 cellar: :any,                 arm64_linux:   "6a14d7a5af0deb23bfaa50fa650b532969dae2262df8cf69e35b6705a88f3573"
    sha256 cellar: :any,                 x86_64_linux:  "6fd848463392da07700e0a4c99a640b1b421a93af103e7b05a0b757cc3821fda"
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
