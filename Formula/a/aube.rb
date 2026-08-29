class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://github.com/endevco/aube"
  url "https://github.com/endevco/aube/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "821e285925b4020ff005afe6431430d90cd196543fbfb95c5a6d4b9d6dcffc8b"
  license "MIT"
  head "https://github.com/endevco/aube.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fd8ce9f05497c54d039012b747c2857126df034f9f51c935eafcee37f278693"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8caa957bd3d03ac0131cbd088858ff6bdbcff1919ebf9da397c1ceba10fc92b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbd34d33fda3497dfab2d4b35a1342ee866b9d6f14ab46e3a02ad80de6a78729"
    sha256 cellar: :any,                 arm64_linux:   "4594743b3a4d47aa38b062f13c5fa550f938e1032ad40994276dab9d94d305ea"
    sha256 cellar: :any,                 x86_64_linux:  "5590f67f338290e6dee39561ee042348b591213f1b6f6c3cefc6c2891d0a8c54"
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
