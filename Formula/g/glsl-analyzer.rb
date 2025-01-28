class GlslAnalyzer < Formula
  desc "Language server for GLSL"
  homepage "https://github.com/nolanderc/glsl_analyzer"
  url "https://github.com/nolanderc/glsl_analyzer.git",
      tag:      "v1.5.1",
      revision: "5b9848b2dd563170cd702c41443659d6b3cb11de"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fed318c8d224e2a07fdffa959cf6b8e8d9c247e290f1640468f475fab0cd364b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9825ac041cb64ec021c521a832825e7884e1975a796b9c1e29dc67a1651c1fe7"
    sha256 cellar: :any_skip_relocation, ventura:       "40095b4656368f1020fe0a6c8b293161eb95b8da1069d8b7fd88c8253d9608a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "456c597b9a83b3d4e83a2728f3d28619409f55e12f432cf7e696f9110b982f11"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseSafe
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/glsl_analyzer --version")

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/glsl_analyzer", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
