class Qwe < Formula
  desc "File-first atomic version control system"
  homepage "https://mainak55512.github.io/qwe/"
  url "https://github.com/mainak55512/qwe/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "d5637bcb59f2c7f1a1b831c95b8d9f7edde99ca1920be94623109949d60c5b3c"
  license "MIT"
  head "https://github.com/mainak55512/qwe.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4ef8e39810cea7b9ed479f8e0cbdf44ba0d6c483873e72a08709d2b7f1d3dae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4ef8e39810cea7b9ed479f8e0cbdf44ba0d6c483873e72a08709d2b7f1d3dae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4ef8e39810cea7b9ed479f8e0cbdf44ba0d6c483873e72a08709d2b7f1d3dae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4055028b1da1bfa3d0b494f16a111d7174385e8a9a22736efef3944da00473a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "740f64f1e1de7b8b13755283b9734416c3e26f57ba6b52835140a73efc27de03"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "."
  end

  test do
    system bin/"qwe", "init"
    assert_path_exists testpath/".qwe"
    assert_path_exists testpath/".qwe/_tracker.qwe"
    assert_path_exists testpath/".qwe/_group_tracker.qwe"
  end
end
