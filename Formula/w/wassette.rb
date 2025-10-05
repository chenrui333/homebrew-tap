class Wassette < Formula
  desc "Security-oriented runtime that runs WebAssembly Components via MCP"
  homepage "https://github.com/microsoft/wassette"
  url "https://github.com/microsoft/wassette/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "552e5a31431abf37a7476ad343bbfc194d81b5b421dec1546345cdcc09fb5faa"
  license "MIT"
  head "https://github.com/microsoft/wassette.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wassette --version")

    output = shell_output("#{bin}/wassette component list")
    assert_equal "0", JSON.parse(output)["total"].to_s
  end
end
