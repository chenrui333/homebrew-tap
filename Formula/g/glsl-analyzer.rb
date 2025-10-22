class GlslAnalyzer < Formula
  desc "Language server for GLSL"
  homepage "https://github.com/nolanderc/glsl_analyzer"
  url "https://github.com/nolanderc/glsl_analyzer.git",
      tag:      "v1.7.1",
      revision: "d595fb18c165f9e6c0c99a39dd457b993cfdd9aa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6a411a1e429a920ff5af1a83003ff70f6de9f6d819b9f26c01c1884d16b3c6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a1a3e7c6bd5389e70f9e6c6a2d42ddb65900ce69c6b842443f28678c81fddaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "160e720a0c734319652c447ef2d91cb61b93f1a9e3babbe262be65cc8c48427b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02ea89a7478376615d96079831c8ad0c9ee105b43c31a6f88447d17bd11db73a"
  end

  depends_on "zig@0.14" => :build

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
