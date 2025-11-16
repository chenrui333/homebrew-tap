class Nkt < Formula
  desc "TUI for fast and simple interacting with your BibLaTeX database"
  homepage "https://git.sr.ht/~fjebaker/nkt"
  url "https://git.sr.ht/~fjebaker/nkt/archive/0.3.1.tar.gz"
  sha256 "cfcede02c12cfe2fca4465fa3d87c03158202e4606c1ba3db46851dbb0451ccd"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~fjebaker/nkt", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7a83a41ac29910fd0e1056261c1cb98168e7a190025bd0577c650b084f5843a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91ef94fb9cf73bf80c8da465f452e03c902d6df0f04c4a8c4700f10fda52361a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c006e2a1e3291d94e0dbe54c0b93927a695b4dd41f5a1af7a9aeb11743e129e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e644bab9bd1d5b494d72806c73d0bcc36da68e8c85170cd76f6a50e55deefae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3025c359b5955ada789071bed44c3ad913f5534a81acf99ea4c36b18e4321af"
  end

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
