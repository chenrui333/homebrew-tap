class Diagram < Formula
  desc "CLI app to convert ASCII arts into hand drawn diagrams"
  homepage "https://github.com/esimov/diagram"
  url "https://github.com/esimov/diagram/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "008594494e004c786ea65425abf10ba4ffef2e417102de83ece3ebdee5029c66"
  license "MIT"
  head "https://github.com/esimov/diagram.git", branch: "master"

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "vulkan-headers" => :build
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxfixes"
    depends_on "libxkbcommon"
    depends_on "mesa"
    depends_on "wayland"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.defaultFontFile=#{pkgshare}/gloriahallelujah.ttf")

    pkgshare.install ["sample.txt", "font/gloriahallelujah.ttf"]
  end

  test do
    cp pkgshare/"sample.txt", testpath
    pid = spawn bin/"diagram", "-in", "sample.txt", "-out", testpath/"output.png"
    sleep 1
    assert_path_exists testpath/"output.png"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
