class FreezeCli < Formula
  desc "Generate images of code and terminal output"
  homepage "https://github.com/charmbracelet/freeze"
  url "https://github.com/charmbracelet/freeze/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "f0e959bc0c83c0a00d9da8362ca0d928191ad3207fc542c757e9eddda4014e08"
  license "MIT"
  head "https://github.com/charmbracelet/freeze.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}", output: bin/"freeze")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/freeze --version")
    system bin/"freeze", "--execute", "echo 'freeze test'", "--language", "bash"
    assert_path_exists testpath/"freeze.png"
  end
end
