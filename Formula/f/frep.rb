class Frep < Formula
  desc "Fast find-and-replace CLI"
  homepage "https://github.com/thomasschafer/frep"
  url "https://github.com/thomasschafer/frep/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "f09e8ceb5e3f411b19548ce9b70c7bf9180dfc1ee75ee3c3784479adacc656d4"
  license "MIT"
  head "https://github.com/thomasschafer/frep.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "frep")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frep --version")

    (testpath/"input.txt").write "Hi, World!"
    system bin/"frep", "-d", testpath, "Hi", "Hello"
    assert_equal "Hello, World!", (testpath/"input.txt").read
  end
end
