# framework: clap
class Aiken < Formula
  desc "Modern smart contract platform for Cardano"
  homepage "https://aiken-lang.org/"
  url "https://github.com/aiken-lang/aiken/archive/refs/tags/v1.1.19.tar.gz"
  sha256 "87a74203a8ff4a82aa8c33f07ed4f5fc1fbda9c69a38b13bd2abf24146f9811d"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73cb7ae5466b09c1202728f4e73403b45658d347ee9e9a120b448551e2dd29c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb00b90907ce1ab7237eed919c9dbad022e8da83e8dc50ab5bd14fce109dea87"
    sha256 cellar: :any_skip_relocation, ventura:       "eaf0466ed4907c53db9fb7bbfd4e40002bf0422330dbe53cfb6b315a12be57b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a8518e207f037398d83517977f3352608cbab070d33587e7bb1cd5de5cd6f2e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aiken")

    generate_completions_from_executable(bin/"aiken", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aiken --version")

    system bin/"aiken", "new", "brewtest/hello"
    assert_path_exists testpath/"hello/README.md"
    assert_match "brewtest/hello", (testpath/"hello/aiken.toml").read
  end
end
