class GlslAnalyzer < Formula
  desc "Language server for GLSL"
  homepage "https://github.com/nolanderc/glsl_analyzer"
  url "https://github.com/nolanderc/glsl_analyzer.git",
      tag:      "v1.6.0",
      revision: "a79772884572e5a8d11bca8d74e5ed6c2cf47848"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30fc4c8e153ae106e527610c5cc5c491910d9ed64215197dbb02033360986a80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d8967020ce7f070e6751a0e48ed29645f8f4538491eb6c0ed6eace907118267"
    sha256 cellar: :any_skip_relocation, ventura:       "f47b98e47a5ca4d44a8aaff21c308a6c5f35ebf73587ff39d517f3d723db5722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4246054679b96000ea1560bf7e6c4bfbfd5a49d245f485e68628be7dea9daa6d"
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
