class Xdgctl < Formula
  desc "TUI for managing XDG default applications"
  homepage "https://github.com/mitjafelicijan/xdgctl"
  url "https://github.com/mitjafelicijan/xdgctl/archive/refs/tags/v1.1.tar.gz"
  sha256 "7c26adbff881ca15bf0801fce9016a02d52b331ebf40d57c677a1c054242648e"
  license "BSD-2-Clause"

  depends_on "glib"
  depends_on "pkgconf" => :build

  deny_network_access!

  def install
    system "make"
    bin.install "xdgctl"
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = pipe_output("#{bin}/xdgctl", "q")
    assert_match "Web Browser", output
  end
end
