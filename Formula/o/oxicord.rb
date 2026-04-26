class Oxicord < Formula
  desc "Lightweight, secure Discord terminal client written in Rust"
  homepage "https://github.com/linuxmobile/oxicord"
  url "https://github.com/linuxmobile/oxicord/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "eea5dcd301c14667167c31eeff83a97aba7132c76abd4cd72952693d79584369"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "66974ad71cca8d9c5da70bdaa9ae43bc4b57a12b7b6c2820efc89ef669a9a7f3"
    sha256                               arm64_sequoia: "6d4368d39416c225ac3038fc086f1199c0f7c66e6dbda07fcdd72f2f26a2f4d1"
    sha256                               arm64_sonoma:  "549f6c973bca83e6788a36919063d633428f9370b1098aaeced083ce13f86b8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08bd2fc43e6e3636c1e718f80f9f69ce93be849651fb30ca27a88d2e46d9ef41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01cbba8f0581d16d1ca79357cdaa071dd9406a658d134e5f4a685d44e53a6003"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "chafa"
  depends_on "gettext"
  depends_on "glib"

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # oxicord is a TUI app, so just verify the version output
    assert_match version.to_s, shell_output("#{bin}/oxicord --version")
  end
end
