class Nanobrew < Formula
  desc "Fast package manager for macOS and Linux"
  homepage "https://nanobrew.trilok.ai"
  url "https://github.com/justrach/nanobrew/archive/refs/tags/v0.1.201.tar.gz"
  sha256 "e8b97dc743686e97f3777133cb043e1e36c8ef8c155b933565f263afc01e61ac"
  license "Apache-2.0"
  head "https://github.com/justrach/nanobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "50ef50279871aa7a2d1799f5b19565c172d1f22eebf9aa279c12556786bfe36b"
    sha256 arm64_sequoia: "fc97ca62ccb49ef772a1e4c76241e0eb86ea5df35350a29b3e41e115816e26d1"
    sha256 arm64_sonoma:  "e451075c5985e5dc2a37319e23decea9f1a1aead424d99dad3d59690d26b2d0a"
    sha256 arm64_linux:   "e70d0dbca7265734ff1f70909cb94d35d5458eb481b77150ff92f57c45f8a16c"
    sha256 x86_64_linux:  "eb0eba247c631195b88a266da8ac5a16220faf91a38d11864bc58098162e70ac"
  end

  depends_on "zig" => :build

  conflicts_with "nb", because: "both install `nb` binaries"

  def install
    # Native Linux builds use std.c APIs, so link libc like upstream's Linux cross-compile targets.
    inreplace "build.zig",
              "    b.installArtifact(exe);",
              "    if (target.result.os.tag == .linux) exe.root_module.link_libc = true;\n    b.installArtifact(exe);"

    zig = Formula["zig"].opt_bin/"zig"
    system zig, "build", *std_zig_args
    generate_completions_from_executable(bin/"nb", "completions")
  end

  def caveats
    <<~EOS
      Run `sudo nb init` before installing packages with nanobrew.
    EOS
  end

  test do
    output = shell_output("#{bin}/nb help")
    assert_match "nanobrew", output
    assert_match version.to_s, output
    assert_match "nb <command> [arguments]", output
  end
end
