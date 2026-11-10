class Hazelnut < Formula
  desc "Terminal-based automated file organizer"
  homepage "https://github.com/ricardodantas/hazelnut"
  url "https://github.com/ricardodantas/hazelnut/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "a35cdda06d8051e7935b5357a7cd1c0cb7c0fcff86beaa455c82fc99534277e5"
  license "GPL-3.0-or-later"
  head "https://github.com/ricardodantas/hazelnut.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad99ba308d5d361e05622ceaee5407f4551ed2a3b715b8038f6be2a3bff2ac39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4096e8f4ff7b84f7d6389a33fd2d46783594853797673427451705c48860cc2"
    sha256 cellar: :any,                 arm64_linux:   "9d03bbad513f85b2ad6d5d40eb84a0ba161c6cee69925b1bc32af7e7e06b081a"
    sha256 cellar: :any,                 x86_64_linux:  "4fef61c2766e772a527116b261fe64387d341596e2b7e35bc25a310029652cc4"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hazelnut --version")

    downloads = testpath/"Downloads"
    downloads.mkpath

    config = testpath/"config.toml"
    config.write <<~TOML
      [[watch]]
      path = "#{downloads}"
      recursive = false

      [[rule]]
      name = "pdfs"

      [rule.condition]
      extension = "pdf"

      [rule.action]
      type = "move"
      destination = "#{testpath/"PDFs"}"
    TOML

    output = shell_output("#{bin}/hazelnut check --config #{config}")
    assert_match "Config is valid", output
    assert_match "1 watch paths", output
    assert_match "1 rules", output
    assert_match "pdfs", shell_output("#{bin}/hazelnut --config #{config} list")
  end
end
