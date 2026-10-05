class Jetzig < Formula
  desc "Web framework written in Zig"
  homepage "https://github.com/jetzig-framework/jetzig"
  url "https://github.com/jetzig-framework/jetzig/archive/182ceee17f8147145b32a47d060071025ed44b74.tar.gz" # for zig 0.14.0
  version "0.0.1" # fake version number
  sha256 "c251cd477de9d9b815a18e2ccfed03e03f3632d3e1f2087a28439847678c03fd"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2281363f3df8ddaa80619ec0f6e1b5dfef89bc07e7e0e4f1b86c8d0317c7e284"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d3ba1dec0d178d5d6102f30056383a14a216b32c23c7c81bed2d9a081f18cbb"
    sha256 cellar: :any_skip_relocation, ventura:       "28158e24d44810c78b2d2459a9f083922cd4c39b643372859a81dd0b8e7caca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4651ded8b65c79b4db6057010bd5e375ed0d098b0a8d108e2a641d37e58319c0"
  end

  # The pinned commit targets Zig 0.14; newer Zig rejects its dependency manifests.
  depends_on "zig@0.14" => :build

  deny_network_access!

  def zig_env
    return {} unless OS.mac?

    # Select Zig's bundled libc stubs; SDK 26's arm64e-only stubs break Zig 0.14.
    developer_dir = formula_opt_prefix("zig@0.14").to_s
    { "DEVELOPER_DIR" => developer_dir, "HOMEBREW_DEVELOPER_DIR" => developer_dir }
  end

  def fetch
    ENV["ZIG_GLOBAL_CACHE_DIR"] = buildpath/"zig-cache"
    cd "cli" do
      with_env(zig_env) do
        system "zig", "build", "--fetch"
      end
    end

    # Zig 0.14 stores nested dependencies under named hashes, but their parents look up legacy hashes.
    cache = buildpath/"zig-cache/p"
    ln_s "N-V-__8AAAOLAACqscul40pNN-WUdWQuGSCOYnyXgKXRxOqz",
         cache/"1220aab1cba5e34a4d37e59475642e19208e627c9780a5d1c4eab3661994a2872ca0"
    ln_s "N-V-__8AAHOzAQBh8wB371GN1DXTl1mKs8Rdqj0sJea0U4P7",
         cache/"122061f30077ef518dd435d397598ab3c45daa3d2c25e6b45383fb94d0bd2c3af1af"
    ln_s "pg-0.0.0-AAAAADndBQDCVfY3_svxhenxusCtwVHlmcdmaxWRGzIn",
         cache/"1220c255f637fecbf185e9f1bac0adc151e599c7666b15911b3227b0cc89c993acdc"
    ln_s "zul-0.0.0-AAAAAB1CBwAz3vYuySVkzEk2y4cPRNnm6K7OFSv3K-Vk",
         cache/"122033def62ec92564cc4936cb870f44d9e6e8aece152bf72be564b1cac542638c76"
  end

  def install
    ENV["ZIG_GLOBAL_CACHE_DIR"] = buildpath/"zig-cache"

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

    cd "cli" do
      with_env(zig_env) do
        system "zig", "build", *args
      end
    end
  end

  test do
    # test is not consistent
    # expected = if OS.mac? && MacOS.version < :sonoma
    #   "Error fetching from GitHub"
    # else
    #   "Unable to detect Jetzig project directory"
    # end
    # `update` runs `zig fetch` against GitHub; extra positional arguments are rejected before that.
    output = shell_output("#{bin}/jetzig update a b 2>&1", 1)
    assert_match "Expected at most 1 positional argument", output

    # currently it is hanging
    # pipe_output("#{bin}/jetzig init", "test\nbrewtest\n")

    # assert_path_exists testpath/"brewtest"
    # assert_match "const jetzig", (testpath/"brewtest/build.zig").read

    system bin/"jetzig", "--help"
  end
end
