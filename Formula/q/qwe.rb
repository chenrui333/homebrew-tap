class Qwe < Formula
  desc "File-first atomic version control system"
  homepage "https://mainak55512.github.io/qwe/"
  url "https://github.com/mainak55512/qwe/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "d5637bcb59f2c7f1a1b831c95b8d9f7edde99ca1920be94623109949d60c5b3c"
  license "MIT"
  head "https://github.com/mainak55512/qwe.git", branch: "main"

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
