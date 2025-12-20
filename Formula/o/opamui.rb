class Opamui < Formula
  desc "TUI for OPAM packages"
  homepage "https://github.com/nlamirault/opamui"
  url "https://github.com/nlamirault/opamui/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7e92c70119216c482d488e4ed88f56e9a7e9f994c4ff6359e90d5088f0d04607"
  license "Apache-2.0"
  head "https://github.com/nlamirault/opamui.git", branch: "main"

  depends_on "dune" => :build
  depends_on "ocamlbuild" => :build
  depends_on "opam" => :build
  depends_on "ocaml@4"

  def install
    ENV.prepend_path "PATH", Formula["ocaml@4"].opt_bin
    ENV["OPAMROOT"] = buildpath/".opam"
    ENV["OPAMYES"] = "1"

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    system "opam", "install", ".", "--deps-only", "--yes", "--no-depexts"
    system "opam", "exec", "--", "dune", "build", "@install"
    system "opam", "exec", "--", "dune", "install", "--prefix=#{prefix}", "--mandir=#{man}"
  end

  test do
    output = shell_output("#{bin}/opamui 2>&1")
    assert_match "Loading OPAM packages...", output
    assert_match "No packages found", output
  end
end
