class Dela < Formula
  desc "Task runner"
  homepage "https://github.com/aleyan/dela"
  url "https://static.crates.io/crates/dela/dela-0.0.3.crate"
  sha256 "75d12e658f5e4555cb04e39d209ee75773c34005b9db34b4b9ff894dfc339e39"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9a76d0ebc74cd04023241263d6282e95d1de99de2e4e9adca2ca5567479edb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1c94899f560fed7f354fb05e8215088dd5b96c4cdc3c86e8b85aa67d2f3ba0d"
    sha256 cellar: :any_skip_relocation, ventura:       "b08823a2bbe19ebe3941141540d3c3dfef147898527394770809a62047a0ff80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fb96955c6be4fc9b9f8c5fa19f7a35ad9a91f578a7e823ebe8601a9c6831ab2"
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

    assert_equal <<~EOS, shell_output("#{bin}/dela list")
      Available tasks:

      From #{testpath}/Makefile:
        • all - Hello, World!
    EOS
  end
end
