class Dvm < Formula
  desc "Deno Version Manager"
  homepage "https://dvm.deno.dev"
  url "https://github.com/justjavac/dvm/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "3b9bb668c6bdac67c201c7de823c9737d302687a8bae98cab881b24c59207a4e"
  license "MIT"

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
