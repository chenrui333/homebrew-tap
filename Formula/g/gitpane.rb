class Gitpane < Formula
  desc "Multi repo Git workspace dashboard for the terminal"
  homepage "https://github.com/affromero/gitpane"
  url "https://github.com/affromero/gitpane/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "826000a0de0920f582e969526acf3d0d99ec7d67d74a87af47c217d93f65be27"
  license "MIT"
  head "https://github.com/affromero/gitpane.git", branch: "main"

  depends_on "openssl@3"
  depends_on "rust" => :build

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitpane --version 2>&1")
  end
end
