class Opamui < Formula
  desc "TUI for OPAM packages"
  homepage "https://github.com/nlamirault/opamui"
  url "https://github.com/nlamirault/opamui/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7e92c70119216c482d488e4ed88f56e9a7e9f994c4ff6359e90d5088f0d04607"
  license "Apache-2.0"
  head "https://github.com/nlamirault/opamui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb40cdafbd7f8b725324d640951c1a9e9a811cc40297ac7fba5e397c19973c48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e10a37950d63c241be5ec23767f296e3cec79dd72fa2addf591cf680c4ff0503"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d12c658a5bf2a826d035de6f1a1bb08035e5c34da31df8ab5715b4bba1f10f10"
    sha256                               arm64_linux:   "6ba52c26393fe1a279617dd5bf815a3ea5d159742e24cb21e3e323ded11c7d35"
    sha256                               x86_64_linux:  "87d788098ece68202e093deebf74e4516ffb8d9acef6d081b713caff1c822501"
  end

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
