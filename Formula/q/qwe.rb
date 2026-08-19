class Qwe < Formula
  desc "File-first atomic version control system"
  homepage "https://mainak55512.github.io/qwe/"
  url "https://github.com/mainak55512/qwe/archive/refs/tags/v0.3.3-a.tar.gz"
  version "0.3.3-a"
  sha256 "262d28a522ad6ce4998ac4a16d4130b50c01f03875b0d3ff51ca9325a0ba2eb5"
  license "MIT"
  head "https://github.com/mainak55512/qwe.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bec913406a67925950ae3f139e556a49a7890e3d71dfdd3ab76852e8c6ed36a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bec913406a67925950ae3f139e556a49a7890e3d71dfdd3ab76852e8c6ed36a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bec913406a67925950ae3f139e556a49a7890e3d71dfdd3ab76852e8c6ed36a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07e64d711e984e2679d992864d2b64e8e2c19ce531c60de42283370b60c07dba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eb5f1dafa51f625052e6c4716e5edcd4ed3536fac69f2af1d00c5f3a6ade2ce"
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
