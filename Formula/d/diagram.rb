class Diagram < Formula
  desc "CLI app to convert ASCII arts into hand drawn diagrams"
  homepage "https://github.com/esimov/diagram"
  url "https://github.com/esimov/diagram/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "f88bc99975ade753435ecf0e7a6470611f77563eb73b94d56fa6b6bafb4b8561"
  license "MIT"
  head "https://github.com/esimov/diagram.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_sequoia: "29a0c1a3ba4074cb011082d52ab33778018d5f6a6848ca47ec86a69420e64327"
    sha256 arm64_sonoma:  "0989fc6ea4934dda2388a1823c79936a615dc8f6c17722bd582e97e68c9f3ae0"
    sha256 ventura:       "d2c607eaa038c32a5704bea65edfd8095444a2d2b24de1afc06c4c65baf70d36"
    sha256 x86_64_linux:  "b703e55f519e80ea9d1b610cd1675422b9b58f75a70886bf13ad95aa6362f3bd"
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
