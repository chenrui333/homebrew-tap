class Dvm < Formula
  desc "Deno Version Manager"
  homepage "https://dvm.deno.dev"
  url "https://github.com/justjavac/dvm/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "3b9bb668c6bdac67c201c7de823c9737d302687a8bae98cab881b24c59207a4e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4441ce2fdddfa5c3e6f3d85045eeec9f825c53400097cd3efdb4694f13dea10f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "784cfb7ee107fa45646b03825a34b5ae82268ab3ed8800b8100a7a22d09979c4"
    sha256 cellar: :any_skip_relocation, ventura:       "ccc3ba43358e5d8af80cb996dc1d84698355e1a5244211e21df4bc7a873faa8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7d743189efc2da8178c724a5cf3ad0bbf862e8801da73641d1b34fd2bbd062b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dvm", "completions")
  end

  test do
    ENV["HOME"] = testpath

    assert_match <<~EOS, shell_output("#{bin}/dvm info")
      dvm 1.9.0
      deno -
      dvm root #{testpath}/.dvm
    EOS

    system bin/"dvm", "--version"
  end
end
