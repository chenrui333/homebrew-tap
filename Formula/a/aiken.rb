# framework: clap
class Aiken < Formula
  desc "Modern smart contract platform for Cardano"
  homepage "https://aiken-lang.org/"
  url "https://github.com/aiken-lang/aiken/archive/refs/tags/v1.1.12.tar.gz"
  sha256 "d222a0d4319a13b04045ef94c538e6b770b7cbbd3bee75fe4caf15c60cf6f80e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3dd5f2c76a9dfb453d3f745c97b3d0f4a7d9a6c8bef804ae9ad151206058b9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02233f6056c98b862bd5455d0e5a77354488b635eecd994fd88ce2c7d9e7b8d7"
    sha256 cellar: :any_skip_relocation, ventura:       "167a3080631a932919ccc92bb66114200f17b12e23b150a3d97d1ef3493ac887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43113b981a33800c08cd464c2ede9244e418cc93a498fcd0c59d12c690c3a6f2"
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
