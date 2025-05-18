class Dela < Formula
  desc "Task runner"
  homepage "https://github.com/aleyan/dela"
  url "https://static.crates.io/crates/dela/dela-0.0.5.crate"
  sha256 "03509398a70218c059f2a9d19d1ddeb717faf463152df95336db1ee1883c3880"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36a9f2cc5bbc4a94f4d5ee0063acbda0a20599006e9de27af79a6b7321c521ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83a671c62d78b0964cfc7fd49bad410dc426eee44d0b0eb7e43d14aadf688056"
    sha256 cellar: :any_skip_relocation, ventura:       "4fe7f832abd2711278e0ffe86133e6638efda9cdf332b461fb7d3642503b2ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb3f68a5fb1a4023e64e139f98266c7e432d580e96feefcbf836f0b53d80bbcd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dela --version")

    (testpath/"Makefile").write <<~EOS
      all:
      \t@echo "Hello, World!"
    EOS

    assert_equal <<~EOS.strip, shell_output("#{bin}/dela list").strip
      Tasks from #{testpath}/Makefile:
        • all (make) - Hello, World!
    EOS
  end
end
