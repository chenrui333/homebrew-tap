class Mitex < Formula
  desc "Minimal TeX Equations Support"
  homepage "https://github.com/mitex-rs/mitex"
  url "https://github.com/mitex-rs/mitex/archive/refs/tags/0.2.7.tar.gz"
  sha256 "6e63aa314adb8963a89c80bf891884d49ad4ae489a1979b5e1bb7b61a874cfd8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "3a19c33a0189a1a55ca44c329f93f15ad078dc6e7bcd75ff821ad84fe1275adb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5adb0288dadc98b7a5da7f4bfaf52840dd84a7c11c2fc65097afe50f9063571c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67667b07c455e75114dab635e2c2158f14a497db3c51d9532e7f4670b5391c9b"
    sha256 cellar: :any,                 arm64_linux:   "0894a4ab3b06fcf82da0d05f57001509e4b274144915d9183329d9334d1743b9"
    sha256 cellar: :any,                 x86_64_linux:  "8474b5ae772320c2fec6d606816b7c04d657ae8a064cd08bfdee2afef83d7dd9"
  end

  depends_on "rust" => :build

  # Supplies the default specification embedded by mitex-spec-gen at compile time.
  resource "artifacts" do
    url "https://static.crates.io/crates/mitex-spec-gen/mitex-spec-gen-0.2.4.crate"
    sha256 "a1e9ef918ec9c2a14e60ebb20275684b483d23afb5c3314127c9eb46ce74ae68"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    spec_dir = buildpath/"crates/mitex-spec-gen/assets/artifacts/spec"
    resource("artifacts").stage do
      spec_dir.install "assets/artifacts/spec/default.rkyv"
    end

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
