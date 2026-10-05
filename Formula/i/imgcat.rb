class Imgcat < Formula
  desc "Like cat, but for images"
  homepage "https://github.com/eddieantonio/imgcat"
  url "https://github.com/eddieantonio/imgcat/releases/download/v2.6.0/imgcat-2.6.0.tar.gz"
  sha256 "1e7e69670ad73e36ba1a9f0a09b6a787cf4e141dfe7885ae7ad77c293fb999a6"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9883b173598546d481336a75f5f933b2b42602f6e557ffe0e5d98402220db1bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "371b83117237c20f7e6f1141f4124d88ad3ec487cefa4a263ae261a9a47c1fb1"
    sha256 cellar: :any_skip_relocation, ventura:       "4d8111925cf72cee1f3931aaae913ac8f958f3d519013084620262947890d9e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de7aadac53f2e43aea7fec7da3675cb1a40e66ab2b9b468c9866a3ee983429ad"
  end

  depends_on "pkgconf" => :build # configure detects libpng/libjpeg via pkg-config
  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "ncurses"

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/imgcat --version")

    # fails on macos CI
    return if OS.mac?

    # 8x2 palette test image from upstream's tests/img/1px_8.png.
    png = %w[
      iVBORw0KGgoAAAANSUhEUgAAAAgAAAACBAMAAACXuoDeAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAA
      dTAAAOpgAAA6mAAAF3CculE8AAAAMFBMVEUDAwOAAwMDgAOAgAMDA4CAA4ADgIDAwMCAgID/AwMD/wP//wMDA///A/8D//////87
      K5LGAAAAAWJLR0QPGLoA2QAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB+EEHQYMGhNlgcEAAAASSURBVAjXY2BUdk1n6Fx9
      9j0ADCYDwSLH184AAAAldEVYdGRhdGU6Y3JlYXRlADIwMTgtMDUtMDVUMTA6NTg6MTctMDY6MDCCWaZyAAAAJXRFWHRkYXRlOm1v
      ZGlmeQAyMDE3LTA0LTI5VDEyOjEyOjI2LTA2OjAwZD2fjgAAAABJRU5ErkJggg==
    ].join
    (testpath/"1px_8.png").binwrite png.unpack1("m")

    assert_match "\e[40m \e[41m \e[42m \e[43m", shell_output("#{bin}/imgcat #{testpath}/1px_8.png")
  end
end
