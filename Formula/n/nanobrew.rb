class Nanobrew < Formula
  desc "Fast package manager for macOS and Linux"
  homepage "https://nanobrew.trilok.ai"
  url "https://github.com/justrach/nanobrew/archive/refs/tags/v0.1.192.tar.gz"
  sha256 "2d034c2d291e8b298a01072b3920ba576ce57afa45bac2ff28e317eb3a7375bc"
  license "Apache-2.0"
  head "https://github.com/justrach/nanobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "593f975132410a47b5812b8104e799ded00881f9547a791e1408f2deb0ddc172"
    sha256 arm64_sequoia: "f5b68c04a709e785f9a195ffec6b8d9a502dcff8978361e7422b8b7afebd2e2c"
    sha256 arm64_sonoma:  "5562ccc8b7711e58d684e042c6dc8c61f18a102f43e3e9b32cce2f3abd88635f"
    sha256 arm64_linux:   "81931a31941e1502662577216f2e2c59d49ddd0c5fe49fcd30ae93df1bb122ab"
    sha256 x86_64_linux:  "2da22b22a8b15d26e106c2d407c4d30d2653d66f8a7185ac9b7baafade40282c"
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

    assert_match "compdef _nb nb", shell_output("#{bin}/nb completions zsh")
  end
end
