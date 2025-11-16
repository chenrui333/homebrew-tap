class Oatmeal < Formula
  desc "TUI to chat with large language models"
  homepage "https://github.com/dustinblackman/oatmeal"
  url "https://github.com/dustinblackman/oatmeal/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "dee11f69eabc94adeb58edc5ecf5b51556bd4dec3a6a3d66c3a5e603aa8a0256"
  license "MIT"
  head "https://github.com/dustinblackman/oatmeal.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "update", "-p", "time"
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"oatmeal", "completions", "--shell", shells: [:bash, :zsh, :fish, :pwsh])
    (man1/"oatmeal.1").write Utils.safe_popen_read(bin/"oatmeal", "manpages")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oatmeal --version")
    output = shell_output("#{bin}/oatmeal config default")
    assert_match "# The initial backend hosting a model to connect to", output
  end
end
