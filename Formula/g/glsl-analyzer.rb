class GlslAnalyzer < Formula
  desc "Language server for GLSL"
  homepage "https://github.com/nolanderc/glsl_analyzer"
  url "https://github.com/nolanderc/glsl_analyzer.git",
      tag:      "v1.7.1",
      revision: "d595fb18c165f9e6c0c99a39dd457b993cfdd9aa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f547b77849ff6679ad56f0a44b2bc45afc02f0d5e56b8ad89e3665e38fb0f0eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3398c52157d6efbb61293659be6a6af57cdce6dec9736ccb730dd13e2acb365c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4731449f8041328d01be3eedc5fa2953078d3a6ed9c85ca8bfe1934f4efc3249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88df97170594fa3f5087979a77b974899ccf3d51126e44df8e7f3dad72a35e76"
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
