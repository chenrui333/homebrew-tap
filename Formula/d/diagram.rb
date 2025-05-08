class Diagram < Formula
  desc "CLI app to convert ASCII arts into hand drawn diagrams"
  homepage "https://github.com/esimov/diagram"
  url "https://github.com/esimov/diagram/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "60e9be6bb9a5b149d32a2e3122227201c60abb7dd4fe1276c362431ce2ed80b7"
  license "MIT"
  head "https://github.com/esimov/diagram.git", branch: "master"

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "mesa"
  end

  def install
    inreplace "version/version.go", "1.0.4", version.to_s
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"diagram", "--version"
  end
end
