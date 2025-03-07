class Matcha < Formula
  desc "Daily Digest Reader"
  homepage "https://github.com/piqoni/matcha"
  url "https://github.com/piqoni/matcha/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "a24de22ba5614be70563a8eeda579f16479af7f809373fe15b0eb869e1c174db"
  license "MIT"
  head "https://github.com/piqoni/matcha.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"matcha"
    assert_match "markdown_dir_path", (testpath/"config.yaml").read
  end
end
