class Zmpl < Formula
  desc "Templating language written in Zig"
  homepage "https://github.com/jetzig-framework/zmpl"
  license "MIT"

  stable do
    url "https://github.com/jetzig-framework/zmpl/archive/refs/tags/v0.14.1.tar.gz"
    sha256 "b569ba3012eb8641ecbd65e145f75169c38cda95a8ce0f4588f85e1136778224"
    # The tag identifies Zig compatibility; the package manifest still declares 0.0.1.
    version "0.0.1"

    # TODO: Use current Zig when a compatible release is tagged: https://github.com/jetzig-framework/zmpl/issues/53
    depends_on "zig@0.14" => [:build, :test]

    # TODO: Remove this patch when a tagged release includes upstream PR #72.
    # Fix Linux ARM compile-time page size, upstream PR ref, https://github.com/jetzig-framework/zmpl/pull/72
    patch do
      url "https://github.com/jetzig-framework/zmpl/commit/64707e8054a83c5220ff4cac1853e2294d41d311.patch?full_index=1"
      sha256 "2731f0478d0f7e48a2227d2fdaa1bc8ca454abb26efd861da53b69da2807cff7"
      type :unofficial
      resolves "https://github.com/jetzig-framework/zmpl/pull/72"
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc0190423afa42f481d5f2668828692e301efc77060acbe6b35b9cef864b3ef4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5d4c3ed651a961794d0e2bb89a30983929a8744eab4394845c740a8d4d9f5cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56eb4c8dc260d92cf8b572f373f29d0ef5949d4adfd3aeb92ea7d8b623618fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e0051fc9ae36388a2ef3905af0a5362f2d3cd8368ea6d5ffd34f5b9b9aac49c"
  end

  head do
    url "https://github.com/jetzig-framework/zmpl.git", branch: "main"
    depends_on "zig" => [:build, :test]
  end

  deny_network_access!

  def zig
    (formula_opt_bin(build.head? ? "zig" : "zig@0.14")/"zig").to_s
  end

  def zig_env
    return {} unless OS.mac?
    return {} if build.head?

    # TODO: Remove with the Zig pin when a compatible release is tagged: https://github.com/jetzig-framework/zmpl/issues/53
    # Select Zig's bundled libc stubs; SDK 26's arm64e-only stubs break Zig 0.14.
    developer_dir = formula_opt_prefix("zig@0.14").to_s
    { "DEVELOPER_DIR" => developer_dir, "HOMEBREW_DEVELOPER_DIR" => developer_dir }
  end

  def fetch
    ENV["ZIG_GLOBAL_CACHE_DIR"] = buildpath/"zig-cache"
    with_env(zig_env) do
      system zig, "build", "--fetch"
    end
    return if build.head?

    # Zig 0.14 stores Zul under a named hash, but Jetcommon looks up its legacy hash.
    cache = buildpath/"zig-cache/p"
    ln_s "zul-0.0.0-AAAAAB1CBwAz3vYuySVkzEk2y4cPRNnm6K7OFSv3K-Vk",
         cache/"122033def62ec92564cc4936cb870f44d9e6e8aece152bf72be564b1cac542638c76"
  end

  def install
    ENV["ZIG_GLOBAL_CACHE_DIR"] = buildpath/"zig-cache"
    with_env(zig_env) do
      system zig, "build", *std_zig_args
    end
    # Upstream only provides a static library; Zig consumers also need its modules.
    pkgshare.install "build.zig", "build.zig.zon", "src"
    (pkgshare/"zig-cache").install "zig-cache/p"
  end

  test do
    # FIXME: This is a Zig library and upstream does not expose a version command.
    cp_r pkgshare.children, testpath
    ENV["ZIG_GLOBAL_CACHE_DIR"] = testpath/"zig-cache"
    output = with_env(zig_env) do
      shell_output("#{zig} build test --summary all 2>&1")
    end
    assert_match "tests passed", output
    assert_match(/Compiled \d+ template\(s\)/, output)
  end
end
