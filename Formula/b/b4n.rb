class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "9d435e3205d5acf39d4b3c67d2e3ec65437a1407ac0573015fe2b35a73e5a3ab"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd47e4fb43d8f77df2f5234769145850c1d8a676a538f67c4b44ac5f91537033"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1da95e73d24f7f2074dc25e09f75e1920aef146da261fbac6d34a383d8f3a8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4e136d9d3919621c0ecfdfde350c67e3654f9ebd096632e5a43bf1acd224bcd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29ea5747b4eb8cd1cb97c39951dbeb8c57b2b4c8290c824c90254437d4bc35db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e179568766ad96a5185b93a39e9edb446e5688f9ac01e598ebff963b0522d214"
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
