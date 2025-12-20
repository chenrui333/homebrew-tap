class Opamui < Formula
  desc "TUI for OPAM packages"
  homepage "https://github.com/nlamirault/opamui"
  url "https://github.com/nlamirault/opamui/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7e92c70119216c482d488e4ed88f56e9a7e9f994c4ff6359e90d5088f0d04607"
  license "Apache-2.0"
  head "https://github.com/nlamirault/opamui.git", branch: "main"

  depends_on "dune" => :build
  depends_on "ocamlbuild" => :build
  depends_on "ocaml"

  def install
    system "dune", "build", "@install"
    system "dune", "install", "--prefix=#{prefix}", "--mandir=#{man}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opamui --version")
  end
end
