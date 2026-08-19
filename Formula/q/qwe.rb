class Qwe < Formula
  desc "File-first atomic version control system"
  homepage "https://mainak55512.github.io/qwe/"
  url "https://github.com/mainak55512/qwe/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "7258f9d73bb0b580b02f3db8e09d714148a7ae041e4f231ebc27d68ffd004c04"
  license "MIT"
  head "https://github.com/mainak55512/qwe.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5740af46f49043b99f4de8c21f8614d19753ca17d6cec389ede8618d4e2a577"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5740af46f49043b99f4de8c21f8614d19753ca17d6cec389ede8618d4e2a577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5740af46f49043b99f4de8c21f8614d19753ca17d6cec389ede8618d4e2a577"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80da1cf212ec953e43d9e26cdd0e0728a2f66d0aa3d53cfa4c0e7a82a0488cc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8929a73f9f7c9d3b589587694d37f4f86e74c7e9bb4618a5158cd760759fdade"
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
