class Nkt < Formula
  desc "TUI for fast and simple interacting with your BibLaTeX database"
  homepage "https://git.sr.ht/~fjebaker/nkt"
  url "https://git.sr.ht/~fjebaker/nkt/archive/0.3.1.tar.gz"
  sha256 "cfcede02c12cfe2fca4465fa3d87c03158202e4606c1ba3db46851dbb0451ccd"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~fjebaker/nkt", branch: "main"

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = []
    args << "-Dcpu=#{cpu}" if build.bottle?

    system "zig", "build", *std_zig_args, *args
  end

  test do
    system bin/"nkt", "init"
    assert_path_exists testpath/".nkt"

    system bin/"nkt", "log", "this is my first diary entry"

    system bin/"nkt", "task", "learn more about that thing", "--due", "monday"
    assert_match "learn more about that thing", (testpath/".nkt/tasklists/todo.json").read
  end
end
