class Mitex < Formula
  desc "Minimal TeX Equations Support"
  homepage "https://github.com/mitex-rs/mitex"
  url "https://github.com/mitex-rs/mitex/archive/5fc83b64ab5e0b91918528ef2987037866e24086.tar.gz"
  version "0.2.5"
  sha256 "9cacda1201c1169b2371998a88f090cb1da50a7b10db271152e99390f44b8ce3"
  license "Apache-2.0"

  livecheck do
    skip "no tagged releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a3e0a789553f80179054ad712bca89b9f1ceb5cf17e4dcd537259d8c74e85ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e578b53c5dacf0198e7e22b558efbeac3c27d53495c50984b5fd1465d4967b57"
    sha256 cellar: :any,                 arm64_linux:   "fd18a3ca88d95da8571e621dffda051ae2364e06098bc8e011b3014a09f1c3f8"
    sha256 cellar: :any,                 x86_64_linux:  "322b484e36f171aa2c5a1a7ef2eba2f69688def27244e9a141ef01341ceb0b65"
  end

  depends_on "rust" => :build

  # from `.gitmodules`
  resource "artifacts" do
    url "https://github.com/mitex-rs/artifacts.git",
        tag:      "v0.2.4",
        revision: "9eb762afa001b36205408c7615a73e5dfaa6f80a"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    (buildpath/"crates/mitex-spec-gen/assets/artifacts").install resource("artifacts")

    system "cargo", "install", *std_cargo_args(path: "crates/mitex-cli")

    [bash_completion/"mitex", fish_completion/"mitex.fish", zsh_completion/"_mitex"].each do |completion_file|
      rm completion_file if completion_file.exist?
    end
    generate_completions_from_executable(bin/"mitex", "completion")
    system bin/"mitex", "manual", man1
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mitex --version")

    (testpath/"main.tex").write <<~TEX
      \\newcommand{\\f}[2]{#1f(#2)}
        \\f\\relax{x} = \\int_{-\\infty}^\\infty
          \\f\\hat\\xi\\,e^{2 \\pi i \\xi x}
          \\,d\\xi
    TEX

    system bin/"mitex", "compile", "main.tex", "main.typ"
    assert_path_exists testpath/"main.typ", "main.typ was not generated"
  end
end
