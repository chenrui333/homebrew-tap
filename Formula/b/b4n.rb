class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.3.8.tar.gz"
  sha256 "80a6ee11879381c761808e508e95023c4c9ede4d7c857654a95c2c2f9044ceeb"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f9c44c4613c7f6db99af507c3af083aaa4c42f34e36cfaceb5798f67542ac1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a5264714db0ed264b20c48f23cc9ef0a24cd2ea6c94156a21939b3505bfaa8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7aca7827eb531c549d401765fd5a2c61b0adb878854d9a39250c148591e323c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77c8b0be08969335c3c9063bf408de97176dcc6edbe53d421ac152610b57532c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2ec7612b62ab92c2582d63b93b12f0636999389654c31f3bba55ee458e9cf1a"
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
