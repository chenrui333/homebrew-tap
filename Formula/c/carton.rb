class Carton < Formula
  desc "Watcher, bundler, and test runner for your SwiftWasm apps"
  homepage "https://github.com/swiftwasm/carton"
  url "https://github.com/swiftwasm/carton/archive/refs/tags/1.1.3.tar.gz"
  sha256 "3a0ff4ba68f68d7a84dbe1768f1af1db6575ea23d2c5be9069d58cbfa681dc9e"
  license "Apache-2.0"
  revision 1

  depends_on xcode: ["14.3", :build]

  uses_from_macos "swift" => :build

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
