class Nanobrew < Formula
  desc "Fast package manager for macOS and Linux"
  homepage "https://nanobrew.trilok.ai"
  url "https://github.com/justrach/nanobrew/archive/refs/tags/v0.1.195.tar.gz"
  sha256 "6c79a3daf517fa6792f6b26f451da4511d53cc06a8afd840fec53100149accfe"
  license "Apache-2.0"
  head "https://github.com/justrach/nanobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "1af97fe92635db28196518c263d383628636c83aa7430f774928e22cdc7fb052"
    sha256 arm64_sequoia: "7dacb64b09f2fc7d544bd8ef78fe759d1e8702a60b0092ad7f82b7145d48568e"
    sha256 arm64_sonoma:  "02b8828036419ff7169f731077bbc0db9ab9ed68efea4aaf0e10ff3f3b262647"
    sha256 arm64_linux:   "ee9daea3b8fdadfd0b22f0882e5409330575a94967d915eaf031db7c0003500f"
    sha256 x86_64_linux:  "e47c3510e1e2d6c25bd07dc638202bcc1f43b6a328b4e1854ea8328c7065b7ac"
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
