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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c704517439a8624af23b900bd93117667dcd66ac3a28ac11a34bd87794a6736b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e72f94062bd855f2f588c69fb42118b35fd69f8ec3960ae78b7763bda3e0f87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38b45ed3a0fe4fa7e55f7c2e97ad3b6c1d1480979539e543ce2922b897151473"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a92ffda1cd21a351b6bb79c28f466e19f6538887adda67fe4cc87be806e22129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a36e12df2713e67dd4324e83083731479d58839f1b0ac417aafe923de42ec129"
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
