class Opamui < Formula
  desc "TUI for OPAM packages"
  homepage "https://github.com/nlamirault/opamui"
  url "https://github.com/nlamirault/opamui/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7e92c70119216c482d488e4ed88f56e9a7e9f994c4ff6359e90d5088f0d04607"
  license "Apache-2.0"
  head "https://github.com/nlamirault/opamui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6836a40d993b3e39ecbef68c292c107756e12385bb9a2d2b225c6ea8e96648e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe9e796be2298486b29dd4561b670c7c0002e37ef679044b56a1dbe7811bc76b"
    sha256                               arm64_linux:   "0e8e87a13ff6be57f9017111cb034d4e2dc422be680e951f7aa3f60f9879508a"
    sha256                               x86_64_linux:  "841f4d7ed65f7832899177b6e60186d3ee9554b150b62a665ace8824ad0a594d"
  end

  depends_on "dune" => :build
  depends_on "ocamlbuild" => :build
  depends_on "opam" => :build
  depends_on "ocaml@4"

  deny_network_access!

  def fetch
    ENV.prepend_path "PATH", formula_opt_bin("ocaml@4")
    ENV["OPAMROOT"] = buildpath/".opam"
    ENV["OPAMYES"] = "1"

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    system "opam", "install", ".", "--deps-only", "--yes", "--no-depexts", "--download-only"
  end

  def install
    ENV.prepend_path "PATH", formula_opt_bin("ocaml@4")
    ENV["OPAMROOT"] = buildpath/".opam"
    ENV["OPAMYES"] = "1"

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
