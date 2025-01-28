class GlslAnalyzer < Formula
  desc "Language server for GLSL"
  homepage "https://github.com/nolanderc/glsl_analyzer"
  url "https://github.com/nolanderc/glsl_analyzer.git",
      tag:      "v1.5.1",
      revision: "5b9848b2dd563170cd702c41443659d6b3cb11de"
  license "MIT"

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
