class Nanobrew < Formula
  desc "Fast package manager for macOS and Linux"
  homepage "https://nanobrew.trilok.ai"
  url "https://github.com/justrach/nanobrew/archive/refs/tags/v0.1.194.tar.gz"
  sha256 "e20c8220a54885cfaa83a453c340d8e4c615a6c5f771d0e7394f0892a4dfbbfd"
  license "Apache-2.0"
  head "https://github.com/justrach/nanobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "1fc788515a8e09c39dbb84f7085601cb8132a713c8ed64419d93d255a425a2c5"
    sha256 arm64_sequoia: "09d243ed340d81a48d59e621e919c5b2473fcf17f05ae400932a57cee60e514a"
    sha256 arm64_sonoma:  "be9f6b40b6d0f344dcfff18cd2ad97510690ad5df645f91cde63e186b8ab85c1"
    sha256 arm64_linux:   "01f47560e0431a77888b45a26eb70b6331f8d2bf7fb2446665b318b60fbbd474"
    sha256 x86_64_linux:  "8bc76a220a5d744c8d57a9d88ecaedd54d96f0071966f830b065356a67d69bc8"
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
