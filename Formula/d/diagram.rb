class Diagram < Formula
  desc "CLI app to convert ASCII arts into hand drawn diagrams"
  homepage "https://github.com/esimov/diagram"
  url "https://github.com/esimov/diagram/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "f88bc99975ade753435ecf0e7a6470611f77563eb73b94d56fa6b6bafb4b8561"
  license "MIT"
  head "https://github.com/esimov/diagram.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_sequoia: "47955fbb4a0097aed6bc61c6cd4b8f7c9ed964a89c75abee70bccaf520526db3"
    sha256 arm64_sonoma:  "da8e4f2f8b66deb4de1f8a302db5ead49537b959feadef887e0901db5ae524bb"
    sha256 ventura:       "fd821a05fd75185b8e32eff60170f4e6f5cfc0f8dde2a956313f56413d32c041"
    sha256 x86_64_linux:  "45ca6bfaf016ec13bb22a2a9f8f2ba93e50b664b481672faacd461954f32475b"
  end

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
