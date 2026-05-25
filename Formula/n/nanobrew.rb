class Nanobrew < Formula
  desc "Fast package manager for macOS and Linux"
  homepage "https://nanobrew.trilok.ai"
  url "https://github.com/justrach/nanobrew/archive/refs/tags/v0.1.194.tar.gz"
  sha256 "e20c8220a54885cfaa83a453c340d8e4c615a6c5f771d0e7394f0892a4dfbbfd"
  license "Apache-2.0"
  head "https://github.com/justrach/nanobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "bc2d0e572354872758dfb9c72333b9a4914bd3cd5d8638d8fecf56fcbc367cf2"
    sha256 arm64_sequoia: "84e7f31579322bf48c7aa4e45778a75ff645e8e881201ba8a4f0186a6094a488"
    sha256 arm64_sonoma:  "47afa05ffd042203778aa1506948ea49839192e1429413da815518faab3342b6"
    sha256 arm64_linux:   "a60444bb92b63efa2c8b245debaa5c830c6e97a072af061f9da5d94d6436e66a"
    sha256 x86_64_linux:  "ec7b3606fc709c800c418cd59a0295d704f9465b8f1ef5e0c2e6e16ea36364c0"
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
