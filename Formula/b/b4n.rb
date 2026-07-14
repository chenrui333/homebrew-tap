class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "55276254c9bb6c6c54899d44aa94e79aafb280d2ebd21f387d9baca27676201f"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23410100b36838b2aac97eb41f67082092cc36d90e81631f90717d2e6ec3ee48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83658fd90afb3f4d98d333160b44eb81a5e1d1650a509fd1bad0caa92fb868ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aee543e3592beb0ce736e41e2de2d8e2f633bad2d54ca61b49c4c7312390398b"
    sha256 cellar: :any,                 arm64_linux:   "467c77bb20ed58aa266cbddff120208c14e6c0ad42726502793858e871d7f1bf"
    sha256 cellar: :any,                 x86_64_linux:  "f21e70bfe1dfb46f475a674105a16cb320b8a858f9480cc1bc9fed49b03c3ab6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4n --version")
    assert_match "Error: kube config file not found", shell_output("#{bin}/b4n 2>&1", 1)
  end
end
