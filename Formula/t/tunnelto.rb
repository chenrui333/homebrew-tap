class Tunnelto < Formula
  desc "Expose your local web server to the internet with a public URL"
  homepage "https://github.com/agrinman/tunnelto"
  url "https://github.com/agrinman/tunnelto/archive/refs/tags/0.1.18.tar.gz"
  sha256 "100a8364d8fa4ac66e20f34b781c7b3fcee852eaa1e2ee29a05d40e4178269d2"
  license "MIT"
  head "https://github.com/agrinman/tunnelto.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "update", "-p", "openssl", "--precise", "0.10.68"
    system "cargo", "update", "-p", "openssl-sys", "--precise", "0.9.116"
    system "cargo", "install", *std_cargo_args(path: "tunnelto")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tunnelto --version")

    help = shell_output("#{bin}/tunnelto --help")
    assert_match "expose your local web server", help.downcase
  end
end
