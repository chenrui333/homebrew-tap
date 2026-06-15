class Fnc < Formula
  desc "Interactive text-based user interface for Fossil"
  homepage "https://fnc.sh/"
  url "https://fnc.sh/uv/dl/fnc-0.18.tar.gz"
  sha256 "49f94c67e00213440d84f3b09bcf75850f9b6e8d8721856d68f4596c49cec780"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c47c6efc09ed55951d6740b9d8e1c8eabbfa09bcf97b911410091c3e3014b94b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c861f0eb664ea0b9332d3b7d3a182c0df32a4c3d9173e6704552562449f805f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "337d92a2fa019299d0441b4b8b1006fc89621b2d2e7dd0bf39a8662de2a58856"
    sha256 cellar: :any_skip_relocation, sequoia:       "64956185dc3f025960575bea0b21f82b5d118fa6a676a4136978c6407d46d251"
    sha256 cellar: :any,                 arm64_linux:   "a5a88c1aa75e30bd373fe445f95db33985ea9074fb1086ee2aba612ffef897aa"
    sha256 cellar: :any,                 x86_64_linux:  "516c963ad5b981e3e0ef9f919f5bd17dc7fc95b4f6520221ab9814eee1979647"
  end

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    require "open3"

    output, status = Open3.capture2e(bin/"fnc", "--version")
    if status.success?
      assert_match version.to_s, output
    else
      assert_match "stdin is not a tty", output
    end

    output = shell_output("#{bin}/fnc 2>&1", 1)
    assert_match(/stdin is not a tty|no work tree or repository found/, output)
  end
end
