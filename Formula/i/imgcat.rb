class Imgcat < Formula
  desc "Like cat, but for images"
  homepage "https://github.com/eddieantonio/imgcat"
  url "https://github.com/eddieantonio/imgcat/releases/download/v2.6.0/imgcat-2.6.0.tar.gz"
  sha256 "1e7e69670ad73e36ba1a9f0a09b6a787cf4e141dfe7885ae7ad77c293fb999a6"
  license "ISC"

  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    system "./configure", *std_configure_args
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/imgcat --version")

    resource "test_img" do
      url "https://raw.githubusercontent.com/eddieantonio/imgcat/master/tests/img/1px_8.png"
      sha256 "8d615bd3d56e46e7c201537d591081a98c459cd93e32cd59841c29a425a656b3"
    end
    testpath.install resource("test_img")

    assert_match "\e[40m \e[41m \e[42m \e[43m", shell_output("#{bin}/imgcat #{testpath}/1px_8.png")
  end
end
