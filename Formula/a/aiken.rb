# framework: clap
class Aiken < Formula
  desc "Modern smart contract platform for Cardano"
  homepage "https://aiken-lang.org/"
  url "https://github.com/aiken-lang/aiken/archive/refs/tags/v1.1.14.tar.gz"
  sha256 "1103465d4a60a0d8d259bcc53e813d13f90177a8a46d28b5ce29d56a1e184b89"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8114335867b55801633e57e4f19f1fe622134a007af941e9640fc22c5a6fda90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd7f91f1e38e2cf2e729bbd6f370527538d9d59639b8e83276f34c181ad60402"
    sha256 cellar: :any_skip_relocation, ventura:       "1ba66d21002c59699735f87b7bf97167dd3df8fdbbd630078642101939cb2602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "793a0e86b7981f44cf7f4d806a52152ae861d591591e0d775fe1a552e8d6db60"
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
