class GitVain < Formula
  desc "Vanity git"
  homepage "https://github.com/will/git-vain"
  url "https://github.com/will/git-vain/archive/cafe5851b19c421193617112ee50e68f04863f38.tar.gz"
  version "0.0.0-unstable" # unstable
  sha256 "e8caad399e02cbee57a019d6d939142130e9fa85af881ea83cf9f865dcd29f57"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_sequoia: "fc88d0dcb4e3f7ae3627d0ab6aaa36c57ef4b385e57a112574f0f96384e0b909"
    sha256 cellar: :any, arm64_sonoma:  "c142f7e8044e069f0ca793d9593e6ed87e52cecdc998072735247565acb10887"
  end

  depends_on "pkgconf" => :build
  depends_on "zig" => :build
  depends_on arch: :arm64 # rpath issue for intel build
  depends_on "libgit2"
  depends_on :macos # linux build is crashing, see https://github.com/chenrui333/homebrew-tap/pull/62/#issuecomment-2617948916

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
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "test"
    assert_match("found", shell_output("#{bin}/git-vain 2>&1"))

    commit_sha = shell_output("git rev-parse HEAD").chomp
    output = shell_output("#{bin}/git-vain #{commit_sha} 2>&1")
    # Strip ANSI escape codes like "\x1b[1;4m" or "\x1b[0m"
    stripped = output.gsub(/\x1b\[[0-9;]*m/, "")
    assert_match(/already at target: \w{38}/, stripped)
  end
end
