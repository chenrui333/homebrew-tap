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

  depends_on "rust" => :build

  # from `.gitmodules`
  resource "artifacts" do
    url "https://github.com/mitex-rs/artifacts.git",
        tag:      "v0.2.4",
        revision: "9eb762afa001b36205408c7615a73e5dfaa6f80a"
  end

  def install
    (buildpath/"crates/mitex-spec-gen/assets/artifacts").install resource("artifacts")

    system "cargo", "install", *std_cargo_args(path: "crates/mitex-cli")

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
