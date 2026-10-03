class GlslAnalyzer < Formula
  desc "Language server for GLSL"
  homepage "https://github.com/nolanderc/glsl_analyzer"
  url "https://github.com/nolanderc/glsl_analyzer.git",
      tag:      "v1.7.1",
      revision: "d595fb18c165f9e6c0c99a39dd457b993cfdd9aa"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5851c9ac5a8bc24b3b3baf0b56cb3dfefc3b230566be35f53f8ff2d46a526036"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6df45fbe6bfc89a9fe1097ac5c12e3731539bb2557814fae429dd4c06bd90cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa7cc7e85ea7ef6a0c35ef75b8a0d917833fbdce1cfe98c317b4ffa4dda34729"
  end

  depends_on "zig@0.14" => :build

  deny_network_access!

  def install
    if OS.mac?
      # Use Zig's bundled Darwin libraries instead of incompatible SDK stubs.
      developer_dir = buildpath/"CommandLineTools"
      (developer_dir/"SDKs").mkpath
      (developer_dir/"usr").make_symlink "#{MacOS::CLT::PKG_PATH}/usr"
      ENV["DEVELOPER_DIR"] = developer_dir.to_s
      ENV["HOMEBREW_DEVELOPER_DIR"] = developer_dir.to_s
    end

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
