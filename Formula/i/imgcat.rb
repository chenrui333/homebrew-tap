class Imgcat < Formula
  desc "Like cat, but for images"
  homepage "https://github.com/eddieantonio/imgcat"
  url "https://github.com/eddieantonio/imgcat/releases/download/v2.6.0/imgcat-2.6.0.tar.gz"
  sha256 "1e7e69670ad73e36ba1a9f0a09b6a787cf4e141dfe7885ae7ad77c293fb999a6"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12286a75b93b2f8f9fff4eb1a4bbf4ee6252f952db5669b5bb49fbfe298b6d72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ed0fda2c16df48bd9ee8fd007504f569d166a774990d9497c0d0eeaf6d0b0bb"
    sha256 cellar: :any,                 arm64_linux:   "cea825eecc451ad92fd0cd1a0de03d39a5c4ad10db1583f66463e97171288472"
    sha256 cellar: :any,                 x86_64_linux:  "37164d92436248422a485f91bb721a98f35f1b5495e4d5bac26709791489e5c0"
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
