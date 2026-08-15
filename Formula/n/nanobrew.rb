class Nanobrew < Formula
  desc "Fast package manager for macOS and Linux"
  homepage "https://nanobrew.trilok.ai"
  url "https://github.com/justrach/nanobrew/archive/refs/tags/v0.1.207.tar.gz"
  sha256 "a0aba0dab58e44978cf937005e92f5303c267954e33d6dba3e0eebec8c5ff2a2"
  license "Apache-2.0"
  head "https://github.com/justrach/nanobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "41e88ef4400de63070795419d6f10c0a1134e973321a2f17298a2c8972ce6dd2"
    sha256 arm64_sequoia: "6e307a4218d58d866b9d66e676dbf79e14c644604cb2bd5935cad8e2f9587134"
    sha256 arm64_sonoma:  "f8bb75038890f9512fa9819c8ba0b857ad1a00be645fd78b28b47679263f296d"
    sha256 arm64_linux:   "40cb6578102d88dcb01d68bd4b74574582e844aec3ff2a81e0dca584fc9de824"
    sha256 x86_64_linux:  "2361b15b63111a99a6f4ecf5b7fd966017dfb0f28e58849c094b9a7a946b0ff4"
  end

  depends_on "zig" => :build

  conflicts_with "nb", because: "both install `nb` binaries"

  def install
    zig = formula_opt_bin("zig")/"zig"
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
