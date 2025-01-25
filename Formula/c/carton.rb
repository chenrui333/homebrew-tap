class Carton < Formula
  desc "Watcher, bundler, and test runner for your SwiftWasm apps"
  homepage "https://github.com/swiftwasm/carton"
  url "https://github.com/swiftwasm/carton/archive/refs/tags/1.1.3.tar.gz"
  sha256 "3a0ff4ba68f68d7a84dbe1768f1af1db6575ea23d2c5be9069d58cbfa681dc9e"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d853189003a54db3e5fbb367e33f18246102bc47766b570dcc2f375b027002df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89ad220dcc8745113bcf675f746eebbdd482323fe1c88ab7967ac04c959bed0a"
    sha256 cellar: :any_skip_relocation, ventura:       "19549734dbf7fb96934dffb9b4df3d071e7986382d3fb55910dfb2e3c1c3f383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cba387440cd91f8ba1311c2a5f808df0e31ba3a0f9dd1d1c30687e390d7d04de"
  end

  depends_on xcode: ["14.3", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "curl"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/carton"
  end

  test do
    system bin/"carton", "--version"
  end
end
