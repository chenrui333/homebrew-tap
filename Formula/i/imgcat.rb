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

  depends_on "jpeg-turbo"
  depends_on "libpng"

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/imgcat --version")

    # fails on macos CI
    return if OS.mac?

    resource "test_img" do
      url "https://raw.githubusercontent.com/eddieantonio/imgcat/master/tests/img/1px_8.png"
      sha256 "8d615bd3d56e46e7c201537d591081a98c459cd93e32cd59841c29a425a656b3"
    end
    testpath.install resource("test_img")

    assert_match "\e[40m \e[41m \e[42m \e[43m", shell_output("#{bin}/imgcat #{testpath}/1px_8.png")
  end
end
