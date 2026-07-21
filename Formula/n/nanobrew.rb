class Nanobrew < Formula
  desc "Fast package manager for macOS and Linux"
  homepage "https://nanobrew.trilok.ai"
  url "https://github.com/justrach/nanobrew/archive/refs/tags/v0.1.205.tar.gz"
  sha256 "99dc71fd2598574cfcf179df2c3287bc0def37f756c93ae28f9821ea516b586a"
  license "Apache-2.0"
  head "https://github.com/justrach/nanobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "0f1491abb186f7edc45b884c227373c6dbb69db0db5edf698ccf47be0010dee3"
    sha256 arm64_sequoia: "bbe57cd3f9bc954d6dd74d579328a3fed07908be9db26d4b9011d26f5bc4a122"
    sha256 arm64_sonoma:  "fabedf431ec5720881ca803e5594fcf05a6bf5892962f12a3a308b2f94aafa60"
    sha256 arm64_linux:   "b1510b80b4bc20197e2294e457cb6c3a4af510479f1aa265aba335ba791392af"
    sha256 x86_64_linux:  "a3c5b001045d24427eed238e159b54c7853a9d85d5283a8af9775afaa57b9875"
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
