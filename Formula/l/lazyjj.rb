# framework: clap
class Lazyjj < Formula
  desc "TUI for Jujutsu/jj"
  homepage "https://github.com/Cretezy/lazyjj"
  url "https://github.com/Cretezy/lazyjj/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "f92f084b9483e760a17807e49ad5547999074f14e62acd6ca413388a6d669f3c"
  license "Apache-2.0"
  head "https://github.com/Cretezy/lazyjj.git", branch: "main"

  depends_on "rust" => :build
  depends_on "jj"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["LAZYJJ_LOG"] = "1"

    assert_match version.to_s, shell_output("#{bin}/lazyjj --version")

    output = shell_output("#{bin}/lazyjj 2>&1", 1)
    assert_match "Error: No jj repository found", output
    assert_path_exists testpath/"lazyjj.log"
  end
end
