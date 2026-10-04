class Xdgctl < Formula
  desc "Terminal UI for managing XDG default applications"
  homepage "https://github.com/mitjafelicijan/xdgctl"
  url "https://github.com/mitjafelicijan/xdgctl/archive/refs/tags/v1.1.tar.gz"
  sha256 "7c26adbff881ca15bf0801fce9016a02d52b331ebf40d57c677a1c054242648e"
  license "BSD-2-Clause"
  head "https://github.com/mitjafelicijan/xdgctl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "da633b9580d6f02bc06e7efcb78da328141d3304b62b12553c0ee4ba6e1b0ece"
    sha256 cellar: :any, x86_64_linux: "2a499d5c633b489675b235724dd099d568b02441b8a4cf56dcb6e83c0730c3c9"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on :linux

  deny_network_access!

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "xdgctl"
  end

  test do
    # FIXME: Upstream has no version command or headless interface; test terminal startup rejection
    # until a noninteractive default-application query or diagnostic is available.
    # termbox2 opens /dev/tty; setsid ensures this test cannot attach to a controlling terminal.
    defaults = testpath/".config/mimeapps.list"
    defaults.dirname.mkpath
    original = "[Default Applications]\nx-scheme-handler/http=homebrew-browser.desktop;\n"
    defaults.write original
    assert_equal "", shell_output("setsid #{bin}/xdgctl </dev/null 2>&1", 1)
    assert_equal original, defaults.read, "Failed terminal startup must preserve application defaults"
  end
end
