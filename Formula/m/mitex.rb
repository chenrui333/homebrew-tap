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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cee75e8bd5abc217ace2223c28fbdd4ce893957646ace1dc079217067c54bf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc877355fa90fc2451f0307aea43df091816169ac826e9c0afef28a3cdbfad2f"
    sha256 cellar: :any_skip_relocation, ventura:       "7c52e1ef7c1065c0046e291d96d2900594b75243939f3439ffe6c81396f6f792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fec5daed2578b21fc0f88b6d5cbf2cb9e429b4f2ca95f181df63a651e1cea646"
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

    generate_completions_from_executable(bin/"mitex", shell_parameter_format: :clap)
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
