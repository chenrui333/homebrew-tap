class Nanobrew < Formula
  desc "Fast package manager for macOS and Linux"
  homepage "https://nanobrew.trilok.ai"
  url "https://github.com/justrach/nanobrew/archive/refs/tags/v0.1.195.tar.gz"
  sha256 "6c79a3daf517fa6792f6b26f451da4511d53cc06a8afd840fec53100149accfe"
  license "Apache-2.0"
  head "https://github.com/justrach/nanobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 arm64_tahoe:   "a10e32b80a74c229e5e326b9477cb4db147d5333db172f551028b8abe3b9c57f"
    sha256 arm64_sequoia: "e7dba5754d98878d9fd361949768e5f66d500d3cb37779264eb8567927d74a1e"
    sha256 arm64_sonoma:  "93ddbd40eb17c5e1ecbb295b89985a25960c16fbd03687ffe20dcfa6d0ef148d"
    sha256 arm64_linux:   "c57f0223474897a1dbf50c4cde88c09fd73642b2f55972c0578ee18631c3012e"
    sha256 x86_64_linux:  "dae3a77cc071f85ea45e8e968415c80138227f817c168b2da3f4cf6d502a8a79"
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
