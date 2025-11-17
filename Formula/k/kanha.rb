class Kanha < Formula
  desc "Web-app pentesting suite written in rust"
  homepage "https://github.com/pwnwriter/kanha"
  url "https://static.crates.io/crates/kanha/kanha-0.1.2.crate"
  sha256 "dea79d04f2c29a742dca69642e473ceca5e458f2a6bf9cfd88847e9124057baa"
  license "MIT"
  head "https://github.com/pwnwriter/kanha.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kanha --version")

    (testpath/"test_urls.txt").write "https://httpbin.org/status/200"

    output = shell_output("#{bin}/kanha status -f #{testpath}/test_urls.txt")
    assert_equal <<~EOS, output
      https://httpbin.org/status/200 [200]
    EOS
  end
end
